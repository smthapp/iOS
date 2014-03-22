//
//  GuessInfoCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/30/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuessInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label_name;

-(void)setContentInfo:(NSString*)name;

@end
