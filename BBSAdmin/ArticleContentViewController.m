//
//  ArticleContentViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 1/20/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "ArticleContentViewController.h"
#import "ArticleContentCell.h"
#import "ArticleContentEditController.h"
#import "ArticleForwardViewController.h"
#import "UIViewController+AppGet.h"
#import "ArticleListViewController.h"
#import "MBSelectViewController.h"

#define THREAD_PAGE_SIZE 10

@interface ArticleContentViewController ()

@end

@implementation ArticleContentViewController
@synthesize m_tableView;
@synthesize m_mtarrayInfo;
@synthesize navi;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    m_mtarrayInfo = [NSMutableArray arrayWithCapacity:10];
    waiting_for_cross = false;
    
    if(mode != ArticleContentViewModeNormal || m_lBoardId == nil || (m_lBoardName != nil && ![m_lBoardName isEqualToString:@""])){
        navi.rightBarButtonItem = nil;
    }
    
    [self initContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(waiting_for_cross){
        cross_target = apiGetMBSelect();
        
        if(cross_target != nil){
            [self loadContent];
        }else{
            waiting_for_cross = false;
        }
    }
}

- (void)initContent
{
    [m_mtarrayInfo removeAllObjects];
    size = 0;
    
    [self loadContent];
}

- (IBAction)pressBtnGoboard:(id)sender {
    
    ArticleListViewController *artlistViewController = [UIViewController appGetView:@"ArtListViewController"];
    
    
    [artlistViewController setBoardArticleMode:m_lBoardId :nil];

    [self presentViewController:artlistViewController animated:YES completion:nil];
}

-(NSMutableArray *)parseAtt:(NSDictionary *)dict
{
    if(appSetting->attachment_images_size == 2){
        return nil;
    }
    NSArray *array_att = [dict objectForKey:@"attachment_list"];
    if(array_att == nil || [array_att count] <= 0){
        return nil;
    }
    
    NSMutableArray * retArray = [[NSMutableArray alloc] init];
    
    int i;
    for(i=0; i<[array_att count]; i++){
        NSDictionary * att = [array_att objectAtIndex:i];
        if(att == nil){
            continue;
        }
        
        NSString *att_fname = @"";
        id att_fname_id = [att objectForKey:@"name"];
        if(att_fname_id == [NSNull null]){
            continue;
        }
        att_fname = (NSString *)att_fname_id;
        
        NSString * att_fname_ext = [att_fname pathExtension];
        if(att_fname_ext == nil) {
            continue;
        }
        if([att_fname_ext compare:@"jpg" options:NSCaseInsensitiveSearch] != NSOrderedSame
           && [att_fname_ext compare:@"jpeg" options:NSCaseInsensitiveSearch] != NSOrderedSame
           && [att_fname_ext compare:@"gif" options:NSCaseInsensitiveSearch] != NSOrderedSame
           && [att_fname_ext compare:@"bmp" options:NSCaseInsensitiveSearch] != NSOrderedSame
           && [att_fname_ext compare:@"png" options:NSCaseInsensitiveSearch] != NSOrderedSame
           
           ){
            continue;
        }

        NSMutableDictionary * ret_dict = [NSMutableDictionary dictionaryWithDictionary:att];
        
        UIAttImageView * imageview = [[UIAttImageView alloc] init];
        __unused int exist = [imageview setContentInfo:m_lBoardId :[(NSString *)[dict objectForKey:@"id"] intValue] :[(NSString *)[att objectForKey:@"pos"] intValue] :appSetting->attachment_images_size :1 :self];
        
        [ret_dict setObject:imageview forKey:@"imgview"];
    
        [retArray addObject:ret_dict];
    }
    
    if([retArray count] <= 0){
        return nil;
    }
    return retArray;
}

-(void)setContentInfo:(int)art_mode :(int)art_position :(NSString *)boardid :(NSString *)boardname :(long)art_id :(long)cnt
{
    if(art_mode == 0){
        mode = ArticleContentViewModeNormal;
    }else if(art_mode == 10){
        mode = ArticleContentViewModeMail;
        mailposition = art_position;
    }else if(art_mode == 11){
        mode = ArticleContentViewModeMailSent;
        mailposition = art_position;
    }else{
        mode = ArticleContentViewModeRefer;
        refermode = art_mode;
        referposition = art_position;
    }
    
    if(boardid) {
        m_lBoardId = [boardid copy];
    }
    if(boardname) {
        m_lBoardName = [boardname copy];
    }
    article_id = art_id;

    article_cnt = cnt;
}

-(void)add_article_with_att:(NSDictionary *)art
{
    NSMutableDictionary * newart = [[NSMutableDictionary alloc] initWithDictionary:art];
    NSMutableArray * att_array = [self parseAtt:art];
    if(att_array) {
        [newart setObject:att_array forKey:@"att_array"];
    }
    [m_mtarrayInfo addObject:newart];
}

