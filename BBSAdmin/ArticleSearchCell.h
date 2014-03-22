//
//  ArticleSearchCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/5/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleListViewController.h"

@interface ArticleSearchCell : UITableViewCell
{
    UIViewController * parent_view_controller;
}
@property (strong, nonatomic) IBOutlet UITextField *text_query;
- (IBAction)pressBtnTitle:(id)sender;
- (IBAction)pressBtnUser:(id)sender;

- (void)setContentInfo:(UIViewController *)parent;

@end
