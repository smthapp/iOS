//
//  BoardSearchCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/5/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "BoardSearchCell.h"

@implementation BoardSearchCell
@synthesize text_query;

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

- (IBAction)btn_search:(id)sender {
    if([text_query.text length] > 0){
        [(SeriePlatesViewController *)parent_view_controller do_search:text_query.text];
    }
}

- (void)setContentInfo:(UIViewController *)parent
{
    parent_view_controller = parent;
}

@end
