//
//  ArticleContentCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/20/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFaceImageView.h"

@interface ArticleContentCell : UITableViewCell
{
    int lou;
    NSArray * att;
    NSMutableArray * m_imageviews;
    __weak UITableView * tv;
    NSIndexPath * index_path;
    UIViewController * parent;
}

@property (strong, nonatomic) IBOutlet UILabel *m_labelUsr;
@property (strong, nonatomic) IBOutlet UILabel *m_labelDetailInfo;
@property (strong, nonatomic) IBOutlet UITextView *m_txtViewArtContent;
@property (strong, nonatomic) IBOutlet UILabel *label_lou;
@property (strong, nonatomic) IBOutlet UIFaceImageView *img_user;
@property (strong, nonatomic) IBOutlet UIImageView *img_friend;

//public API
- (void)setContentInfo:(NSString*)strHeader :(NSString*)strUsr :(NSString*)strDetailInfo :(NSString*)strContent :(int)_lou :(NSArray *)_att :(UITableView *)_tv :(NSIndexPath *)_ip :(UIViewController *)_parent;

- (void)clear_image;
- (CGFloat)get_height:(NSString *)body :(NSArray *)att_dict;
- (void)init_fontsize;
@end
