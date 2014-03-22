//
//  PictureViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/28/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAttImageView.h"

@interface PictureViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    UIAttImageView * _imageView;
    
    NSString * board;
    long reply_id;
    long pos;
}
@property (strong, nonatomic) IBOutlet UIScrollView *_scrollView;
@property (strong, nonatomic) IBOutlet UIAttImageView *_imageView;


//public API
/**
 *@ param
 */
- (void)SetContentInfo:(NSString *)board_id :(long)_reply_id :(long)att_pos;

/**
 *@ brief
 */
- (void)enable_scroll;

@end
