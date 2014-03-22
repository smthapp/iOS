//
//  GuessListViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/30/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "InfoCenter.h"
#import "GuessInfoCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AppViewController.h"

@interface GuessListViewController : AppViewController<UITableViewDataSource, UITableViewDelegate>
{
}

@property (strong, nonatomic) NSMutableArray *m_mtarrayInfo;

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

@end
