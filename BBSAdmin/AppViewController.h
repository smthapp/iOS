//
//  AppViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/16/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "libSMTH/SMTHURLConnection.h"

@interface AppViewController : UIViewController<MBProgressHUDDelegate, UIGestureRecognizerDelegate, SMTHURLConnectionDelegate>
{
    bool refreshed;
    int m_bLoadRes;
    MBProgressHUD *m_progressBar;
    
    SMTHURLConnection * net_smth;
    int net_ops;
    int net_ops_done;
    int net_ops_percent;

    int net_usercancel;
}

/*
 * flow: This function is called when swipe from left to right
 * default: [self dismissViewControllerAnimated:YES completion:nil];
 * subclass: .
 */
- (IBAction)pressBtnBack:(id)sender;

/*
 * default: return true;;
 * subclass: if want to disable scroll, return false please.
 */
- (bool)scroll_enabled;

/* 
 * flow: This function is called when scroll from top
 * default: [self loadContent];
 * subclass: reset the content, and then call loadContent.
 */
- (void)initContent;
/*
 * flow: This function is called when scroll from bottom
 * default: [self loadContent];
 * subclass: increase the content, and then call loadContent.
 */
- (void)moreContent;
/*
 * default: init m_progressBar;
 * subclass: don't overwrite this in most cases.
 */
-(void)loadContent;
/*
 * flow: This function is called in loadContent()
 * default: do nothing;
 * subclass: do real network operations.
 */
-(void)parseContent;
/*
 * flow: This function is called after parseContent() done.
 * default: do nothing;
 * subclass: [m_tableView reloadData] if use tableView.
 */
- (void)updateContent;


-(void)init_without_UI;


@end
