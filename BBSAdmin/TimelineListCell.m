//
//  TimelineListCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/10/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "TimelineListCell.h"
#import "UserData.h"

@implementation TimelineListCell
@synthesize img_att,label_content,label_posttime,label_replytime,label_title,label_userid;
@synthesize img_user, img_friend;

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

-(void)setContentInfo:(NSDictionary *)dict :(NSTimeInterval)ts :(long long int)last_read_time :(UIViewController *)_parent
{
    parent = _parent;
    
    NSString * strTime = appGetDateString([(NSString *)[dict objectForKey:@"time"] intValue], ts);
    NSString * boardname = [dict objectForKey:@"board_name"];
    
    [label_posttime setText:[NSString stringWithFormat:@"%@,版面:%@", strTime, boardname]];
    if(last_read_time){
        if([(NSString *)[dict objectForKey:@"time"] longLongValue] > last_read_time){
            label_posttime.textColor = [UIColor redColor];
        }
    }
    
    NSString * userid = [dict objectForKey:@"author_id"];
    
    [label_userid setText:userid];
    
    NSRange t_range = [userid rangeOfString:@"."];
    if(t_range.location == NSNotFound){
        //if 'author' contain '.', means 转信
        [img_user setContentInfo:userid :1 :parent];
        if(! apiGetUserData_is_friends(userid)){
            [img_friend setHidden:YES];
        }else{
            [img_friend setHidden:NO];
        }
    }
    
    int unread = 0;
    int att = 0;
    int ding = 0;
    
    if([(NSString *)[dict objectForKey:@"sa"] intValue] > 0){
        att = 1;
    }    
    if(!att){
        [img_att removeFromSuperview];
    }
    if(ding){
        label_title.textColor = [UIColor redColor];
        [label_title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    }
    if(unread){
        label_posttime.textColor = [UIColor redColor];
    }
 
    [label_title setText:[dict objectForKey:@"subject"]];
    
    int reply_count = [(NSString *)[dict objectForKey:@"count"] intValue];
    if(reply_count > 0){
        reply_count --;
    }
    NSString * strLastTime;
    if(reply_count > 0){
        strLastTime = appGetDateString([(NSString *)[dict objectForKey:@"last_time"] intValue], ts);
    }else{
        strLastTime = @"";
    }
    [label_replytime setText:[NSString stringWithFormat:@"[%d]%@", reply_count, strLastTime]];

    if(reply_count > 0 && last_read_time){
        if([(NSString *)[dict objectForKey:@"last_time"] longLongValue] > last_read_time){
            label_replytime.textColor = [UIColor redColor];
        }
    }

    
    NSString * summary = (NSString *)[dict objectForKey:@"s"];
    if(summary) {
        [label_content setText:summary];
    }else{
        [label_content setText:@""];
    }
    
}


@end
