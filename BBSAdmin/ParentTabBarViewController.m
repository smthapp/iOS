//
//  ParentTabBarViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 14-1-7.
//  Copyright (c) 2014年 newsmth. All rights reserved.
//

#import "ParentTabBarViewController.h"
#import "InfoCenter.h"
#import "TimelineListViewController.h"

ParentTabBarViewController * g_tabbar = nil;

void message_tabbar_update()
{
    if(g_tabbar == nil){
        return;
    }
    
    [g_tabbar refresh];
}

@interface ParentTabBarViewController ()

@end

@implementation ParentTabBarViewController
@synthesize m_progressBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self showWelcomeTip];
    
    message_tabbar_update();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)//iphone or ipod
    {
        return ((toInterfaceOrientation == UIDeviceOrientationPortrait)||(toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown));
    }
    else//ipad
    {
        return ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight));
    }
}

- (void)showWelcomeTip
{
    
}

#pragma mark MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (m_progressBar)
    {
        [m_progressBar removeFromSuperview];
        m_progressBar = nil;
    }
}

- (void)refresh
{
    [self performSelectorOnMainThread:@selector(updateContent) withObject:nil waitUntilDone:NO];
}

-(void)updateContent
{
    int count = appSetting->unread_apns_cnt + appSetting->at_unread + appSetting->mail_unread + appSetting->reply_unread;
    
#ifdef DEBUG
    NSLog(@"message:%d", count);
#endif
    
    UITabBarItem * t = [self.tabBar.items objectAtIndex:1];
    if(t == nil){
        return;
    }
    
    if(count){
        [t setBadgeValue:[NSString stringWithFormat:@"%d", count]];
    }else{
        [t setBadgeValue:nil];
    }
}

extern TimelineListViewController * timeline_view_controller;
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 1){
        if(timeline_view_controller != nil){
            if([timeline_view_controller.m_mtarrayInfo count] > 0){
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [timeline_view_controller.m_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            [timeline_view_controller initContent];
        }
    }
}

@end
