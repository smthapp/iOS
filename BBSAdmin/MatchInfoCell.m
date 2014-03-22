//
//  MatchInfoCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 1/30/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "MatchInfoCell.h"

@implementation MatchInfoCell
@synthesize label_name;
@synthesize img_icon;

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

-(void)setContentInfo:(NSString*)name :(int)dirmode
{
    [label_name setText:name];

    if(dirmode == 1){
        img_icon.image = [UIImage imageNamed:@"guess_top.png"];
    }else if(dirmode == 2){
        img_icon.image = [UIImage imageNamed:@"guess_mymoney.png"];
    }
}

@end
