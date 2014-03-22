//
//  SeriePlatesViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 14-1-3.
//  Copyright (c) 2014年 newsmth. All rights reserved.
//

#import "SeriePlatesViewController.h"
#import "ArticleListViewController.h"
#import "TimelineListViewController.h"
#import "UserData.h"
#import "UIViewController+AppGet.h"
#import "BoardListViewController.h"
#import "FriendListViewController.h"


@interface SeriePlatesViewController ()

@end

@implementation SeriePlatesViewController
@synthesize m_tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (IBAction)pressBtnBack:(id)sender {
}

-(bool)scroll_enabled
{
    return false;
}

#pragma mark - UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        if(USE_MEMBER){
            return 8;
        }else{
            return 6;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return 64.0f;
    else{
        if(indexPath.row == 0){
            return 30.0f;
        }else{
            return 54.0f;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strName;
    
    switch (indexPath.row) {
        case 0:
        {
            static NSString *search_cellId;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
                search_cellId = @"BoardSearchCell_iPad";
            else
                search_cellId = @"BoardSearchCell_iPhone";
            BoardSearchCell *cell = (BoardSearchCell*)[self.m_tableView dequeueReusableCellWithIdentifier:search_cellId];
            if (cell == nil) {
                NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:search_cellId owner:self options:nil];
                cell = (BoardSearchCell*)[nibArray objectAtIndex:0];
            }
            
            [cell setBackgroundColor:[UIColor clearColor]];
            
            [cell setContentInfo:self];
            
            return cell;
        }
        case 1:
            strName = @"浏览版面";
            break;
        case 2:
            strName = @"版面收藏";
            break;
        case 4:
            strName = @"分区十大";
            break;
        case 5:
            strName = @"我的好友";
            break;
        case 6:
            strName = @"时间线浏览";
            break;
        case 7:
            strName = @"驻版列表";
            break;
        case 3:
        default:
            strName = @"热门话题";
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
    
    [cell setContentInfo:strName];
    
    return cell;
}

- (void)moreContent
{
    //disable more option
}

- (void)do_search:(NSString *)_query
{
    query = [_query copy];
    [self showBoardList:4];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){
        //搜索, do in cell
    }else if(indexPath.row < 3){
        [self showBoardList:(int)(indexPath.row)];
    }else if(indexPath.row == 3){
        //十大
        [self showArticleList:1 :0 :nil :nil];
    }else if(indexPath.row == 4){
        [self showBoardList:3];
    }else if(indexPath.row == 5){
        [self showFriendList];
    }else if(indexPath.row == 7){
        [self showBoardList:5];
    }else{
        //时间线模式
        [self showTimelineList];
    }
    
    [m_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)showBoardList:(int)m_mode
{
    BoardListViewController *brdlistViewController = [UIViewController appGetView:@"BoardListViewController"];
    
    
    [brdlistViewController setContentInfo:m_mode :((m_mode==4)?query:nil)];
    
    [self presentViewController:brdlistViewController animated:YES completion:nil];
}

-(void)showTimelineList
{
    TimelineListViewController *timelinelistViewController = [UIViewController appGetView:@"TimelineListViewController"];
    
    [self presentViewController:timelinelistViewController animated:YES completion:nil];
}

-(void)showFriendList
{
    FriendListViewController *friendlistViewController = [UIViewController appGetView:@"FriendListViewController"];
    
    [self presentViewController:friendlistViewController animated:YES completion:nil];
}

-(void)showArticleList:(int)hotmode :(int)hotmode_section :(NSString *)boardid :(NSString *)boardname
{
    ArticleListViewController *artlistViewController = [UIViewController appGetView:@"ArtListViewController"];
    
    if(hotmode){
        [artlistViewController setHotmode:hotmode_section];
    }else{
        [artlistViewController setBoardArticleMode:boardid :boardname];
    }
    [self presentViewController:artlistViewController animated:YES completion:nil];
}

@end
