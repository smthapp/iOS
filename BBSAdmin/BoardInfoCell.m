//
//  BoardInfoCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 1/24/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "BoardInfoCell.h"

@implementation BoardInfoCell
@synthesize label_article,label_desc,label_name,label_online;
@synthesize img_board;

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

-(void)setContentInfo:(NSString *)name :(NSString *)desc :(int)article :(int)online :(int)unread :(long)flag
{
    [label_name setText:name];
    [label_desc setText:desc];
    [label_online setText:[NSString stringWithFormat:@"%d",online]];
    [label_article setText:[NSString stringWithFormat:@"%d", article]];
    if(unread){
        label_article.textColor = [UIColor redColor];
    }
    if(flag & 0x1c0){
        //club
        img_board.image = [UIImage imageNamed:@"icon_board_club.png"];
    }
}

@end
