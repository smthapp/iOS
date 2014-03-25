//
//  TimelineListViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/10/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "TimelineListViewController.h"
#import "ArticleContentViewController.h"
#import "UserData.h"
#import "ArticleContentEditController.h"
#import "UIViewController+AppGet.h"
#import "ArticleListViewController.h"
#import "BoardListViewController.h"
#import "SectionListCell.h"
#import "MBSelectViewController.h"

#define ARTICLE_PAGE_SIZE 20

TimelineListViewController * timeline_view_controller = nil;

@interface TimelineListViewController ()

@end

@implementation TimelineListViewController
@synthesize m_mtarrayInfo,m_tableView;
@synthesize navi, searchbar;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    m_mtarrayInfo = [NSMutableArray arrayWithCapacity:10];
    waiting_for_mbselect = false;

    menu_items = @[@"热点话题", @"浏览全站", @"浏览指定版面"];
    CGRect frame = CGRectMake(0.0, 0.0, 200.0, 44);
    menu = [[SINavigationMenuView alloc] initWithFrame:frame title:[appSetting getLoginInfoUsr] :nil];
    [menu displayMenuInView:self.view];
    menu.items = menu_items;
    menu.delegate = self;
    navi.titleView = menu;

    topid = 0;
    bottomid = 0;

    if(USE_MEMBER) {
        [self initContent];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if(waiting_for_mbselect){
        NSString * new_boardid = apiGetMBSelect();
        
        if(new_boardid != nil){
            ArticleListViewController *artlistViewController = [UIViewController appGetView:@"ArtListViewController"];
            
            [artlistViewController setBoardArticleMode:new_boardid :apiGetMBSelectName()];

            [self presentViewController:artlistViewController animated:NO completion:nil];
        }
        waiting_for_mbselect = false;
    }
    
    timeline_view_controller = self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    timeline_view_controller = nil;
    
    [super viewDidDisappear:animated];
}

-(bool)scroll_enabled
{
    if(USE_MEMBER) {
        return true;
    }else{
        return false;
    }
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    if(index == 0){
        ArticleListViewController *artlistViewController = [UIViewController appGetView:@"ArtListViewController"];
        
        [artlistViewController setHotmode:0];
        [self presentViewController:artlistViewController animated:YES completion:nil];
    }else if(index == 1){
        BoardListViewController *brdlistViewController = [UIViewController appGetView:@"BoardListViewController"];
        
        [brdlistViewController setContentInfo:1 :nil];
        
        [self presentViewController:brdlistViewController animated:YES completion:nil];
    }else if (index == 2){
        waiting_for_mbselect = true;
        apiSetMBSelect(nil, nil);
        MBSelectViewController *brdlistViewController = [UIViewController appGetView:@"MBSelectViewController"];
        
        [self presentViewController:brdlistViewController animated:YES completion:nil];
    }
}

- (void)initCurDate
{
    cur_time = [[NSDate date] timeIntervalSince1970];
}

- (IBAction)pressBtnBack:(id)sender {
}

- (void)initContent
{
    loadold = false;

    if(USE_MEMBER) {
        [self loadContent];
    }
}

- (void)moreContent
{
    loadold = true;
    
    if(USE_MEMBER) {
        [self loadContent];
    }
}

-(void)add_content:(NSArray *)array
{
    NSString * order_key;
    if(appSetting->order_threadid){
        order_key = @"gtid";
    }else{
        order_key = @"grid";
    }
    
    if(loadold){
        for(int i=0; i < [array count]; i++) {
            NSDictionary * dict = [array objectAtIndex:i];
            int j;
            for(j=0; j<[m_mtarrayInfo count]; j++) {
                NSDictionary * oldd = [m_mtarrayInfo objectAtIndex:j];
                if(([(NSString *)[dict objectForKey:@"board_id"] caseInsensitiveCompare:[oldd objectForKey:@"board_id"]] == NSOrderedSame) && [[dict objectForKey:@"id"] longLongValue] == [[oldd objectForKey:@"id"] longLongValue]){
                    break;
                }
            }
            if(j >= [m_mtarrayInfo count]){
                [m_mtarrayInfo addObject:dict];
            }
        }
    }else{
        if([array count] >= ARTICLE_PAGE_SIZE) {
            [m_mtarrayInfo removeAllObjects];
            [m_mtarrayInfo addObjectsFromArray:array];
        }else{
            NSMutableArray * newarray = [[NSMutableArray alloc] initWithArray:array];
            for(int i = 0; [newarray count] < ARTICLE_PAGE_SIZE && i < [m_mtarrayInfo count]; i++){
                NSDictionary * dict = [m_mtarrayInfo objectAtIndex:i];
                int j;
                for(j=0; j<[newarray count]; j++){
                    NSDictionary * oldd = [newarray objectAtIndex:j];
                    if(([(NSString *)[dict objectForKey:@"board_id"] caseInsensitiveCompare:[oldd objectForKey:@"board_id"]] == NSOrderedSame) && [[dict objectForKey:@"id"] longLongValue] == [[oldd objectForKey:@"id"] longLongValue]){
                        break;
                    }
                }
                if(j >= [newarray count]){
                    //not found, new article, add
                    [newarray addObject:dict];
                }
            }
            m_mtarrayInfo = [newarray mutableCopy];
        }
    }
    
    if([m_mtarrayInfo count] > 0){
        topid = [(NSString *)[(NSDictionary *)[m_mtarrayInfo objectAtIndex:0] objectForKey:order_key] longLongValue];
        bottomid = [(NSString *)[(NSDictionary *)[m_mtarrayInfo objectAtIndex:([m_mtarrayInfo count]-1)] objectForKey:order_key] longLongValue];
    }

}

