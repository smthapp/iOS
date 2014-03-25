//
//  MessagesViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/24/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MessageInfoCell.h"
#import "InfoCenter.h"
#import "ArticleListViewController.h"
#import "AppViewController.h"

@interface MessagesViewController : AppViewController<UITableViewDataSource, UITableViewDelegate>
{
}

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navi;

-(void)refresh;

@end

