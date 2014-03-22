//
//  SeriePlatesViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 14-1-3.
//  Copyright (c) 2014年 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoCenter.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "SectionListCell.h"
#import "BoardSearchCell.h"
#import "AppViewController.h"


@interface SeriePlatesViewController : AppViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSString * query;
}

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

- (void)do_search:(NSString *)_query;
@end