-(void)parseContent
{
    if(!USE_MEMBER) {
        return;
    }
    
    NSArray * a = [net_smth net_LoadTimelineList:0 :(loadold?1:0) :(loadold?bottomid:topid) :ARTICLE_PAGE_SIZE :appSetting->order_threadid];
    
    if(net_smth->net_error == 0){
        if(! loadold){
            last_read_time = apiGetUserData_BRC(@"___");
            
            [self initCurDate];
            apiSetUserData_BRC(@"___", (long long int)cur_time);
        }
        
        if([a count] > 0){
            [self add_content:a];
        }
        
        m_bLoadRes = 1;
    }else{
        if(net_smth->net_error == 10401){
            m_bLoadRes = 1;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(USE_MEMBER){
        return [m_mtarrayInfo count];
    }else{
        return 3;
    }
}

- (TimelineListCell *)get_height_cell:(NSIndexPath *)indexPath
{
    static NSString *cellId;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        cellId = @"TimelineListCell_iPad";
    else
        cellId = @"TimelineListCell_iPhone";
    TimelineListCell *cell = (TimelineListCell*)[self.m_tableView dequeueReusableCellWithIdentifier:@"TimelineListCell_Height_buffer"];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell = (TimelineListCell*)[nibArray objectAtIndex:0];
    }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!USE_MEMBER) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            return 64.0f;
        else{
            return 54.0f;
        }
    }
    
    TimelineListCell *cell = (TimelineListCell*)[self get_height_cell:indexPath];
    
    NSDictionary *dict = nil;
    if(indexPath.row < [m_mtarrayInfo count]){
        dict = [m_mtarrayInfo objectAtIndex:(indexPath.row)];
    }
    if(dict == nil){
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            return 85.0f;
        else
            return 95.0f;
    }
    
    CGFloat cell_height = [cell get_height:dict];
    
    return cell_height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!USE_MEMBER) {
        NSString * strName;
        NSString * icon = nil;
        
        switch (indexPath.row) {
            case 0:
                strName = @"浏览版面";
                break;
            case 1:
                strName = @"版面收藏";
                icon = @"icon_fav.png";
                break;
            case 2:
            default:
                strName = @"热门话题";
                icon = @"icon_hot.png";
                break;
        }
        
        static NSString *root_cellId;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            root_cellId = @"SectionListCell_iPad";
        else
            root_cellId = @"SectionListCell_iPhone";
        SectionListCell *cell = (SectionListCell*)[self.m_tableView dequeueReusableCellWithIdentifier:root_cellId];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:root_cellId owner:self options:nil];
            cell = (SectionListCell*)[nibArray objectAtIndex:0];
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        [cell setContentInfo:strName :icon];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
    static NSString *root_cellId;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        root_cellId = @"TimelineListCell_iPad";
    else
        root_cellId = @"TimelineListCell_iPhone";
    TimelineListCell *cell = (TimelineListCell*)[self.m_tableView dequeueReusableCellWithIdentifier:root_cellId];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:root_cellId owner:self options:nil];
        cell = (TimelineListCell*)[nibArray objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary * dict = nil;
    if(indexPath.row < [m_mtarrayInfo count]){
        dict = [m_mtarrayInfo objectAtIndex:indexPath.row];
    }
    if(dict) {
        [cell setContentInfo:dict :cur_time :last_read_time :self];
    }else{
        [cell setContentInfo:nil :0 :0 :self];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!USE_MEMBER) {
        if(indexPath.row == 0){
            [self didSelectItemAtIndex:2];
        }else if(indexPath.row == 1){
            [self didSelectItemAtIndex:1];
        }else{
            [self didSelectItemAtIndex:0];
        }
        [m_tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }

    NSDictionary * dict = [m_mtarrayInfo objectAtIndex:indexPath.row];
    
    [self showArticleContent:[dict objectForKey:@"board_id"] :[dict objectForKey:@"board_name"] :[[dict objectForKey:@"id"] intValue] :[(NSString *)[dict objectForKey:@"count"] intValue]];
    
    [m_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//position: normalmode: article_cnt; refermode:position; mailmode:position
-(void)showArticleContent:(NSString *)boardid :(NSString *)boardname :(long)art_id :(int)position
{
    ArticleContentViewController *artcontViewController = [UIViewController appGetView:@"ArtContViewController"];

    [artcontViewController setContentInfo:0 :0 :boardid :boardname :art_id :position];
    
    [self presentViewController:artcontViewController animated:YES completion:nil];
}

-(void)updateContent
{
    [m_tableView reloadData];
}

- (IBAction)pressBtnNew:(id)sender {
    ArticleContentEditController *artcontEditController = [UIViewController appGetView:@"ArtContEditController"];
    
    [artcontEditController setContentInfo:false :nil :nil :nil :false];

    [self presentViewController:artcontEditController animated:YES completion:nil];
}

@end
