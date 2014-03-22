//
//  MatchContentViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/3/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "InfoCenter.h"
#import <QuartzCore/QuartzCore.h>
#import "MatchOptionCell.h"
#import "MatchHeadCell.h"
#import "AppViewController.h"

#define MAX_OPTIONS_PER_MATCH 4

@interface MatchContentViewController : AppViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    int guessid;
    int matchid;
    int status; //0:not start 1:available 2:end 3:result done
    int selnum;
    
    NSDictionary * match;
    NSArray * options;
    NSDictionary * mymoney;
    NSArray * myvotes;
    int matchmode;
    int my_voted_money[MAX_OPTIONS_PER_MATCH];
    int canvote;
    
    int addvotemode;
    int vote_sel;
    int vote_addmoney;
}

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

//public API
-(void)setContentInfo:(int)guess_id :(int)match_id;
-(void)VoteMatch:(int)sel :(int)addmoney;

@end
