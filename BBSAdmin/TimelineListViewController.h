//
//  TimelineListViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/10/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "InfoCenter.h"
#import <QuartzCore/QuartzCore.h>
#import "TimelineListCell.h"
#import "AppViewController.h"


@interface TimelineListViewController : AppViewController<UITableViewDataSource, UITableViewDelegate>
{
    long from;
    long size;
    long load_size;
    
    NSTimeInterval cur_time;
    long long int last_read_time;
}

@property (strong, nonatomic) NSMutableArray *m_mtarrayInfo;


@property (strong, nonatomic) IBOutlet UINavigationBar *navi;
- (IBAction)pressBtnNew:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

@end
