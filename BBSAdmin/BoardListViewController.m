//
//  BoardListViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 14-1-3.
//  Copyright (c) 2014年 newsmth. All rights reserved.
//

#import "BoardListViewController.h"
#import "ArticleListViewController.h"
#import "TimelineListViewController.h"
#import "UserData.h"
#import "UIViewController+AppGet.h"


@interface BoardListViewController ()

@end

@implementation BoardListViewController
@synthesize m_tableView;
@synthesize m_mtarrayInfo;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    m_mtarrayInfo = [NSMutableArray arrayWithCapacity:10];
    m_mtarrayGroupId = [NSMutableArray arrayWithCapacity:10];
    m_mtarraySectionId = [NSMutableArray arrayWithCapacity:10];

    as_mode = 0;
    mode_subdir = true;
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPressGr.minimumPressDuration = 1.0;
    [m_tableView addGestureRecognizer:longPressGr];

    [self loadContent];

}

-(void)longPressAction:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:m_tableView];
        NSIndexPath * indexPath = [m_tableView indexPathForRowAtPoint:point];

        if(indexPath == nil) return ;

#ifdef DEBUG
        NSLog(@"long press:%ld", (long)indexPath.row);
#endif
        
        NSDictionary *dict = [m_mtarrayInfo objectAtIndex:(indexPath.row)];
        if (dict == nil){
            return;
        }
        
        as_bname = (NSString*)[dict objectForKey:@"id"];

        if(m_mode == 1 || m_mode == 2 || m_mode == 4 || m_mode == 5){
            //新分类讨论区，收藏夹，搜索版面 允许长按
            unsigned int bid = [(NSString*)[dict objectForKey:@"bid"] intValue];
            if(bid > 0){
                //it's board struct
                unsigned int board_flag = [(NSString*)[dict objectForKey:@"flag"] intValue];
                if(board_flag & 0x400){
                    //dir board
                    return;
                }else{
                    //real board
                }
            }else{
                return;
            }
        }else{
            return;
        }
        
        UIActionSheet * as;
        
        if(m_mode == 2){
            //收藏夹
            if(USE_MEMBER) {
                as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"取消收藏", @"驻版", nil];
            }else{
                as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"取消收藏", nil];
            }
        }else if(m_mode == 5){
            //驻版
            as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", @"取消驻版", nil];
        }else{
            //分类讨论区
            if(USE_MEMBER) {
                as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", @"驻版", nil];
            }else{
                as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", nil];
            }
        }
        
        as_indexpath = indexPath;
        [as setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [as showInView:self.view];
        
        return;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
#ifdef DEBUG
    NSLog(@"press:%ld", (long)buttonIndex);
#endif
    
    if(as_indexpath) {
        [m_tableView deselectRowAtIndexPath:as_indexpath animated:NO];
        as_indexpath = nil;
    }

    if(buttonIndex == 0){
        as_mode = 1;
    }else if(buttonIndex == 1 && USE_MEMBER){
        as_mode = 2;
    }else{
        return;
    }
    
    [self loadContent];
}

- (void)as_setfav
{
    NSString * strAct;
    if(m_mode == 2){
        strAct = @"取消收藏";
        [net_smth net_DelFav:as_bname];
    }else{
        strAct = @"收藏";
        [net_smth net_AddFav:as_bname];
    }
    
    if(net_smth->net_error == 0){
        UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@成功",strAct] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [altview show];
    }
}

- (void)as_setmember
{
    int join_result;
    
    NSString * strAct;
    if(m_mode == 5){
        strAct = @"取消驻版";
        [net_smth net_QuitMember:as_bname];
    }else{
        strAct = @"驻版";
        join_result = [net_smth net_JoinMember:as_bname];
    }
    
    if(net_smth->net_error == 0){
        NSString * msg;
        if(m_mode == 5){
            msg = strAct;
        }else{
            if(join_result == 0){
                msg = @"驻版成功，您已是正是驻版用户";
            }else{
                msg = @"驻版成功，尚需管理员审核成为正是驻版用户";
            }
        }
        UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [altview show];
    }
}

