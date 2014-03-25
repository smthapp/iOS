//
//  ArticleContentCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 1/20/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "ArticleContentCell.h"
#import "InfoCenter.h"
#import "UIAttImageView.h"
#import "UserData.h"

@implementation ArticleContentCell
@synthesize img_user, m_labelUsr, m_labelDetailInfo, m_txtViewArtContent, label_lou, img_friend;
@synthesize view_bg;

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

- (CGFloat)get_height_text:(NSString *)body
{
    CGRect rect = m_txtViewArtContent.frame;
    
//    [m_txtViewArtContent setText:body];

    [m_txtViewArtContent setContentInfo:body];

    rect.size.height = [m_txtViewArtContent get_height];
    
    [m_txtViewArtContent setFrame:rect];
    
    return rect.origin.y + rect.size.height + 8;
}

- (CGFloat)get_height:(NSString *)body :(NSArray *)att_array
{
    CGFloat height = [self get_height_text:body];

    //calc image
    if(att_array){
        int i;
        for(i=0; i<[att_array count]; i++){
            NSDictionary * dict = [att_array objectAtIndex:i];
            UIImageView * imgview = [dict objectForKey:@"imgview"];
            
            if(imgview){
                UIImage * img = imgview.image;

                if(img && img.size.width){
                    height += m_txtViewArtContent.frame.size.width * img.size.height / img.size.width;
                }else{
                    height += m_txtViewArtContent.frame.size.width / 8;
                }
            }
            height += 2;
        }
        height += 5;
    }

    return height;
}

- (void)setContentInfo:(NSString*)strHeader :(NSString*)strUsr :(NSString*)strDetailInfo :(NSString*)strContent :(int)_lou :(NSArray *)_att :(UITableView *)_tv :(NSIndexPath *)_ip :(UIViewController *)_parent
{
    
    parent = _parent;
    
    tv = _tv;
    index_path = _ip;
    
    if(_att == nil){
        att = nil;
    }else{
        att = [_att copy];
    }
    
    [m_labelUsr setText:strUsr];
    [m_labelDetailInfo setText:strDetailInfo];
    
    NSRange t_range = [strUsr rangeOfString:@"."];
    if(t_range.location == NSNotFound){
        //if 'author' contain '.', means 转信
        [img_user setContentInfo:strUsr :1 :parent];
        if(! apiGetUserData_is_friends(strUsr)){
            [img_friend setHidden:YES];
        }else{
            [img_friend setHidden:NO];
        }
    }
    
    lou = _lou;
    
    if(lou < 0){
        [label_lou setHidden:YES];
    }else if(lou == 0){
        [label_lou setText:@"楼主"];
    }else{
        [label_lou setText:[NSString stringWithFormat:@"%d楼", lou]];
    }
    
    CGFloat height = [self get_height_text:strContent];

    if(att == nil){
        goto set_bg;
    }
    
    //show image
    int i;
    CGRect rect = m_txtViewArtContent.frame;
    for(i=0; i<[att count]; i++){
        NSDictionary * att_dict = [att objectAtIndex:i];

        UIAttImageView * imageview = [att_dict objectForKey:@"imgview"];
        [imageview att_set_cell:tv :index_path];
        
        CGFloat image_h;
        if(imageview.image.size.width != 0){
            image_h = rect.size.width * imageview.image.size.height / imageview.image.size.width;
        }else{
            image_h = rect.size.width / 8;
        }
        imageview.frame = CGRectMake(rect.origin.x, height, rect.size.width, image_h);

        [m_imageviews addObject:imageview];

        [view_bg addSubview:imageview];
        
        height += image_h;
        height += 2;
    }
    height += 5;
    
set_bg:
    {
        CGRect rect = view_bg.frame;
        if(lou == 0){
            rect.origin.y += 5;
        }
        rect.size.height = height - 1;
        [view_bg setFrame:rect];
        [view_bg.layer setBorderWidth:0.5];
        [view_bg.layer setBorderColor:[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0].CGColor];
    }

}

- (void)clear_image
{
    if(m_imageviews == nil){
        m_imageviews = [[NSMutableArray alloc] init];
    }else{
        int i;
        for(i=0; i<[m_imageviews count]; i++){
            NSLog(@"remove image");
            UIAttImageView * iv = [m_imageviews objectAtIndex:i];
            [iv att_set_cell:nil :nil];
            [iv removeFromSuperview];
        }
        [m_imageviews removeAllObjects];
    }
}

- (void)removeFromSuperview
{
    int i;
    for(i=0; i<[m_imageviews count]; i++){
        UIAttImageView * iv = [m_imageviews objectAtIndex:i];
        [iv att_set_cell:nil :nil];
    }
    [super removeFromSuperview];
}


- (void)init_fontsize
{
    m_txtViewArtContent.font = [UIFont fontWithName:@"Helvetica Neue" size:appSetting->font_size];
}
@end
