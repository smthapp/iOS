//
//  SINavigationMenuView.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SINavigationMenuView.h"
#import "SIMenuButton.h"
#import "QuartzCore/QuartzCore.h"
#import "SIMenuConfiguration.h"

@interface SINavigationMenuView  ()
@property (nonatomic, strong) SIMenuButton *menuButton;
@property (nonatomic, strong) SIMenuTable *table;
@property (nonatomic, strong) UIView *menuContainer;
@property (nonatomic, strong) UITapGestureRecognizer * leftTap;
@property (nonatomic, strong) UITapGestureRecognizer * rightTap;
@property (nonatomic, strong) UIView * leftView;
@property (nonatomic, strong) UIView * rightView;
@end

@implementation SINavigationMenuView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title :(NSString *)img_name
{
    self = [super initWithFrame:frame];
    if (self) {
        frame.origin.y += 1.0;
        self.menuButton = [[SIMenuButton alloc] initWithFrame:frame :img_name];
        self.menuButton.title.text = title;
        [self.menuButton addTarget:self action:@selector(onHandleMenuTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.menuButton];
    }
    self.leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBackgroundTap)];
    self.rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBackgroundTap)];
    return self;
}

- (void)setMenuTitle:(NSString *)title
{
    self.menuButton.title.text = title;
}

- (void)setMenuArrow:(NSString *)fname
{
    self.menuButton.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:fname]];
}

- (void)displayMenuInView:(UIView *)view
{
    self.menuContainer = view;
}

#pragma mark -
#pragma mark Actions
- (void)onHandleMenuTap:(id)sender
{
    if (self.menuButton.isActive) {
        [self onShowMenu];
    } else {
        [self onHideMenu];
    }
}

- (void)onShowMenu
{
    CGFloat width = 200.0;
    CGFloat y_offset;
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if(version >= 7.0f){
        y_offset = 64.0;
    }else{
        y_offset = 44.0;
    }
    
    if (!self.table) {
        //CGFloat width = self.menuContainer.frame.size.width;
        CGRect frame = CGRectMake((self.menuContainer.frame.size.width - width) /2, y_offset, width, self.menuContainer.frame.size.height - y_offset);
        self.table = [[SIMenuTable alloc] initWithFrame:frame items:self.items];
        self.table.menuDelegate = self;
        
        if(width < self.menuContainer.frame.size.width) {
            self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, y_offset, (self.menuContainer.frame.size.width - width) /2, self.menuContainer.frame.size.height - y_offset)];
            self.rightView = [[UIView alloc] initWithFrame:CGRectMake((self.menuContainer.frame.size.width + width) /2, y_offset, (self.menuContainer.frame.size.width - width) /2, self.menuContainer.frame.size.height - y_offset)];
        }
    }
    [self.menuContainer addSubview:self.table];
    [self rotateArrow:M_PI];
    [self.table show];

    [self.menuContainer addSubview:self.leftView];
    [self.leftView addGestureRecognizer:self.leftTap];
    [self.menuContainer addSubview:self.rightView];
    [self.rightView addGestureRecognizer:self.rightTap];
}

- (void)onHideMenu
{
    [self.leftView removeGestureRecognizer:self.leftTap];
    [self.leftView removeFromSuperview];
    [self.rightView removeGestureRecognizer:self.rightTap];
    [self.rightView removeFromSuperview];

    [self rotateArrow:0];
    [self.table hide];
}

- (void)rotateArrow:(float)degrees
{
    [UIView animateWithDuration:[SIMenuConfiguration animationDuration] delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.menuButton.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}

#pragma mark -
#pragma mark Delegate methods
- (void)didSelectItemAtIndex:(NSUInteger)index
{
    self.menuButton.isActive = !self.menuButton.isActive;
    [self onHandleMenuTap:nil];
    [self.delegate didSelectItemAtIndex:index];
}

- (void)didBackgroundTap
{
    self.menuButton.isActive = !self.menuButton.isActive;
    [self onHandleMenuTap:nil];
}

#pragma mark -
#pragma mark Memory management
- (void)dealloc
{
    self.items = nil;
    self.menuButton = nil;
    self.menuContainer = nil;
}

@end
