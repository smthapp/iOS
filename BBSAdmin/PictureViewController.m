//
//  PictureViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/28/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "PictureViewController.h"

@interface PictureViewController ()

@end

@implementation PictureViewController
@synthesize _imageView,_scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)enable_scroll
{
    CGFloat scale = 3.0f;
    if(_imageView.frame.size.width / _scrollView.frame.size.width > scale){
        scale = _imageView.frame.size.width / _scrollView.frame.size.width;
    }
    if(_imageView.frame.size.height / _scrollView.frame.size.height > scale){
        scale = _imageView.frame.size.height / _scrollView.frame.size.height;
    }
    
    _scrollView.maximumZoomScale = scale;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _scrollView.delegate = self;
    [_scrollView setBackgroundColor:[UIColor blackColor]];
    
    _scrollView.userInteractionEnabled = YES;

    int exist = [_imageView setContentInfo:board :reply_id :pos :1 :2 :self];

    //single click to exit
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage)];
    [_scrollView addGestureRecognizer:singleTap];

    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_imageView];
    
    [_scrollView setZoomScale:1.0f animated:NO];
    
    if(exist) {
        [self enable_scroll];
    }
}

- (void)onClickImage
{
#ifdef DEBUG
    NSLog(@"clicked");
#endif
    [self dismissViewControllerAnimated:NO completion:Nil];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
#ifdef DEBUG
    NSLog(@"scale is %f",scale);
#endif
    [_scrollView setZoomScale:scale animated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)SetContentInfo:(NSString *)board_id :(long)_reply_id :(long)att_pos
{
    board = [board_id copy];
    reply_id = _reply_id;
    pos = att_pos;
}



@end
