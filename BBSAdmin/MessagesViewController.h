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
    //reply
    int reply_count;
    int reply_unread;
    
    //@
    int at_count;
    int at_unread;
    
    //mail
    int mail_count;
    int mail_unread;
    int mail_isfull;
    
    //mailsend
    int mail_count_send;
}

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

@end
