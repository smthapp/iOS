//
//  MessageInfoCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/24/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label_name;
@property (strong, nonatomic) IBOutlet UILabel *label_count;
@property (strong, nonatomic) IBOutlet UIImageView *imageview_dir;

//public API
-(void)setContentInfo:(NSString*)name :(int)unread :(UIImage *)image;

@end
