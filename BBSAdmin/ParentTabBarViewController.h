//
//  ParentTabBarViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 14-1-7.
//  Copyright (c) 2014年 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ParentTabBarViewController : UITabBarController<MBProgressHUDDelegate>
{
    
}

@property(strong, nonatomic) MBProgressHUD *m_progressBar;

- (void)showWelcomeTip;

@end

extern ParentTabBarViewController * g_tabbar;


void tabbar_message_set_notify(int count);
void tabbar_message_check_notify();