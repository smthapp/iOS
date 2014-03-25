//
//  UserinfoHeadCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/26/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "UserinfoHeadCell.h"
#import "UserData.h"

@implementation UserinfoHeadCell
@synthesize label_gender,label_title,label_userid,img_face,img_friend;

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

-(void)setContentInfo:(NSString *)userid :(NSString *)title :(NSString *)faceurl :(int)female :(UIViewController *)parent
{
    if(female){
        [label_gender setText:@"性别: 女"];
    }else{
        [label_gender setText:@"性别: 男"];
    }
    
    [label_title setText:[NSString stringWithFormat:@"身份: %@", title]];
    [label_userid setText:userid];

    NSString * face_id;

    if(faceurl && ![faceurl isEqualToString:@""]){
        face_id = faceurl;
    }else{
        face_id = userid;
    }
    
    if([userid caseInsensitiveCompare:[appSetting getLoginInfoUsr]] == NSOrderedSame){
        [img_face setContentInfo:face_id :2 :parent];
    }else{
        [img_face setContentInfo:face_id :0 :nil];
    }
    
    
    if(apiGetUserData_is_friends(userid)){
        [img_friend setHidden:NO];
    }else{
        [img_friend setHidden:YES];
    }
}

@end
