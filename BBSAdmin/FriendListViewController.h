//
//  FriendListViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/28/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "AppViewController.h"

@interface FriendListViewController : AppViewController<UITableViewDataSource, UITableViewDelegate>
{
    bool force_update;
}
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) NSMutableArray *m_mtarrayInfo;


@end
