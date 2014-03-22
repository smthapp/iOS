//
//  UserinfoViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/26/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoCenter.h"
#import "AppViewController.h"

@interface UserinfoViewController : AppViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSString * userid;
    NSDictionary * userinfo;
    
    bool is_friend;
    
    int parse_mode; //0:list 1:add friend 2:del friend 3:edit face
    
    NSString * face_fname;
}

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

- (void)setContentInfo:(NSString *)_userid;
- (void)edit_face;

@end
