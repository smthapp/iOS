//
//  BoardListViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 14-1-3.
//  Copyright (c) 2014年 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoCenter.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "BoardInfoCell.h"
#import "BoardDirCell.h"
#import "AppViewController.h"


@interface BoardListViewController : AppViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    int m_mode; //1:新分类讨论区, 2:个人收藏夹，3:分区十大, 4:搜索版面, 5:驻版列表
    NSMutableArray * m_mtarraySectionId;
    NSMutableArray * m_mtarrayGroupId;

    NSString * query;
    
    //as_param
    NSString * as_bname;
    int as_mode;
    NSIndexPath * as_indexpath;
    
    bool mode_subdir;
}

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) NSMutableArray *m_mtarrayInfo;
- (IBAction)pressBtnBack:(id)sender;


//public API
/**
 *@ param _mmode 1:新分类讨论区, 2:个人收藏夹，3:分区十大, 4:搜索版面, 5:驻版列表
 *@ param _query only used if '_mmode'==4
 *@
 */
- (void)setContentInfo:(int)_mmode :(NSString *)_query;

@end
