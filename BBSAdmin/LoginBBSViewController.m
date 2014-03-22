//
//  LoginBBSViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 14-1-3.
//  Copyright (c) 2014年 newsmth. All rights reserved.
//

#import "LoginBBSViewController.h"
#import "ParentTabBarViewController.h"
#import "UIViewController+AppGet.h"
#import "UserData.h"


@interface LoginBBSViewController ()

@end

@implementation LoginBBSViewController
@synthesize m_txtFldUser, m_txtFldPwd;
@synthesize m_strUser, m_strPwd;
@synthesize m_labelNetStatus;
@synthesize textview_eula, button_eula_agree, button_eula_disagree;
@synthesize img_bg;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    apiAppSettingInit();
	// Do any additional setup after loading the view.

    NSString * username = [appSetting getLoginInfoUsr];
    NSString * password = [appSetting getLoginInfoPwd];
    

    if(username && password){
        [m_txtFldUser setText:username];
        [m_txtFldPwd setText:password];
    }
    
#if 0
    NSString * eula_ok = [defaults objectForKey:@"eula_ok"];
    if([eula_ok intValue] != 1)
#else
    if(0)
#endif
    {
        [textview_eula setHidden:NO];
        [img_bg setHidden:YES];
    }else{
        [textview_eula setHidden:YES];
        [button_eula_disagree setHidden:YES];
        [button_eula_agree setHidden:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    g_tabbar = nil;
    
    [self updateNetStatus];
    
}

- (IBAction)pressBtnEULAdisagree:(id)sender
{
    exit(0);
}

- (IBAction)pressBtnEULAagree:(id)sender
{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"eula_ok"];
    [defaults synchronize];

    [img_bg setHidden:NO];
    
    [button_eula_agree setHidden:YES];
    [button_eula_disagree setHidden:YES];
    [textview_eula setHidden:YES];
}

- (IBAction)retrunEditTextField:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)pressBtnClear:(id)sender
{
    [m_txtFldUser setText:@""];
    [m_txtFldPwd setText:@""];
    
    
    NSString * str_prev_user = [appSetting getLoginInfoUsr];

    [appSetting setLoginInfo:@"" :@""];
    
    if(str_prev_user == nil || ![str_prev_user isEqualToString:@""]){
        //clear valid userinfo, then remove the APNS
        apiUpdateAPNS(nil);
    }
}
    
-(bool)scroll_enabled
{
    return false;
}

- (IBAction)pressBtnLogin:(id)sender
{
    [self loadContent];
}



- (void)updateNetStatus
{
    m_nNetStatus = apiCheckNetStatus();
    switch (m_nNetStatus) {
        case -1:
            [m_labelNetStatus setText:@"断开"];
            NSLog(@"net disconnected");
            break;
        case 0:
            [m_labelNetStatus setText:@"已连接(移动网络)"];
            NSLog(@"mobile net");
            break;
        case 1:
            [m_labelNetStatus setText:@"已连接(WIFI)"];
            NSLog(@"wifi net");
            break;
        default:
            break;
    }
}

- (int)checkVersion
{
    NSDictionary* dict = [net_smth net_GetVersion];
    if(net_smth->net_error != 0 || dict==nil){
        return -1;
    }
    
#ifdef DEBUG
    USE_MEMBER = true;
#else
    if([(NSString *)[dict objectForKey:@"use_member"] intValue] > 0){
        USE_MEMBER = true;
    }
#endif
    
    help_board = [dict objectForKey:@"help_board"];
    if(help_board != nil && [help_board isEqualToString:@""]){
        help_board = nil;
    }
#ifdef DEBUG
    if(help_board == nil){
        help_board = @"BBSHelp";
    }
#endif
    
    int latest_major = [(NSString *)[dict objectForKey:@"latest_major"] intValue];
    int latest_minor = [(NSString *)[dict objectForKey:@"latest_minor"] intValue];
    int latest_rc    = [(NSString *)[dict objectForKey:@"latest_rc"] intValue];
    int min_major = [(NSString *)[dict objectForKey:@"min_major"] intValue];
    int min_minor = [(NSString *)[dict objectForKey:@"min_minor"] intValue];
    int min_rc    = [(NSString *)[dict objectForKey:@"min_rc"] intValue];
    last_changelog = [dict objectForKey:@"latest_changelog"];
    
    notify_number = [(NSString *)[dict objectForKey:@"notify_number"] intValue];
    notify_msg = [dict objectForKey:@"notify_msg"];

    NSString *appVer = @"0.0.1";
    
    //app version
    NSDictionary *dict_cur = [[NSBundle mainBundle] infoDictionary];
    appVer = [dict_cur objectForKey:@"CFBundleVersion"];
    int cur_major=0, cur_minor=0, cur_rc =0;
    sscanf([appVer cStringUsingEncoding:NSUTF8StringEncoding], "%d.%d.%d", &cur_major, &cur_minor, &cur_rc);
    NSLog(@"current app version %@:%d.%d.%d", appVer, cur_major, cur_minor, cur_rc);
    
    if((cur_major < min_major) || (cur_major == min_major && cur_minor < min_minor) || (cur_major == min_major && cur_minor == min_minor && cur_rc < min_rc)){
        return -2;
    }
    
    if((cur_major < latest_major) || (cur_major == latest_major && cur_minor < latest_minor) || (cur_major == latest_major && cur_minor == latest_minor && cur_rc < latest_rc)){
        
        newversion = [NSString stringWithFormat:@"%d.%d.%d", latest_major, latest_minor, latest_rc];
        return 2;
    }
    
    return 1;

}

