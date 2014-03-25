//
//  ContentLabel.h
//  BBSAdmin
//
//  Created by HE BIAO on 3/17/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface ContentLabel : UILabel
{
    NSMutableAttributedString *attString;
    bool prev_line_empty;
}

- (void)setContentInfo:(NSString *)text;
- (CGFloat)get_height;

@end
