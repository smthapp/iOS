//
//  TimelineListCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/10/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "TimelineListCell.h"
#import "UserData.h"
#import "ArticleListViewController.h"
#import "UIViewController+AppGet.h"
#import <QuartzCore/QuartzCore.h>

@implementation TimelineListCell
@synthesize img_att,label_content,label_posttime,label_replytime,label_title,label_userid;
@synthesize img_user, img_friend, img_reply;
@synthesize view_bg, view_imgs, label_board, img_board;
@synthesize label_reply_content,label_reply_title,view_reply_bg;

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

- (CGFloat)get_height_title:(NSString *)title
{
    if(title == nil) {
        title = @"";
    }
    
    CGSize size = [title sizeWithFont:label_title.font constrainedToSize:CGSizeMake(label_title.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];

    [label_title setText:title];
    CGRect rect = label_title.frame;
    rect.size.height = size.height;
    [label_title setFrame:rect];

    return size.height;
}

- (CGFloat)get_height_content:(NSString *)body
{
    if(body == nil) {
        body = @"";
    }
    label_content.font = [UIFont fontWithName:@"Helvetica Neue" size:appSetting->font_size];

    CGSize size = [body sizeWithFont:label_content.font constrainedToSize:CGSizeMake(label_content.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];

    [label_content setText:body];
    CGRect rect = label_content.frame;
    rect.size.height = size.height;
    [label_content setFrame:rect];

    return size.height;
}

- (CGFloat)get_height_reply:(NSString *)body
{
    label_reply_content.font = [UIFont fontWithName:@"Helvetica Neue" size:appSetting->font_size - 1];
    
    CGSize size = [body sizeWithFont:label_reply_content.font constrainedToSize:CGSizeMake(label_reply_content.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    [label_reply_content setText:body];
    CGRect rect = label_reply_content.frame;
    rect.size.height = size.height;
    [label_reply_content setFrame:rect];
    
    return size.height;
}

- (NSString *)get_content_str:(NSDictionary *)dict
{
    //int effsize = [[dict objectForKey:@"sl"] intValue];
    //if(effsize == 0){
        return [dict objectForKey:@"s"];
    //}
    //return [NSString stringWithFormat:@"%@ [还有%d字节]",[dict objectForKey:@"s"],effsize];
}

- (NSString *)get_reply_str:(NSDictionary *)dict
{
    //int effsize = [[dict objectForKey:@"rl"] intValue];
    //if(effsize == 0){
        return [dict objectForKey:@"r"];
    //}
    //return [NSString stringWithFormat:@"%@ [还有%d字节]",[dict objectForKey:@"r"],effsize];
}

- (CGFloat)get_height:(NSDictionary *)dict{
    CGFloat content_height = [self get_height_content:[self get_content_str:dict]];
    CGFloat title_height = [self get_height_title:[dict objectForKey:@"subject"]];

    CGFloat delta_title = 0;
    if(title_height > 20){
        delta_title = title_height - 20;
    }else{
        delta_title = 0;
    }
    
    if([[dict objectForKey:@"count"] intValue] > 1){
        CGFloat reply_height = [self get_height_reply:[self get_reply_str:dict]];
        
        return view_imgs.frame.origin.y + label_content.frame.origin.y + content_height + label_reply_content.frame.origin.y + reply_height + 10 +  delta_title + 14;
    }else{
        return view_imgs.frame.origin.y + label_content.frame.origin.y + content_height + delta_title + 14;
    }
}

-(void)setContentInfo:(NSDictionary *)dict :(NSTimeInterval)ts :(long long int)last_read_time :(UIViewController *)_parent
{
    parent = _parent;
    
    int reply_count = [(NSString *)[dict objectForKey:@"count"] intValue];
    if(reply_count > 0){
        reply_count --;
    }

    CGFloat content_height = [self get_height_content:[self get_content_str:dict]];
    CGFloat title_height = [self get_height_title:[dict objectForKey:@"subject"]];
    CGFloat delta_title = 0;
    if(title_height > 20){
        delta_title = title_height - 20;
    }else{
        delta_title = 0;
    }
    
    CGRect rect;
    rect = view_bg.frame;
    
    CGFloat view_imgs_height = 0;
    if(reply_count > 0){
        CGFloat reply_height = [self get_height_reply:[self get_reply_str:dict]];

        CGRect reply_rect = view_reply_bg.frame;
        reply_rect.origin.y = label_content.frame.origin.y + content_height + 5;
        reply_rect.size.height = label_reply_content.frame.origin.y + reply_height + 5;
        [view_reply_bg setFrame:reply_rect];
        [view_reply_bg.layer setMasksToBounds:YES];
        [view_reply_bg.layer setCornerRadius:3];
        [view_reply_bg.layer setBorderWidth:0.5];
        [view_reply_bg.layer setBorderColor:[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0].CGColor];
        
        [view_reply_bg setHidden:NO];
        
        rect.size.height = view_imgs.frame.origin.y + label_content.frame.origin.y + content_height + label_reply_content.frame.origin.y + reply_height + 10 + delta_title + 5;
        
    }else{
        [view_reply_bg setHidden:YES];

        rect.size.height = view_imgs.frame.origin.y + label_content.frame.origin.y + content_height + delta_title + 5;
    }
    view_imgs_height = rect.size.height - view_imgs.frame.origin.y - delta_title - 5;
    
    [view_bg setFrame:rect];
    [view_bg.layer setMasksToBounds:YES];
    [view_bg.layer setCornerRadius:3];
    [view_bg.layer setBorderWidth:0.5];
    [view_bg.layer setBorderColor:[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0].CGColor];
    
    rect = view_imgs.frame;
    rect.size.height = view_imgs_height;
    if(delta_title > 0){
        rect.origin.y += delta_title;
    }
    [view_imgs setFrame:rect];
    
    NSString * strTime = appGetDateString([(NSString *)[dict objectForKey:@"time"] intValue], ts);
    
    [label_posttime setText:[NSString stringWithFormat:@"%@", strTime]];
    if(last_read_time){
        if([(NSString *)[dict objectForKey:@"time"] longLongValue] > last_read_time){
            label_posttime.textColor = [UIColor redColor];
        }
    }
    
    boardid = [dict objectForKey:@"board_id"];
    boardname = [dict objectForKey:@"board_name"];
    [label_board setText:boardname];
    img_board.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBoard)];
    [img_board addGestureRecognizer:singleTap];
    
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
    }
    if(unread){
        label_posttime.textColor = [UIColor redColor];
    }
    
    NSString * strLastTime;
    if(reply_count > 0){
        strLastTime = appGetDateString([(NSString *)[dict objectForKey:@"last_time"] intValue], ts);
        if(reply_count < 10){
        }else if(reply_count < 100){
            img_reply.image = [UIImage imageNamed:@"icon-article-light.png"];
        }else if(reply_count < 1000){
            img_reply.image = [UIImage imageNamed:@"icon-article-fire.png"];
        }else{
            img_reply.image = [UIImage imageNamed:@"icon-article-huo.png"];
        }

        [label_reply_title setText:[NSString stringWithFormat:@"%@ 最后回复于 %@", [dict objectForKey:@"last_user_id"], strLastTime]];
    }else{
        strLastTime = @"";
    }
    [label_replytime setText:[NSString stringWithFormat:@"[%d]", reply_count]];

    if(reply_count > 0 && last_read_time){
        if([(NSString *)[dict objectForKey:@"last_time"] longLongValue] > last_read_time){
            label_replytime.textColor = [UIColor redColor];
            label_reply_title.textColor = [UIColor redColor];
        }
    }

    
}

- (void)onClickBoard
{
    if(parent == nil){
        return;
    }
    ArticleListViewController *artlistViewController = [UIViewController appGetView:@"ArtListViewController"];
    
    [artlistViewController setBoardArticleMode:boardid :boardname];

    [parent presentViewController:artlistViewController animated:YES completion:nil];

}


@end
