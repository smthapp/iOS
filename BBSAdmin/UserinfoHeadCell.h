//
//  UserinfoHeadCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/26/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFaceImageView.h"

@interface UserinfoHeadCell : UITableViewCell
{
    
    
}
@property (strong, nonatomic) IBOutlet UIFaceImageView *img_face;
@property (strong, nonatomic) IBOutlet UILabel *label_userid;
@property (strong, nonatomic) IBOutlet UILabel *label_gender;
@property (strong, nonatomic) IBOutlet UILabel *label_title;
@property (strong, nonatomic) IBOutlet UIImageView *img_friend;

-(void)setContentInfo:(NSString *)userid :(NSString *)title :(NSString *)faceurl :(int)female :(UIViewController *)parent;

@end
