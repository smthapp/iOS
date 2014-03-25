//
//  TimelineListCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/10/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoCenter.h"
#import "UIFaceImageView.h"

@interface TimelineListCell : UITableViewCell
{
    UIViewController * parent;
    
    NSString * boardid;
    NSString * boardname;
}
@property (strong, nonatomic) IBOutlet UILabel *label_userid;
@property (strong, nonatomic) IBOutlet UIImageView *img_att;
@property (strong, nonatomic) IBOutlet UILabel *label_title;
@property (strong, nonatomic) IBOutlet UILabel *label_posttime;
@property (strong, nonatomic) IBOutlet UILabel *label_replytime;
@property (strong, nonatomic) IBOutlet UILabel *label_content;
@property (strong, nonatomic) IBOutlet UIFaceImageView *img_user;
@property (strong, nonatomic) IBOutlet UIImageView *img_friend;
@property (strong, nonatomic) IBOutlet UIImageView *img_reply;
@property (strong, nonatomic) IBOutlet UIView *view_bg;
@property (strong, nonatomic) IBOutlet UIView *view_imgs;
@property (strong, nonatomic) IBOutlet UILabel *label_board;
@property (strong, nonatomic) IBOutlet UIImageView *img_board;
@property (strong, nonatomic) IBOutlet UIView *view_reply_bg;
@property (strong, nonatomic) IBOutlet UILabel *label_reply_title;
@property (strong, nonatomic) IBOutlet UILabel *label_reply_content;

-(void)setContentInfo:(NSDictionary *)dict :(NSTimeInterval)ts :(long long int)last_read_time :(UIViewController *)_parent;

- (CGFloat)get_height:(NSDictionary *)dict ;

@end
