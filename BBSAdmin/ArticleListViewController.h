//
//  ArticleListViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/16/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "InfoCenter.h"
#import "ArticleInfoCell.h"
#import "ArticleSearchCell.h"
#import "AppViewController.h"

enum ArticleListMode {
    ArticleListModeNormal = 0,
    ArticleListModeHot = 1,
    ArticleListModeRefer = 2,
    ArticleListModeMail = 3,
    ArticleListModeMailSent = 4,
    };

@interface ArticleListViewController : AppViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSString * m_lBoardId;
    NSString * m_lBoardName;
    long articles_cnt;
    long from;
    long size;
    long load_size;
    int load_init_mode;
    
    enum ArticleListMode mode;
    
    //search submode
    bool submode_search;
    NSString * query_title;
    NSString * query_user;
    
    //hotmode
    int hotmode_section;
    
    //refermode
    int refermode;
    
    //current date
    NSTimeInterval cur_time;
    long long int last_read_artid;
}

@property (strong, nonatomic) IBOutlet UINavigationItem *navi;
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) NSMutableArray *m_mtarrayInfo;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonNewArt;

- (IBAction)pressBtnBack:(id)sender;
- (IBAction)pressBtNewArt:(id)sender;

-(void)setHotmode:(int)section;
-(void)setBoardArticleMode:(NSString *)boardid :(NSString *)boardname;
-(void)setRefermode:(int)refer_submode;
-(void)setMailmode:(int)sent;

- (void)search_title:(NSString *)_query;
- (void)search_user:(NSString *)_query;

@end
