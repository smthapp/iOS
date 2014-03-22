//
//  AppSettingViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 14-1-3.
//  Copyright (c) 2014年 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoCenter.h"
#import "AppViewController.h"

@interface AppSettingViewController : AppViewController<UITableViewDataSource, UITableViewDelegate>
{
    int m_nCellWidth;
    int m_nCellHeightCenter;
    
    int action;
}

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) NSString *m_strAppVer;

-(void)switchSettingAction:(UISwitch *)sender;

-(void)showUserInfo;
-(void)logoutAccount;

-(void)showAbout;

@end
