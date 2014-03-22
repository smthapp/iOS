//
//  GuessInfoCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 1/30/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "GuessInfoCell.h"

@implementation GuessInfoCell
@synthesize label_name;

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

-(void)setContentInfo:(NSString*)name
{
    [label_name setText:name];
}

@end
