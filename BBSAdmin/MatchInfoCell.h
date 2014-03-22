//
//  MatchInfoCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/30/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label_name;
@property (strong, nonatomic) IBOutlet UIImageView *img_icon;

//public API
/**
 *@ param dirmode 1:show top, 2:show mymoney 0:others
 */
-(void)setContentInfo:(NSString*)name :(int)dirmode;

@end
