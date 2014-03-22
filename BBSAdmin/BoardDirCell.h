//
//  BoardDirCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/24/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardDirCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label_name;
@property (strong, nonatomic) IBOutlet UILabel *label_desc;

//public API
-(void)setContentInfo:(NSString*)name;
@end
