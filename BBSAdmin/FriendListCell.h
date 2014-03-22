//
//  FriendListCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/28/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFaceImageView.h"

@interface FriendListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label_userid;
@property (strong, nonatomic) IBOutlet UIFaceImageView *img_user;

-(void)setContentInfo:(NSString *)userid;

@end
