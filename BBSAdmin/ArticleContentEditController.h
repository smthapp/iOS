//
//  ArticleContentEditController.h
//  BBSAdmin
//
//  Created by HE BIAO on 1/21/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "InfoCenter.h"
#import "AppViewController.h"

@interface ArticleContentEditController : AppViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
{
    NSString * m_lBoardId;
    NSString * m_lBoardName;
    NSDictionary * reply;
    
    bool mailmode; //reply to mail
    bool mail_from_article;//true: 回邮件，reply是文章, false: 回邮件，reply是邮件
    
    bool waiting_for_mbselect;
    
    //att
    NSString * att0_fname;
}

- (IBAction)pressBtSend:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *m_labelBoard;
@property (strong, nonatomic) IBOutlet UITextField *m_textTitle;
@property (strong, nonatomic) IBOutlet UITextView *m_textCont;
@property (strong, nonatomic) IBOutlet UITextField *text_mailrecv;
@property (strong, nonatomic) IBOutlet UILabel *label_mailrecv;
@property (strong, nonatomic) IBOutlet UIButton *btn_mbselect;
@property (strong, nonatomic) IBOutlet UINavigationItem *navi;
- (IBAction)pressBtnMBSelect:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *image_att;


//public API
/**
 *@ param boardid,boardname used only in !to_mail mode
 *@ param _mail_from_article used only in to_mail mode.
 */
- (void)setContentInfo:(bool)to_mail :(NSString*)boardid :(NSString*)boardname :(NSDictionary *)reply_dict :(bool)_mail_from_article;


@end
