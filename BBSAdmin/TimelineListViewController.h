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
#import "NavigationMenuView/SINavigationMenuView.h"

@interface TimelineListViewController : AppViewController<UITableViewDataSource, UITableViewDelegate, SINavigationMenuDelegate>
{
    NSTimeInterval cur_time;
    long long int last_read_time;
    
    SINavigationMenuView * menu;
    NSArray * menu_items;
    
    bool waiting_for_mbselect;

    long topid;
    long bottomid;
    bool loadold;
}

@property (strong, nonatomic) NSMutableArray *m_mtarrayInfo;
@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;

@property (strong, nonatomic) IBOutlet UINavigationItem *navi;

- (IBAction)pressBtnNew:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

@end
