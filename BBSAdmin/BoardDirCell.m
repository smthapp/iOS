//
//  BoardDirCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 1/24/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "BoardDirCell.h"

@implementation BoardDirCell
@synthesize label_name,label_desc;

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
    //替换中文空格为英文空格
    NSString * ename = [name stringByReplacingOccurrencesOfString:@"　" withString:@" "];
    
    NSRange r = [ename rangeOfString:@" "];
    if(r.location == NSNotFound){
        [label_name setText:ename];
        [label_desc setText:@""];
        return;
    }
    
    NSString * info = [ename substringToIndex:r.location];
    int i = (int)r.location + 1;
    for(; i < [ename length] && [ename characterAtIndex:i] == ' '; i++);
    NSString * detail;
    if(i >= [ename length]){
        detail = @"";
    }else{
        detail = [ename substringFromIndex:i];
    }
    [label_name setText:info];
    [label_desc setText:detail];
}

@end
