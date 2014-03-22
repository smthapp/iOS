//
//  ArticleInfoCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 1/24/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "ArticleInfoCell.h"
#import "UserData.h"

@implementation ArticleInfoCell
@synthesize label_author,label_posttime,label_replytime,label_title,image_att;
@synthesize image_face, img_friend, img_reply;

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

-(void)setContentInfo:(NSString *)title :(NSString *)author :(NSString *)posttime :(NSString *)replytime :(int)att :(int)unread :(int)ding :(int)reply_unread :(int)reply_cnt :(UIViewController *)_parent
{
    parent = _parent;
    
    if(reply_cnt < 10){
    }else if(reply_cnt < 100){
        img_reply.image = [UIImage imageNamed:@"icon-article-light.png"];
    }else if(reply_cnt < 1000){
        img_reply.image = [UIImage imageNamed:@"icon-article-fire.png"];
    }else{
        img_reply.image = [UIImage imageNamed:@"icon-article-huo.png"];
    }
    
    if(reply_unread){
        label_replytime.textColor = [UIColor redColor];
    }
    
    if(!att){
        [image_att removeFromSuperview];
    }
    if(ding){
        label_title.textColor = [UIColor redColor];
        [label_title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    }
    if(unread){
        label_posttime.textColor = [UIColor redColor];
    }
    
    [label_replytime setText:replytime];
    [label_posttime setText:posttime];
    
    userid = [author copy];
    [label_author setText:author];
    
    NSRange t_range = [userid rangeOfString:@"."];
    if(t_range.location == NSNotFound){
        //if 'author' contain '.', means 转信
        [image_face setContentInfo:userid :1 :parent];
        if(! apiGetUserData_is_friends(userid)){
            [img_friend setHidden:YES];
        }else{
            [img_friend setHidden:NO];
        }
    }
    
    [label_title setText:title];
}

@end
