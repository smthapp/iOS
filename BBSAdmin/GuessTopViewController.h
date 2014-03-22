//
//  GuessTopViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/9/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "InfoCenter.h"
#import "GuessTopCell.h"
#import "AppViewController.h"

@interface GuessTopViewController : AppViewController<UITableViewDataSource, UITableViewDelegate>
{
    int guessid;
}

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

@property (strong, nonatomic) NSMutableArray *m_mtarrayInfo;


- (void)setContentInfo:(int)_guessid;

@end
