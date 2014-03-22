//
//  BoardSearchCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/5/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeriePlatesViewController.h"

@interface BoardSearchCell : UITableViewCell
{
    UIViewController * parent_view_controller;
}
@property (strong, nonatomic) IBOutlet UITextField *text_query;
- (IBAction)btn_search:(id)sender;

//public API
- (void)setContentInfo:(UIViewController *)parent;


@end
