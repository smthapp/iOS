//
//  MatchHeadCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/3/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "MatchHeadCell.h"

@implementation MatchHeadCell
@synthesize label_mymoney,label_name,label_status;

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

-(void)setContentInfo:(NSString *)name :(NSString *)money :(NSString *)status
{
    [label_name setText:name];

    [label_mymoney setText:money];

    [label_status setText:status];
}

@end
