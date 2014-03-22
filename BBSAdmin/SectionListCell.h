//
//  SectionListCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/24/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label_name;

-(void)setContentInfo:(NSString*)name;
@end