-(void)add_articles_with_att:(NSArray *)arts
{
    NSEnumerator * e = [arts objectEnumerator];
    for(NSDictionary * ele in e){
        [self add_article_with_att:ele];
    }
}


-(void)parseContent
{
    if(waiting_for_cross) {
        waiting_for_cross = false;
        
        [net_smth net_CrossArticle:m_lBoardId :[[reply_dict objectForKey:@"id"] intValue] :cross_target];
        return;
    }

    if(mode == ArticleContentViewModeNormal){
        NSArray * arrayInfo = [net_smth net_GetThread:m_lBoardId :article_id :size :THREAD_PAGE_SIZE :appSetting->article_sort];
        if (net_smth->net_error == 0)
        {
            m_bLoadRes = 1;
            article_cnt = [net_smth net_GetLastThreadCnt];
            //add single article
            //[m_mtarrayInfo addObject:arrayInfo];
            [self add_articles_with_att:arrayInfo];
            
            size = [m_mtarrayInfo count];
        }
    }else if(mode == ArticleContentViewModeRefer){
        NSDictionary * arrayInfo = [net_smth net_GetArticle:m_lBoardId :article_id];
        if (net_smth->net_error == 0)
        {
            m_bLoadRes = 1;
            //add single article
            [self add_article_with_att:arrayInfo];
        }
        if(net_smth->net_error == 0 || net_smth->net_error == 11011) {
            //11011:文章不存在，已经被删除，那么也需要青未读标记
            int old_net_error = net_smth->net_error;
            [net_smth net_SetReferRead:refermode :referposition];
            net_smth->net_error = old_net_error;
        }
    }else{
        //邮件模式
        NSDictionary * arrayInfo;
        if(mode == ArticleContentViewModeMail){
            arrayInfo = [net_smth net_GetMail:mailposition];
        }else{
            arrayInfo = [net_smth net_GetMailSent:mailposition];
        }
        if (net_smth->net_error == 0)
        {
            m_bLoadRes = 1;
            //add single article
            [self add_article_with_att:arrayInfo];
        }
    }
}

-(bool)scroll_enabled
{
    if(mode != ArticleContentViewModeNormal){
        return false;
    }
    
    //显示满了不再刷新
    if([m_mtarrayInfo count] >= article_cnt){
        return false;
    }
    
    return true;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_mtarrayInfo count];
}

