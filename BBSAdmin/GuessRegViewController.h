//
//  GuessRegViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/4/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "InfoCenter.h"
#import "AppViewController.h"

@interface GuessRegViewController : AppViewController
{
    NSString * userid;
    int guessid;
}
@property (strong, nonatomic) IBOutlet UILabel *label_userid;
@property (strong, nonatomic) IBOutlet UITextField *text_realname;
@property (strong, nonatomic) IBOutlet UITextField *text_phone;
- (IBAction)pressBtnReg:(id)sender;

-(void)setContentInfo:(int)_guessid :(NSString *)_userid;

@end
