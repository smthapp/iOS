//
//  ParentTabBarViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 14-1-7.
//  Copyright (c) 2014年 newsmth. All rights reserved.
//

#import "ParentTabBarViewController.h"

ParentTabBarViewController * g_tabbar = nil;

static int tabbar_message_count = 0;
static int tabbar_message_newcount = 0;
void tabbar_message_set_notify(int count)
{
#ifdef DEBUG
    NSLog(@"set message notify:%d -> %d", tabbar_message_count, count);
#endif
    tabbar_message_newcount = count;
}

void tabbar_message_check_notify()
{
    if(g_tabbar == nil || tabbar_message_newcount == tabbar_message_count){
        return;
    }
    
#ifdef DEBUG
    NSLog(@"message:%d -> %d", tabbar_message_count, tabbar_message_newcount);
#endif

    UITabBarItem * t = [g_tabbar.tabBar.items objectAtIndex:1];
    if(t == nil){
        return;
    }
    
    if(tabbar_message_newcount){
        [t setBadgeValue:[NSString stringWithFormat:@"%d", tabbar_message_newcount]];
    }else{
        [t setBadgeValue:nil];
    }
    
    tabbar_message_count = tabbar_message_newcount;
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
    
    tabbar_message_check_notify();
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

@end