- (BOOL)checkInputText
{
    if ([m_strUser length] == 0)
    {
        UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"账号为空，请输入."] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [altview show];
        return NO;
    }
    if ([m_strPwd length] == 0)
    {
        UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"密码为空，请输入."] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [altview show];
        return NO;
    }
    
    return YES;
}


-(void)parseContent
{
    ret_newversion = 0;
    ret_pwd = 0;

    m_strUser = [m_txtFldUser.text copy];
    m_strPwd = [m_txtFldPwd.text copy];
    
    if (![self checkInputText]) {
        return;
    }
    
    notify_number = 0;
    
    net_ops = 2;

    ret_newversion = [self checkVersion];
    if(ret_newversion > 0){
        ret_pwd = [net_smth net_LoginBBS:m_strUser :m_strPwd];
    }

    m_bLoadRes = 1;
}

- (void)goContentView
{
    ParentTabBarViewController * parentTabBarController = [UIViewController appGetView:@"ParentTabBarController"];
    
    g_tabbar = parentTabBarController;
    
    [self presentViewController:parentTabBarController animated:YES completion:nil];
}

-(void)updateContent
{
    if(ret_newversion == -2)
    {
        
        UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"错误" message:[NSString stringWithFormat:@"应用版本太低，请升级后重试"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [altview show];
    }else if (ret_newversion > 0 && ret_pwd > 0)
    {
#if 0
        NSString * str_prev_user = [appSetting getLoginInfoUsr];
#endif
        
        //save info, tip and go
        [appSetting setLoginInfo:m_strUser :m_strPwd];//save
#if 1
        if(1){
#else
        if(str_prev_user == nil || ![str_prev_user isEqualToString:m_strUser]){
#endif
            //change usrname, update APNS
            apiUpdateAPNS(nil);
        }

        /* load friends list */
        NSString * friends_tsstr = apiGetUserData_config(@"friends_ts");
        long long f_old_ts;
        if(friends_tsstr == nil){
            f_old_ts = 0;
        }else{
            f_old_ts = [friends_tsstr longLongValue];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AppViewController * view_test = [[AppViewController alloc] init];
            [view_test init_without_UI];
            
            long long f_new_ts = [view_test->net_smth net_LoadUserFriendsTS:[appSetting getLoginInfoUsr]];
            if(f_new_ts == 0){
                NSLog(@"friends new ts 0, exit");
            }else if(f_old_ts >= f_new_ts){
#ifdef DEBUG
                NSLog(@"friends the same, no change");
#endif
            }else{
                
                NSArray * friends = [view_test->net_smth net_LoadUserAllFriends:[appSetting getLoginInfoUsr]];
#ifdef DEBUG
                NSLog(@"download friend list %d", view_test->net_smth->net_error);
#endif
                if(view_test->net_smth->net_error == 0){
                    NSMutableDictionary * friends_dict = [[NSMutableDictionary alloc] init];
                    for(NSDictionary * f in friends){
                        NSString * exp = [f objectForKey:@"EXP"];
                        if(exp == nil){
                            exp = @"";
                        }
                        [friends_dict setObject:exp forKey:[f objectForKey:@"ID"]];
                    }

                    apiSetUserData_friends(friends_dict);
                    apiSetUserData_config(@"friends_ts", [NSString stringWithFormat:@"%lld",f_new_ts]);
                }
            }
        });
        /* load friends list done */
            
        
        if(ret_newversion == 2){
            if(![newversion isEqualToString:appSetting->my_dismiss_version]){
                alert_delegate_mode = 1;
                UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"应用有更新版本，建议升级" message:last_changelog delegate:self cancelButtonTitle:@"继续提示此版本" otherButtonTitles:@"不再提示此版本", nil];
                [altview show];
            }
        }
            
        if(notify_number > appSetting->my_notify_number){
            alert_delegate_mode = 2;
            UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"通知" message:notify_msg delegate:self cancelButtonTitle:@"继续提示此条通知" otherButtonTitles:@"不再提示此条通知", nil];
            [altview show];
        }

        [self goContentView];
    }
}
    
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"click:%ld", (long)buttonIndex);
    if(buttonIndex == 0){
        //cancel:
        if(alert_delegate_mode == 1){
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/newsmth-shui-mu-she-qu/id806785249?mt=8"]];
        }
    }else if(buttonIndex == 1){
        //不再提示
        if(alert_delegate_mode == 1){
            //不再提示新版本
            [appSetting appSettingChange:@"dismiss_version" :newversion];
            appSetting->my_dismiss_version = [newversion copy];
        }else{
            //不再提示新通知
            [appSetting appSettingChange:@"my_notify_number" :[NSString stringWithFormat:@"%d", notify_number] ];
            appSetting->my_notify_number = notify_number;
        }
    }
}
    
- (IBAction) textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}
    
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
    
@end
