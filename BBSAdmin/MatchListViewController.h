//
//  MatchListViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/30/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "InfoCenter.h"
#import "MatchInfoCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MatchContentViewController.h"
#import "GuessTopViewController.h"
#import "AppViewController.h"

@interface MatchListViewController : AppViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    int guessid;
    int guess_mymoney;
    int guess_mode;
    
    int allmatch_mode;
}

@property (strong, nonatomic) NSMutableArray *m_mtarrayInfo;

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;


-(void)setContentInfo:(int)i_guessid :(int)allmatch;

@end
