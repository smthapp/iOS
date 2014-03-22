//
//  BoardInfoCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/24/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *label_name;
@property (strong, nonatomic) IBOutlet UILabel *label_desc;
@property (strong, nonatomic) IBOutlet UILabel *label_article;
@property (strong, nonatomic) IBOutlet UILabel *label_online;
@property (strong, nonatomic) IBOutlet UIImageView *img_board;

//public API
-(void)setContentInfo:(NSString *)name :(NSString *)desc :(int)article :(int)online :(int)unread :(long)flag;

@end
