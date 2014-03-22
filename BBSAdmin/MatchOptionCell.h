//
//  MatchOptionCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/3/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoCenter.h"
#import "MatchContentViewController.h"

@interface MatchOptionCell : UITableViewCell
{
    int guessid;
    int matchid;
    int mode;
    
    float odds;
    int sel;
    
    UIViewController * parent;
}

@property (strong, nonatomic) IBOutlet UILabel *label_name;
@property (strong, nonatomic) IBOutlet UILabel *label_odds;
@property (strong, nonatomic) IBOutlet UILabel *label_voted;
@property (strong, nonatomic) IBOutlet UILabel *label_add;
@property (strong, nonatomic) IBOutlet UITextField *text_addmoney;
- (IBAction)pressBtnAdd:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *button_add;

-(void)setContentInfo:(NSString*)name :(int)_mode :(float)_odds :(int)voted :(int)_sel :(int)status :(UIViewController *)_parent;

@end
