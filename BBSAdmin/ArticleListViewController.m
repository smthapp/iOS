//
//  ArticleListViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 1/16/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "ArticleListViewController.h"
#import "ArticleContentEditController.h"
#import "ArticleContentViewController.h"
#import "UserData.h"
#import "UIViewController+AppGet.h"

#define ARTICLE_PAGE_SIZE 20

@interface ArticleListViewController ()

@end

@implementation ArticleListViewController
@synthesize m_tableView;
@synthesize m_mtarrayInfo;
@synthesize buttonNewArt;
@synthesize navi, searchbar;

- (void)viewDidLoad
{
    [super viewDidLoad];

    m_mtarrayInfo = [NSMutableArray arrayWithCapacity:10];
    articles_cnt = 0;
    submode_search = false;
    as_mode = 0;
    
    if(mode == ArticleListModeMail || mode == ArticleListModeMailSent){
        UIBarButtonItem* newmail = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"新邮件", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(pressBtNewArt:)];
        
        navi.rightBarButtonItem = newmail;
    }else if(mode == ArticleListModeHot){
        navi.rightBarButtonItem = nil;
    }else if(mode == ArticleListModeRefer){
        navi.rightBarButtonItem = nil;
    }else{
    }

    if (mode == ArticleListModeHot) {
        menu_items = @[@"全站", @"社区管理", @"国内院校", @"休闲娱乐", @"五湖四海", @"游戏运动", @"社会信息", @"知性感性", @"文化人文", @"学术科学", @"电脑技术"];
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, 44);
        menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"全站 热点" :nil];
        [menu displayMenuInView:self.view];
        menu.items = menu_items;
        menu.delegate = self;
        navi.titleView = menu;
    }else if(mode == ArticleContentViewModeNormal){
        menu_items = @[@"搜索版内文章", @"收藏本版", @"关注本版(驻版)"];
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, 44);
        menu = [[SINavigationMenuView alloc] initWithFrame:frame title:m_lBoardName :@"arrow_search.png"];
        [menu displayMenuInView:self.view];
        menu.items = menu_items;
        menu.delegate = self;
        navi.titleView = menu;
        
        in_search = false;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableview_tapped)];
    }
    
    [self initContent];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}



-(void)hide_searchbar
{
    [searchbar resignFirstResponder];
    [searchbar setHidden:YES];
    in_search = false;
    [m_tableView removeGestureRecognizer:tap];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self hide_searchbar];
    navi.titleView = menu;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self hide_searchbar];
    
    navi.titleView = nil;
    if(searchbar.selectedScopeButtonIndex == 0){
        [self search_title:searchbar.text];
        
        navi.title = @"搜索标题";
    }else{
        [self search_user:searchbar.text];
        
        navi.title = @"搜索作者";
    }
}

-(void)tableview_tapped{
    if(in_search) {
        [self hide_searchbar];
    }
}

- (void)as_setfav
{
    NSString * strAct;
    strAct = @"收藏";
    [net_smth net_AddFav:m_lBoardId];
    
    if(net_smth->net_error == 0){
        UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@成功",strAct] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [altview show];
    }
}

- (void)as_setmember
{
    int join_result;
    
    NSString * strAct;
    strAct = @"关注(驻版)";
    join_result = [net_smth net_JoinMember:m_lBoardId];
    
    if(net_smth->net_error == 0){
        NSString * msg;
        if(join_result == 0){
            msg = @"关注成功，您已是正是驻版用户";
        }else{
            msg = @"关注成功，尚需管理员审核成为正是驻版用户";
        }
        UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [altview show];
    }
}


- (void)didSelectItemAtIndex:(NSUInteger)index
{
    if(mode == ArticleListModeHot){
        hotmode_section = (int)index;
        [menu setMenuTitle:[NSString stringWithFormat:@"%@ 热点",[menu_items objectAtIndex:index]]];
    
        [self initContent];
    }else if(mode == ArticleListModeNormal) {
        if(index == 0){
            [searchbar setHidden:NO];
            [searchbar becomeFirstResponder];
            in_search = true;
            
            [m_tableView addGestureRecognizer:tap];
        }else if(index == 1){
            as_mode = 1;
            [self loadContent];
        }else if(index == 2){
            as_mode = 2;
            [self loadContent];
        }
    }
}

