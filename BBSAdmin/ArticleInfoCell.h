//
//  ArticleInfoCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/24/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFaceImageView.h"

@interface ArticleInfoCell : UITableViewCell
{
    NSString * userid;
    UIViewController * parent;
}
@property (strong, nonatomic) IBOutlet UIImageView *image_att;
@property (strong, nonatomic) IBOutlet UILabel *label_title;
@property (strong, nonatomic) IBOutlet UILabel *label_author;
@property (strong, nonatomic) IBOutlet UILabel *label_posttime;
@property (strong, nonatomic) IBOutlet UILabel *label_replytime;
@property (strong, nonatomic) IBOutlet UIFaceImageView *image_face;
@property (strong, nonatomic) IBOutlet UIImageView *img_friend;
@property (strong, nonatomic) IBOutlet UIImageView *img_reply;

//public API
/**
 *@
 */
-(void)setContentInfo:(NSString *)title :(NSString *)author :(NSString *)posttime :(NSString *)replytime :(int)att :(int)unread :(int)ding :(int)reply_unread :(int)reply_cnt :(UIViewController *)_parent;


@end