- (void)back_noreload
{
    if([m_mtarrayGroupId count] > 0){
        [m_mtarrayGroupId removeLastObject];
        [m_mtarraySectionId removeLastObject];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)pressBtnBack:(id)sender {
    if([m_mtarrayGroupId count] > 0){
        [m_mtarrayGroupId removeLastObject];
        [m_mtarraySectionId removeLastObject];
        
        [self loadContent];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)sortArray:(NSArray *)array
{
    [m_mtarrayInfo removeAllObjects];
    
    if(array == nil || [array count] <= 0){
        return;
    }
    
    if(m_mode == 2){
        //收藏夹，不排序
        [m_mtarrayInfo addObjectsFromArray:array];
        return;
    }
    
    if(m_mode == 5){
        //驻版，不排序，处理[board]
        NSEnumerator * e = [array objectEnumerator];
        for(NSDictionary * ele in e){
            NSDictionary * dict_board = [ele objectForKey:@"board"];
            if(dict_board){
                [m_mtarrayInfo addObject:dict_board];
            }
        }
        apiSetUserData_MBList(m_mtarrayInfo);
        return;
    }
    
    [m_mtarrayInfo addObjectsFromArray:[array sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
        {
            NSDictionary * dict_a = (NSDictionary *)a;
            NSDictionary * dict_b = (NSDictionary *)b;
            int online_a = [(NSString *)[dict_a objectForKey:@"current_users"] intValue];
            int online_b = [(NSString *)[dict_b objectForKey:@"current_users"] intValue];
            
            int board_flag_a = [(NSString*)[dict_a objectForKey:@"flag"] intValue];
            int board_flag_b = [(NSString*)[dict_b objectForKey:@"flag"] intValue];
            if(board_flag_a == -1 || (board_flag_a & 0x400)){
                //it's dir or dir_board
                board_flag_a = 1;
            }else{
                board_flag_a = 0;
            }
            if(board_flag_b == -1 || (board_flag_b & 0x400)){
                //it's dir or dir_board
                board_flag_b = 1;
            }else{
                board_flag_b = 0;
            }
            
            if(board_flag_a && board_flag_b){
                //both are dir, donothing
                return NSOrderedSame;
            }
            if(board_flag_a && !board_flag_b) {
                return NSOrderedAscending;
            }
            if(board_flag_b && !board_flag_a){
                return NSOrderedDescending;
            }
            
            if(online_a == online_b){
                return NSOrderedSame;
            }else if(online_a > online_b){
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
    } ] ];
    //[m_mtarrayInfo addObjectsFromArray:array];
}

-(void)parseContent
{
    NSArray *arrayInfo;
    
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

    if(m_mode == 1 || m_mode == 2 || m_mode == 4 || m_mode == 5){
        //新分类讨论区 || 收藏夹 || 搜索 || 驻版
        long groupId;
        long sectionId;
        if([m_mtarrayGroupId count] > 0){
            sectionId = [(NSString *)[m_mtarraySectionId lastObject] intValue];
            groupId = [(NSString *)[m_mtarrayGroupId lastObject] intValue];
        }else{
            sectionId = -1;
            groupId = 0;
        }
        
        if(sectionId >= 0){
            //it's dir board
            arrayInfo = [net_smth net_ReadSection:sectionId :groupId];
            
        }else{
            //it's fav dir
            if(m_mode == 1){
                arrayInfo = [net_smth net_LoadBoards:groupId];
            }else if(m_mode == 4){
                //搜索版面结果
                arrayInfo = [net_smth net_QueryBoard:query];
            }else if(m_mode == 5){
                //驻版
                arrayInfo = [net_smth net_LoadMember:[appSetting getLoginInfoUsr] :0 :100];
            }else{
                arrayInfo = [net_smth net_LoadFavorites:groupId];
            }
        }
        if (net_smth->net_error == 0)//get success
        {
            [self sortArray:arrayInfo];
        }else if(!net_usercancel){
            //失败的话，显示空界面
            [self sortArray:nil];
        }
    }else if(m_mode == 3){
        //分区十大，显示分区
        arrayInfo = [net_smth net_LoadSection];
        
        if (net_smth->net_error == 0)//get success
        {
            [m_mtarrayInfo removeAllObjects];
            [m_mtarrayInfo addObjectsFromArray:arrayInfo];
        }else if(!net_usercancel){
            [m_mtarrayInfo removeAllObjects];
        }
    }
    
    if(net_usercancel) {
        //用户取消，返回上一页
        if(mode_subdir){
            [self back_noreload];
        }
    }
    mode_subdir = false;

    //不管是否成功，都要刷新界面。
    m_bLoadRes = 1;
    return;
}

#pragma mark - UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_mtarrayInfo count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return 64.0f;
    else{
        return 54.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL use_boardinfocell = false;

    NSString *strName = @"";
    
    NSDictionary *dict = nil;
    
    if(m_mode == 1 || m_mode == 2 || m_mode == 4 || m_mode == 5){
        //新分类讨论区 || 收藏夹 || 搜索结果
        if(indexPath.row < [m_mtarrayInfo count]){
            dict = [m_mtarrayInfo objectAtIndex:(indexPath.row)];
            if (dict)
            {
                int board_flag = [(NSString*)[dict objectForKey:@"flag"] intValue];
                if(board_flag != -1){
                    //it's board struct
                    if(board_flag & 0x400){
                        //group
                    }else{
                        use_boardinfocell = true;
                    }
                    strName = [dict objectForKey:@"name"];
                }else{
                    //it's group struct
                    strName = [dict objectForKey:@"name"];
                }
            }
        }
    }else if(m_mode == 3){
        if(indexPath.row < [m_mtarrayInfo count]){
            dict = [m_mtarrayInfo objectAtIndex:(indexPath.row)];
            if (dict)
            {
                strName = [dict objectForKey:@"name"];
            }
        }
    }
    
    if(use_boardinfocell){
        static NSString *cellId;

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            cellId = @"BoardInfoCell_iPad";
        else
            cellId = @"BoardInfoCell_iPhone";
        BoardInfoCell *cell = (BoardInfoCell*)[self.m_tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
            cell = (BoardInfoCell*)[nibArray objectAtIndex:0];
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        if(m_mode == 5){
            //TODO: 驻版模式，没有未读标记。通过userdata_BRC来判断。
        }
        if(dict){
            [cell setContentInfo:[dict objectForKey:@"id"] :strName :[(NSString*)[dict objectForKey:@"total"] intValue] :[(NSString*)[dict objectForKey:@"current_users"] intValue] :[(NSString*)[dict objectForKey:@"unread"]intValue] :[(NSString *)[dict objectForKey:@"flag"] intValue]];
        }
        
        return cell;
        
    }else{
        
        static NSString *root_cellId;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            root_cellId = @"BoardDirCell_iPad";
        else
            root_cellId = @"BoardDirCell_iPhone";
        BoardDirCell *cell = (BoardDirCell*)[self.m_tableView dequeueReusableCellWithIdentifier:root_cellId];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:root_cellId owner:self options:nil];
            cell = (BoardDirCell*)[nibArray objectAtIndex:0];
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];

        [cell setContentInfo:strName];
        
        return cell;
    }
}

- (void)moreContent
{
    //disable more option
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(m_mode == 1 || m_mode == 2 || m_mode == 4 || m_mode == 5){
        //新分类讨论区 || 收藏夹 || 搜索
        NSDictionary *dict = [m_mtarrayInfo objectAtIndex:(indexPath.row)];
        if (dict)
        {
            int board_flag = [(NSString*)[dict objectForKey:@"flag"] intValue];
            if(board_flag == -1){
                //it's dir
                [m_mtarraySectionId addObject:@"-1"];
                [m_mtarrayGroupId addObject:[dict objectForKey:@"bid"]];
                mode_subdir = true;
                [self loadContent];
            }else if(board_flag & 0x400){
                //dir board
                [m_mtarraySectionId addObject:[dict objectForKey:@"section"]];
                [m_mtarrayGroupId addObject:[dict objectForKey:@"bid"]];
                mode_subdir = true;
                [self loadContent];
            }else{
                //real board
                [self showArticleList:0 :0 :[dict objectForKey:@"id"] :[dict objectForKey:@"name"]];
            }
        }
    }else if(m_mode == 3){
        NSDictionary *dict = [m_mtarrayInfo objectAtIndex:(indexPath.row)];
        if (dict)
        {
            [self showArticleList:1 :[(NSString *)[dict objectForKey:@"id"] intValue]+1 :nil :nil];
        }
    }
    
    [m_tableView deselectRowAtIndexPath:indexPath animated:NO];
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

- (void)updateContent
{
    [m_tableView reloadData];
    
    if([m_mtarrayInfo count] > 0){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [m_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)setContentInfo:(int)_mmode :(NSString *)_query
{
    m_mode = _mmode;
    if(_query){
        query = [_query copy];
    }
}


@end