- (void)initCurDate
{
    cur_time = [[NSDate date] timeIntervalSince1970];
}

- (void)initContent
{
    load_init_mode = 1;
    [self loadContent];
}

- (void)moreContent
{
    load_init_mode = 0;
    [self loadContent];
}

- (IBAction)pressBtnBack:(id)sender
{
    if(submode_search){
        submode_search = false;
        
        navi.titleView = menu;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [m_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        [self initContent];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)pressBtNewArt:(id)sender {
    if(mode == ArticleListModeNormal || mode == ArticleListModeMail || mode == ArticleListModeMailSent){
        ArticleContentEditController *artcontEditController = [UIViewController appGetView:@"ArtContEditController"];
        
        if(mode == ArticleListModeMail || mode == ArticleListModeMailSent){
            [artcontEditController setContentInfo:true :nil :nil :nil :false];
        }else{
            [artcontEditController setContentInfo:false :m_lBoardId :m_lBoardName :nil :false];
        }
        [self presentViewController:artcontEditController animated:YES completion:nil];
    }else{
        return;
    }
}




-(void)setHotmode:(int)section
{
    mode = ArticleListModeHot;
    hotmode_section = section;
}

-(void)setBoardArticleMode:(NSString *)boardid :(NSString *)boardname
{
    mode = ArticleListModeNormal;
    m_lBoardId = [boardid copy];
    if(boardname == nil || [boardname isEqualToString:@""]){
        m_lBoardName = nil;
    }else{
        m_lBoardName = [boardname copy];
    }
}

-(void)setRefermode:(int)refer_submode
{
    mode = ArticleListModeRefer;
    refermode = refer_submode;
}

-(void)setMailmode:(int)sent
{
    if(sent){
        mode = ArticleListModeMailSent;
    }else{
        mode = ArticleListModeMail;
    }
}

-(void)settitle
{
    if(submode_search){
    }else{
        if(mode == ArticleListModeHot){
        }else if(mode == ArticleListModeNormal){
            if(m_lBoardName != nil){
                [menu setMenuTitle:m_lBoardName];
            }else{
                [menu setMenuTitle:m_lBoardId];
            }
        }else if(mode == ArticleListModeMail){
            navi.title = @"收件箱";
        }else{
            if(refermode == 1){
                navi.title = @"@我的文章";
            }else{
                navi.title = @"回复我的文章";
            }
        }
    }
}

-(void)parseContent
{
    if(as_mode) {
        if(as_mode == 1){
            [self as_setfav];
        }
        if(as_mode == 2){
            [self as_setmember];
        }
        as_mode = 0;
        //as mode don't need update UI
        return;
    }

    net_ops = 2;
    
    if(load_init_mode){
        long new_articles_cnt;
        
        if(submode_search){
            articles_cnt = 0;
        }else{
            
            if(mode == ArticleListModeHot){
                new_articles_cnt = 10;
            }else if(mode == ArticleListModeNormal){
                new_articles_cnt = [net_smth net_GetThreadCnt:m_lBoardId];
                
                last_read_artid = apiGetUserData_BRC(m_lBoardId);
                
                //new_articles_cnt = apiNetGetArticleCnt(m_lBoardId, &error);
            }else if(mode == ArticleListModeMail){
                NSDictionary * dict = [net_smth net_GetMailCount];
                if(dict) {
                    new_articles_cnt = [(NSString*)[dict objectForKey:@"total_count"] intValue];
                }else{
                    new_articles_cnt = 0;
                }
            }else if(mode == ArticleListModeMailSent) {
                new_articles_cnt = [net_smth net_GetMailCountSent];
            }else{
                NSDictionary * dict = [net_smth net_GetReferCount:refermode];
                if(dict) {
                    new_articles_cnt = [(NSString*)[dict objectForKey:@"total_count"] intValue];
                }else{
                    new_articles_cnt = 0;
                }
            }
            
            if(new_articles_cnt == articles_cnt){
                //no update
                //return;
            }
            articles_cnt = new_articles_cnt;
        }
        
        [m_mtarrayInfo removeAllObjects];
        
        if(submode_search){
            from = 0;
            load_size = ARTICLE_PAGE_SIZE;
        }else{
            //set init load
            if(mode == ArticleListModeMail || mode == ArticleListModeMailSent || mode == ArticleListModeRefer){
                from = articles_cnt;
            }else{
                from = 0;
            }
            size=0;
            
            if(articles_cnt > ARTICLE_PAGE_SIZE){
                load_size = ARTICLE_PAGE_SIZE;
            }else{
                load_size = articles_cnt;
            }
        }
    }else{
        if(! submode_search){
            if(mode == ArticleListModeMail || mode == ArticleListModeMailSent || mode == ArticleListModeRefer){
                if(from > ARTICLE_PAGE_SIZE){
                    load_size = ARTICLE_PAGE_SIZE;
                }else{
                    load_size = from;
                }
            }else{
                load_size = articles_cnt - from;
                if(load_size > ARTICLE_PAGE_SIZE) {
                    load_size = ARTICLE_PAGE_SIZE;
                }
            }
        }
    }
    
    NSArray *arrayInfo;
    
    if(submode_search) {
        arrayInfo = [net_smth net_SearchArticle:m_lBoardId :query_title :query_user :from :load_size];
    }else{
        if(mode == ArticleListModeHot){
            arrayInfo = [net_smth net_LoadSectionHot:hotmode_section];
        }else if(mode == ArticleListModeNormal){
            arrayInfo = [net_smth net_LoadThreadList:m_lBoardId :from :load_size :appSetting->brcmode];
        }else if(mode == ArticleListModeMail){
            arrayInfo = [net_smth net_LoadMailList:from-load_size :load_size];
        }else if(mode == ArticleListModeMailSent){
            arrayInfo = [net_smth net_LoadMailSentList:from-load_size :load_size];
        }else{
            arrayInfo = [net_smth net_LoadRefer:refermode :from-load_size :load_size];
        }
    }
    
    if (submode_search && net_smth->net_error == 0 && [arrayInfo count] == 0 && from == 0){
        m_bLoadRes = 1;
        [m_mtarrayInfo removeAllObjects];
    }else if (net_smth->net_error == 0 && [arrayInfo count] > 0)
    {
        m_bLoadRes = 1;
        [self initCurDate];
        
        if(submode_search){
            NSEnumerator * e = [arrayInfo objectEnumerator];
            for(id ele in e){
                [m_mtarrayInfo addObject:ele];
            }
            
            size += [arrayInfo count];
            from += [arrayInfo count];
        }else if(mode == ArticleListModeMail || mode == ArticleListModeMailSent || mode == ArticleListModeRefer){
            NSEnumerator * e = [arrayInfo reverseObjectEnumerator];
            for(id ele in e){
                [m_mtarrayInfo addObject:ele];
            }
            
            size += load_size;
            from -= load_size;
        }else{
            NSEnumerator * e = [arrayInfo objectEnumerator];
            for(id ele in e){
                if(m_lBoardName == nil){
                    m_lBoardName = [ele objectForKey:@"board_name"];
                    navi.title = m_lBoardName;
                }
                [m_mtarrayInfo addObject:ele];
            }
            
            if(mode != ArticleListModeHot) {
                if(from == 0){
                    //calc last_read_id
                    long long int _latest_read = 0;
                    for(NSDictionary * dict in m_mtarrayInfo){
                        NSString * flags = [dict objectForKey:@"flags"];
                        NSString * flag0 = [flags substringToIndex:1];
                        if([flag0 isEqualToString:@"d"] || [flag0 isEqualToString:@"D"]){
                            //skip ding
                            continue;
                        }
                        _latest_read = [(NSString *)[dict objectForKey:@"last_reply_id"] longLongValue] ;
                        break;
                    }
                    if(_latest_read){
                        apiSetUserData_BRC(m_lBoardId, _latest_read);
                    }
                    
                    //update board history
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:m_lBoardId forKey:@"id"];
                    [dict setObject:m_lBoardName forKey:@"name"];
                    apiSetUserData_add_bhis(dict);
                }
                
                size += load_size;
                from += load_size;
            }
        }
        
        //[m_mtarrayInfo addObjectsFromArray:arrayInfo];
    }
}

#pragma mark - UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (bool)scroll_enabled
{
    if(mode == ArticleListModeHot){
        return false;
    }else{
        return true;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#ifdef DEBUG
    //NSLog(@"number of rows");
#endif
    if(mode == ArticleListModeHot){
        return [m_mtarrayInfo count];
    }else if(!submode_search && mode == ArticleListModeNormal){
        return [m_mtarrayInfo count] + 1;
    }else{
        return [m_mtarrayInfo count] + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        return 54.0f;
    }else{
        return 60.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef DEBUG
    //NSLog(@"cellforrow:%d", indexPath.row);
#endif
    int type=0; //0:article, 2:more
    int article_idx = (int)indexPath.row;
    
    {
        if(indexPath.row >= [m_mtarrayInfo count]){
            type = 2;
        }else{
            type = 0;
        }
    }
    
    //'more' cell
    if(type == 2){
        static NSString *more_cellId = @"ArtListCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:more_cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:more_cellId];
        }
        
        //clear cell
        [cell setBackgroundColor:[UIColor clearColor]];
        
        //load more
        cell.textLabel.text = @"点击加载更多";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;
    }else{
        //article cell
        static NSString *cellId;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            cellId = @"ArticleInfoCell_iPad";
        else
            cellId = @"ArticleInfoCell_iPhone";
        ArticleInfoCell *cell = (ArticleInfoCell*)[self.m_tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
            cell = (ArticleInfoCell*)[nibArray objectAtIndex:0];
        }
        
        //clear cell
        [cell setBackgroundColor:[UIColor clearColor]];
    
        NSDictionary *dict = [m_mtarrayInfo objectAtIndex:(article_idx)];
        if (dict)
        {
            //标题左下方
            NSString * strTime;
            if(mode == ArticleListModeHot){
                //十大，显示版面
                strTime = [NSString stringWithFormat:@"版面:%@", (NSString *)[dict objectForKey:@"board"]];
            }else{
                //普通文章，提醒，邮件，显示发表时间
                strTime = appGetDateString([(NSString *)[dict objectForKey:@"time"] intValue], cur_time);
            }

            //标题右下方
            NSString * strReplyTime = @"";
            int reply_unread = 0;
            int reply_count = 0;
            if(mode == ArticleListModeMail || mode == ArticleListModeMailSent){
                //邮件，不显示
            }else if(mode != ArticleListModeRefer){
                //十大或者普通文章，显示回复数
                reply_count = [(NSString *)[dict objectForKey:@"count"] intValue];
                if(reply_count > 0){
                    reply_count --;
                }
                NSString * strLastTime;
                if(reply_count > 0){
                    strLastTime = appGetDateString([(NSString *)[dict objectForKey:@"last_time"] intValue], cur_time);
                }else{
                    strLastTime = @"";
                }
                strReplyTime = [NSString stringWithFormat:@"[%d]%@", reply_count, strLastTime];
                
                if(reply_count > 0 && mode == ArticleListModeNormal && last_read_artid){
                    if([(NSString *)[dict objectForKey:@"last_reply_id"] longLongValue] > last_read_artid){
                        reply_unread = 1;
                    }
                }
            }else{
                //提醒，显示版面
                strReplyTime = [NSString stringWithFormat:@"版面:%@", (NSString *)[dict objectForKey:@"board_id"]];
            }
            
            int unread = 0;
            int att = 0;
            int ding = 0;
            if(mode == ArticleListModeNormal){
                NSString * flags = [dict objectForKey:@"flags"];
                NSString * flag0 = [flags substringToIndex:1];
                if([flag0 isEqualToString:@"*"]){
                    unread = 1;
                }
                if([flag0 isEqualToString:@"d"] || [flag0 isEqualToString:@"D"]){
                    ding = 1;
                }
                if([[[flags substringToIndex:4] substringFromIndex:3] isEqualToString:@"@"]){
                    att = 1;
                }
            }else if(mode == ArticleListModeRefer){
                int flag = [(NSString *)[dict objectForKey:@"flag"] intValue];
                if(flag == 0){
                    unread = 1;
                }
            }else if(mode == ArticleListModeMail){
                NSString * flags = [dict objectForKey:@"flags"];
                NSString * flag0 = [flags substringToIndex:1];
                
                if([flag0 isEqualToString:@"N"]){
                    unread = 1;
                }
            }
            
            //发信人
            NSString * author;
            if(mode == ArticleListModeRefer) {
                author = [dict objectForKey:@"user_id"];
            }else{
                author = [dict objectForKey:@"author_id"];
            }
            
            [cell setContentInfo:[dict objectForKey:@"subject"] :author :strTime :strReplyTime :att :unread :ding :reply_unread :reply_count :self];
            
        }
        
        return cell;
    }

}

- (void)search_title:(NSString *)_query
{
    query_title = [_query copy];
    query_user = nil;

    submode_search = true;
    [self initContent];
}

- (void)search_user:(NSString *)_query
{
    query_title = nil;
    query_user = [_query copy];
    
    submode_search = true;
    [self initContent];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int type=0; //0:article, 1:search, 2:more
    int article_idx = (int)indexPath.row;
    
    {
        if(indexPath.row >= [m_mtarrayInfo count]){
            type = 2;
        }else{
            type = 0;
        }
    }
    
    if (type == 2){
        [self moreContent];
    }else{
        NSDictionary *dict = [m_mtarrayInfo objectAtIndex:(article_idx)];
        if (dict){
            long article_id = [(NSString*)[dict objectForKey:@"id"] intValue];
            if(mode == ArticleListModeHot){
                [self showArticleContent:[dict objectForKey:@"board"] :nil :article_id :[(NSString *)[dict objectForKey:@"count"] intValue]];
            }else if(mode == ArticleListModeNormal){
                [self showArticleContent:m_lBoardId :m_lBoardName :article_id :[(NSString *)[dict objectForKey:@"count"] intValue]];
            }else if(mode == ArticleListModeMail){
                [self showArticleContent:nil :nil :0 :[(NSString*)[dict objectForKey:@"position"] intValue]];
                NSString * flags = [dict objectForKey:@"flags"];
                NSString * flag0 = [flags substringToIndex:1];
                
                if([flag0 isEqualToString:@"N"]){
                    //unread article, after read this, force check unread again
                    appSetting->unread_apns_cnt = 1;
                }
            }else if(mode == ArticleListModeMailSent){
                [self showArticleContent:nil :nil :0 :[(NSString*)[dict objectForKey:@"position"] intValue]];
            }else{
                [self showArticleContent:[dict objectForKey:@"board_id"] :nil :[(NSString*)[dict objectForKey:@"id"] intValue] :[(NSString*)[dict objectForKey:@"position"] intValue]];
                int flag = [(NSString *)[dict objectForKey:@"flag"] intValue];
                if(flag == 0){
                    //unread article, after read this, force check unread again
                    appSetting->unread_apns_cnt = 1;
                }
            }

        }
    }
    
    [m_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//position: normalmode: article_cnt; refermode:position; mailmode:position
-(void)showArticleContent:(NSString *)boardid :(NSString *)boardname :(long)art_id :(int)position
{
    ArticleContentViewController *artcontViewController = [UIViewController appGetView:@"ArtContViewController"];
    
    if(mode == ArticleListModeRefer) {
        [artcontViewController setContentInfo:refermode :position :boardid :boardname :art_id :0];
    }else if(mode == ArticleListModeMail){
        [artcontViewController setContentInfo:10 :position :boardid :boardname :art_id :0];
    }else if(mode == ArticleListModeMailSent){
        [artcontViewController setContentInfo:11 :position :boardid :boardname :art_id :0];
    }else{
        [artcontViewController setContentInfo:0 :0 :boardid :boardname :art_id :position];
    }
    [self presentViewController:artcontViewController animated:YES completion:nil];
}

- (void)updateContent
{
    if(load_init_mode != 0){
        [self settitle];
    }
    [m_tableView reloadData];
}

@end
