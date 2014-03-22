//
//  ArticleForwardViewController.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/8/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoCenter.h"
#import "AppViewController.h"


@interface ArticleForwardViewController : AppViewController
{
    NSString * m_lBoardId;
    NSString * m_lBoardName;
    NSDictionary * reply;
    
    bool dst_is_mail; //true: forward to mail, false: forward to article
    bool src_is_article;//true: reply是文章, false: reply是邮件
}

@property (strong, nonatomic) IBOutlet UILabel *label_title;
@property (strong, nonatomic) IBOutlet UITextField *text_user;
- (IBAction)pressBtnSend:(id)sender;

//public API
/**
 *@ param from_article
 */
- (void)setContentInfo:(bool)from_article :(NSString*)boardid :(NSString*)boardname :(NSDictionary *)reply_dict;

@end
