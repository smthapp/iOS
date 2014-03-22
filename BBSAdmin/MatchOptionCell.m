//
//  MatchOptionCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/3/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "MatchOptionCell.h"

@implementation MatchOptionCell
@synthesize label_name;
@synthesize label_odds,label_voted,label_add,text_addmoney,button_add;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContentInfo:(NSString*)name :(int)_mode :(float)_odds :(int)voted :(int)_sel :(int)status :(UIViewController *)_parent
{
    [label_name setText:name];

    mode = _mode;
    odds = _odds;
    
    if(mode != 0){
        [label_odds setText:[NSString stringWithFormat:@"赔率: %.02f", odds]];
    }else{
        [label_odds setText:[NSString stringWithFormat:@"投注: %d注", (int)odds]];
    }

    if(voted){
        [label_voted setText:[NSString stringWithFormat:@"您已投%d注", voted]];
        [label_add setText:@"加注"];
    }else{
        [label_voted setHidden:YES];
        [label_add setText:@"投注"];
    }
    sel = _sel;
    
    if(status != 1){
        [button_add setHidden:YES];
    }
    
    parent = _parent;
}

- (IBAction)pressBtnAdd:(id)sender {
    int addmoney = [text_addmoney.text intValue];

    [(MatchContentViewController *)parent VoteMatch:sel :addmoney];
    return;
}

@end
