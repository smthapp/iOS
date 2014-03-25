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

@interface MBSelectViewController : AppViewController<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableArray * mblist;
    
    bool in_search;
    UITapGestureRecognizer * tap;
    
    bool waiting_for_mbselect;
    
    NSMutableArray * bhis;
}

- (IBAction)pressBtnBack:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
- (IBAction)pressBtnSearch:(id)sender;
@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;

@end
