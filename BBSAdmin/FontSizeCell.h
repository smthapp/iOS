//
//  FontSizeCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 3/4/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontSizeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label_txt;
@property (strong, nonatomic) IBOutlet UISlider *slider_size;

-(void)loadFontSize;

@end