- (ArticleContentCell *)get_height_cell:(NSIndexPath *)indexPath
{
    static NSString *cellId;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        cellId = @"ArticleContentCell_iPad";
    else
        cellId = @"ArticleContentCell_iPhone";
    ArticleContentCell *cell = (ArticleContentCell*)[self.m_tableView dequeueReusableCellWithIdentifier:@"ArticleContentCell_Height_buffer"];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell = (ArticleContentCell*)[nibArray objectAtIndex:0];
    }
    
    [cell init_fontsize];
    [cell clear_image];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleContentCell *cell = (ArticleContentCell*)[self get_height_cell:indexPath];

    NSDictionary *dict = nil;
    if(indexPath.row < [m_mtarrayInfo count]){
        dict = [m_mtarrayInfo objectAtIndex:(indexPath.row)];
    }
    if(dict == nil){
        return 150.0f;
    }
    
    CGFloat cell_height = [cell get_height:[dict objectForKey:@"body"] :[dict objectForKey:@"att_array"]];

    if(indexPath.row == 0){
        return cell_height + 10;
    }else{
        return cell_height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cell for row:%d", indexPath.row);
    
    static NSString *cellId;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        cellId = @"ArticleContentCell_iPad";
    else
        cellId = @"ArticleContentCell_iPhone";
    ArticleContentCell *cell = (ArticleContentCell*)[self.m_tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //NSLog(@"new cell");
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell = (ArticleContentCell*)[nibArray objectAtIndex:0];
    }
    
    //clear cell
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell init_fontsize];
    [cell clear_image];
    
    NSDictionary *dict = nil;
    if(indexPath.row < [m_mtarrayInfo count]){
        dict = [m_mtarrayInfo objectAtIndex:(indexPath.row)];
    }
    if (dict)
    {
        NSString * title = [dict objectForKey:@"subject"];
        NSString * author = [dict objectForKey:@"author_id"];
        NSString * body = [dict objectForKey:@"body"];

        //date string
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:( [(NSString*)[dict objectForKey:@"time"] intValue]) ];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [dateFormatter stringFromDate:date];

        //set cell
        int lou = 0;
        if(mode == ArticleContentViewModeNormal){
            if(appSetting->article_sort == 0){
                if(indexPath.row == 0){
                }else{
                    lou = (int)article_cnt - (int)indexPath.row;
                    if(lou < 1){
                        lou = 1;
                    }
                }
            }else{
                lou = (int)indexPath.row;
            }
        }else{
            lou = -1;
        }
        
        if(indexPath.row == 0 && title && ![title isEqualToString:@""]){
            navi.title = title;
        }
        
        [cell setContentInfo:title :author :dateStr :body :lou :[dict objectForKey:@"att_array"] :m_tableView :indexPath :self];
    }else{
        [cell setContentInfo:@"ERROR" :@"ERROR" :@"1970-01-01\n00:00:00" :@"sys error." :-1 :nil :m_tableView :indexPath :self];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= [m_mtarrayInfo count]) {
        return;
    }
    reply_dict = [m_mtarrayInfo objectAtIndex:(indexPath.row)];
    if (reply_dict == nil){
        return;
    }
    
    UIActionSheet * as;
    
    if(mode == ArticleContentViewModeMail){
        as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复", @"转寄", nil];
        as_action[0] = 1;
        as_action[1] = 3;
        as_action[2] = 0;
        as_action[3] = 0;
    }else if(mode == ArticleContentViewModeMailSent){
        //发件箱不支持任何功能
        return;
    }else{
        NSString * strFlags = [reply_dict objectForKey:@"flags"];
        NSRange t_range = NSMakeRange(2, 1);
        if([strFlags compare:@"y" options:NSCaseInsensitiveSearch range:t_range] == NSOrderedSame){
#ifdef DEBUG
            NSLog(@"readonly article");
#endif
            as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"私信回复", @"转寄", @"转发到版面", nil];
            as_action[0] = 2;
            as_action[1] = 3;
            as_action[2] = 4;
            as_action[3] = 0;
        }else{
            as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复", @"私信回复", @"转寄", @"转发到版面", nil];
            as_action[0] = 1;
            as_action[1] = 2;
            as_action[2] = 3;
            as_action[3] = 4;
        }
    }
    
    as_indexpath = indexPath;
    [as setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [as showInView:self.view];
    return;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
#ifdef DEBUG
    NSLog(@"press:%ld", (long)buttonIndex);
#endif
    
    if(as_indexpath){
        [m_tableView deselectRowAtIndexPath:as_indexpath animated:NO];
        as_indexpath = nil;
    }
    
    if(buttonIndex >= 4){
        return;
    }
    
    switch(as_action[buttonIndex]){
        case 1:
            [self as_reply];
            break;
        case 2:
            [self as_emailreply];
            break;
        case 3:
            [self as_forward];
            break;
        case 4:
            [self as_cross];
            break;
        default:
            break;
    }
}

- (void)as_reply
{
    ArticleContentEditController *artcontEditController = [UIViewController appGetView:@"ArtContEditController"];
    
    if(mode == ArticleContentViewModeMail){
        [artcontEditController setContentInfo:true :nil :nil :reply_dict :false];
    }else if(mode == ArticleContentViewModeMailSent) {
        return;
    }else{
        [artcontEditController setContentInfo:false :m_lBoardId :m_lBoardName :reply_dict :false];
    }
    [self presentViewController:artcontEditController animated:YES completion:nil];
}

- (void)as_emailreply
{
    ArticleContentEditController *artcontEditController = [UIViewController appGetView:@"ArtContEditController"];
    
    if(mode == ArticleContentViewModeMail){
        [artcontEditController setContentInfo:true :nil :nil :reply_dict :false];
    }else if(mode == ArticleContentViewModeMailSent){
        return;
    }else{
        [artcontEditController setContentInfo:true :nil :nil :reply_dict :true];
    }
    [self presentViewController:artcontEditController animated:YES completion:nil];
}

- (void)as_forward
{
    ArticleForwardViewController * artFwdController = [UIViewController appGetView:@"ArtForwardController"];
    
    if(mode == ArticleContentViewModeMail){
        [artFwdController setContentInfo:false :nil :nil :reply_dict];
    }else if(mode == ArticleContentViewModeMailSent){
        return;
    }else{
        [artFwdController setContentInfo:true :m_lBoardId :m_lBoardName :reply_dict];
    }
    [self presentViewController:artFwdController animated:YES completion:nil];
}

- (void)as_cross
{
    if(mode == ArticleContentViewModeMail){
        return;
    }else if(mode == ArticleContentViewModeMailSent){
        return;
    }else{
        waiting_for_cross = true;
        
        MBSelectViewController *artcontEditController = [UIViewController appGetView:@"MBSelectViewController"];
        
        [self presentViewController:artcontEditController animated:YES completion:nil];
    }
}

- (void)updateContent
{
    [m_tableView reloadData];
}

@end