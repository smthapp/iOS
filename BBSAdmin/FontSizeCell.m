//
//  FontSizeCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 3/4/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "FontSizeCell.h"
#import "InfoCenter.h"

@implementation FontSizeCell
@synthesize label_txt,slider_size;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)set_label
{
    label_txt.text = [NSString stringWithFormat:@"文章字体 [%d号]",appSetting->font_size];
    label_txt.font = [UIFont fontWithName:@"Helvetica Neue" size:appSetting->font_size];
}

-(void)loadFontSize
{
    [self set_label];
    
    slider_size.value = appSetting->font_size;
    
    [slider_size addTarget:self action:@selector(fontChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)fontChanged:(UISlider *)sender
{
    int newv = sender.value;
    
    if(newv == appSetting->font_size){
        return;
    }
    
    appSetting->font_size = newv;
#ifdef DEBUG
    NSLog(@"fontsize:%d", newv);
#endif

    [self set_label];
    
    [appSetting appSettingChange:@"font_size" :[NSString stringWithFormat:@"%d",appSetting->font_size]];
}

@end
