//
//  MatchHeadCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/3/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchHeadCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label_name;
@property (strong, nonatomic) IBOutlet UILabel *label_mymoney;
@property (strong, nonatomic) IBOutlet UILabel *label_status;


-(void)setContentInfo:(NSString *)name :(NSString *)status :(NSString *)money;
@end
