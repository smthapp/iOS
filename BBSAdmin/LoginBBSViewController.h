//
//  LoginBBSViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 14-1-3.
//  Copyright (c) 2014年 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "InfoCenter.h"
#import "AppViewController.h"

@interface LoginBBSViewController : AppViewController<UIAlertViewDelegate>
{
    int m_nNetStatus;
    NSString * last_changelog;
    
    int notify_number;
    NSString * notify_msg;
    
    NSString * newversion;
    
    int ret_newversion;
    int ret_pwd;
    
    int alert_delegate_mode;
}

@property (strong, nonatomic) IBOutlet UITextField *m_txtFldUser;
@property (strong, nonatomic) IBOutlet UITextField *m_txtFldPwd;
@property (strong, nonatomic) IBOutlet UILabel *m_labelNetStatus;

@property (strong, nonatomic) IBOutlet UIImageView *img_bg;
@property (strong, nonatomic) NSString *m_strUser;
@property (strong, nonatomic) NSString *m_strPwd;
@property (strong, nonatomic) IBOutlet UITextView *textview_eula;
@property (strong, nonatomic) IBOutlet UIButton *button_eula_disagree;
@property (strong, nonatomic) IBOutlet UIButton *button_eula_agree;
- (IBAction)pressBtnEULAdisagree:(id)sender;
- (IBAction)pressBtnEULAagree:(id)sender;

- (IBAction)retrunEditTextField:(id)sender;
- (IBAction)pressBtnClear:(id)sender;
- (IBAction)pressBtnLogin:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;

- (void)updateNetStatus;

- (BOOL)checkInputText;
- (void)goContentView;

@end

