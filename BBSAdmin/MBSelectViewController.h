//
//  MBSelectViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/11/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UserData.h"
#import "InfoCenter.h"
#import "AppViewController.h"

@interface MBSelectViewController : AppViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * mblist;
}

- (IBAction)pressBtnBack:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

@end
