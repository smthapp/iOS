//
//  GuessRegViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/4/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "GuessRegViewController.h"

@interface GuessRegViewController ()

@end

@implementation GuessRegViewController
@synthesize label_userid, text_phone, text_realname;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [label_userid setText:[NSString stringWithFormat:@"用户名: %@", userid]];
}

- (bool)scroll_enabled
{
    return false;
}

- (IBAction)pressBtnReg:(id)sender {
    [self loadContent];
}

- (void)parseContent
{
    if([text_realname.text length] <= 0 || [text_phone.text length] <= 4){
        UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"错误" message:[NSString stringWithFormat:@"真实姓名和电话号码必须填写"] delegate:nil cancelButtonTitle:@"更改" otherButtonTitles:nil];
        [altview show];
        return;
    }
    int ret = [net_smth net_RegGuess:guessid :text_realname.text :text_phone.text];
    if(net_smth->net_error != 0 || ret != 0){
        UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"错误" message:[NSString stringWithFormat:@"系统出错"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [altview show];
        return;
    }else{
        m_bLoadRes = 1;
    }
}

- (void)updateContent
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setContentInfo:(int)_guessid :(NSString *)_userid
{
    userid = [_userid copy];
    guessid = _guessid;
}

@end
