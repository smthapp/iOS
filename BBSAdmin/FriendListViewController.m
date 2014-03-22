//
//  FriendListViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/28/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "FriendListViewController.h"
#import "UserData.h"
#import "UserinfoViewController.h"
#import "UIViewController+AppGet.h"
#import "FriendListCell.h"

@interface FriendListViewController ()

@end

@implementation FriendListViewController
@synthesize m_tableView;
@synthesize m_mtarrayInfo;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    m_mtarrayInfo = [[NSMutableArray alloc] initWithCapacity:10];
    force_update = NO;
    [self loadContent];
}

- (void)parseContent
{
    NSDictionary * list = apiGetUserData_friends();
    
    [m_mtarrayInfo removeAllObjects];
    for(NSString * key in list){
        [m_mtarrayInfo addObject:key];
    }

    //sort m_mtarrayInfo
    [m_mtarrayInfo sortUsingComparator:^(id first, id second){
        NSString * p1 = (NSString *)first;
        NSString * p2 = (NSString *)second;
        
        return [p1 caseInsensitiveCompare:p2];
    }];

    m_bLoadRes = 1;
}

#pragma mark - UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_mtarrayInfo count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        return 54.0f;
    }else{
        return 40.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(1){
        static NSString *cellId;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            cellId = @"FriendListCell_iPad";
        else
            cellId = @"FriendListCell_iPhone";
        FriendListCell *cell = (FriendListCell*)[self.m_tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
            cell = (FriendListCell*)[nibArray objectAtIndex:0];
        }
        
        //set cell
        [cell setBackgroundColor:[UIColor clearColor]];
        
        NSString * userid = [m_mtarrayInfo objectAtIndex:indexPath.row];

        [cell setContentInfo:userid];
        
        return cell;
    }
}

- (void)moreContent
{
    //disable more option
}

- (bool)scroll_enabled
{
    return false;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * userid = [m_mtarrayInfo objectAtIndex:indexPath.row];
    
    UserinfoViewController *UserinfoViewController = [UIViewController appGetView:@"UserinfoViewController"];
    
    [UserinfoViewController setContentInfo:userid];
    [self presentViewController:UserinfoViewController animated:YES completion:nil];
}

- (void)updateContent
{
    [m_tableView reloadData];
}
@end
