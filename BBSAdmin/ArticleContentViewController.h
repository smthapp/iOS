//
//  ArticleContentViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/20/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "InfoCenter.h"
#import <QuartzCore/QuartzCore.h>
#import "UIAttImageView.h"
#import "AppViewController.h"

enum ArticleContentViewMode {
    ArticleContentViewModeNormal = 0,
    ArticleContentViewModeRefer = 1,
    ArticleContentViewModeMail = 2,
    ArticleContentViewModeMailSent = 3,
    };

@interface ArticleContentViewController : AppViewController<UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate>
{
    NSString * m_lBoardId;
    NSString * m_lBoardName;
    long article_id; //actually it's thread_id

    long size;
    long article_cnt; //article count in normal mode
    
    enum ArticleContentViewMode mode;
    
    //refermode
    int refermode;
    int referposition;
    
    //mail
    int mailposition;
    
    //ActionSheet
    NSDictionary * reply_dict;
    int as_action[4];
    NSIndexPath * as_indexpath;
    bool waiting_for_cross;
    NSString * cross_target;
}

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) NSMutableArray *m_mtarrayInfo;
@property (strong, nonatomic) IBOutlet UINavigationItem *navi;

- (IBAction)pressBtnGoboard:(id)sender;

//public API
/**
 *@ param art_mode 0:ArticleContentViewModeNormal 10:ArticleContentViewModeMail 11:ArticleContentViewModeMailSent 1,2: ArticleContentViewModeRefer
 */
-(void)setContentInfo:(int)art_mode :(int)art_position :(NSString *)boardid :(NSString *)boardname :(long)art_id :(long)cnt;


@end
