//
//  ArticleContentEditController.m
//  BBSAdmin
//
//  Created by HE BIAO on 1/21/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "ArticleContentEditController.h"
#import "MBSelectViewController.h"
#import "UIViewController+AppGet.h"

@interface ArticleContentEditController ()

@end

@implementation ArticleContentEditController

@synthesize m_labelBoard;
@synthesize m_textTitle;
@synthesize m_textCont;
@synthesize label_mailrecv,text_mailrecv,btn_mbselect;
@synthesize image_att;
@synthesize navi;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    if(!mailmode){
        if(m_lBoardId == nil){
            //没有制定版面
            [label_mailrecv setHidden:YES];
            [m_labelBoard setHidden:YES];
            [text_mailrecv setText:@""];
        }else{
            //已经制定版面
            NSString * strBoard;
            [label_mailrecv setHidden:YES];
            [text_mailrecv setHidden:YES];
            strBoard = [NSString stringWithFormat:@"版面:%@", (m_lBoardName==nil)?m_lBoardId:m_lBoardName];
            [m_labelBoard setText:strBoard];
            [btn_mbselect setHidden:YES];
        }
    }else{
        if(reply){
            //已经制定收件人
            NSString * strBoard;
            [label_mailrecv setHidden:YES];
            [text_mailrecv setHidden:YES];
            strBoard = [NSString stringWithFormat:@"收件人:%@", (NSString *)[reply objectForKey:@"author_id"]];
            [m_labelBoard setText:strBoard];
        }else{
            //没有制定收件人
            [m_labelBoard setHidden:YES];
        }
        [btn_mbselect setHidden:YES];
        navi.title = @"发送邮件";
    }
    
    if(reply){
        NSString * title = [reply objectForKey:@"subject"];
        NSString * author = [reply objectForKey:@"author_id"];
        NSString * body = [reply objectForKey:@"body"];
        
        if(!body){
            //新发制定收件人的邮件，不是回复
            [m_textTitle setText:title];
        }else{
            //标题加Re:
            NSRange t_range = NSMakeRange(0, 4);
            if([title compare:@"Re: " options:NSCaseInsensitiveSearch range:t_range] == NSOrderedSame){
                [m_textTitle setText:title];
            }else{
                [m_textTitle setText:[NSString stringWithFormat:@"Re: %@", title]];
            }
            
            //处理引用
            NSString * bodyRef = [NSString stringWithFormat:@"\n【 在 %@ 的%@中提到: 】\n", author, mailmode?@"来信":@"大作"];
            NSMutableString *mstr = [[NSMutableString alloc] init];
            mstr = [NSMutableString stringWithString:body];
            int quot_line = 3;
            for(;quot_line > 0; quot_line --) {
                t_range = [mstr rangeOfString:@"\n"];
                if(t_range.location != NSNotFound){
                    t_range.length += t_range.location;
                    t_range.location = 0;
                    bodyRef = [bodyRef stringByAppendingFormat:@": %@", [mstr substringToIndex:t_range.length]];
                    [mstr deleteCharactersInRange:t_range];
                }else{
                    break;
                }
            }
            t_range = [mstr rangeOfString:@"\n"];
            if(t_range.location != NSNotFound){
                bodyRef = [bodyRef stringByAppendingString:@": ....................\n"];
            }
            
            [m_textCont setText:bodyRef];
        }
    }

    [m_textCont.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [m_textCont.layer setBorderWidth:1.0];
    [m_textCont.layer setCornerRadius:8.0];
    [m_textCont.layer setMasksToBounds:YES];
    m_textCont.delegate = self;
    
    waiting_for_mbselect = false;
    
    att0_fname = nil;
    
    image_att.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressImageAtt)];
    [image_att addGestureRecognizer:singleTap];
}

- (bool)scroll_enabled
{
    return false;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if(waiting_for_mbselect){
        NSString * new_boardid = apiGetMBSelect();
        
        if(new_boardid != nil){
            m_lBoardId = [new_boardid copy];
            m_lBoardName = apiGetMBSelectName();
            [text_mailrecv setText:(m_lBoardName==nil)?m_lBoardId:m_lBoardName];
        }
        waiting_for_mbselect = false;
    }
}

- (IBAction)pressItemBtBack:(id)sender {
    [self updateContent];
}

- (int)uploadAtt {
    if(att0_fname == nil){
        return 0;
    }
    
    int error;
    int ret = apiNetAddAttachment( apiGetUserdata_attpost_path(att0_fname) , &error);
    if(ret != 0){
        NSLog(@"add attachment error");
        NSString * errlog = @"添加附件出错";
        UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"错误" message:errlog delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [altview show];
        return -1;
    }
    
    return 0;
}

- (IBAction)pressBtSend:(id)sender {
    [self loadContent];
}

-(void)parseContent
{
    NSString * strTitle = m_textTitle.text;
    if(strTitle.length == 0){
        strTitle = @"无标题";
    }
    NSString * strCont = m_textCont.text;

    long article_id;
    
    if(mailmode){
        if(reply && !mail_from_article){
            if([self uploadAtt] != 0){
                return;
            }
            article_id = [net_smth net_ReplyMail:[(NSString *)[reply objectForKey:@"position"] intValue] :strTitle :strCont];
        }else{
            NSString * receiver;
            if(reply){
                receiver = [reply objectForKey:@"author_id"];
            }else{
                receiver = text_mailrecv.text;
            }
            if([receiver isEqualToString:@""]){
                return;
            }else{
                if([self uploadAtt] != 0){
                    return;
                }
                article_id = [net_smth net_PostMail:receiver :strTitle :strCont];
            }
        }
    }else{
        if(reply){
            if([self uploadAtt] != 0){
                return;
            }
            article_id = [net_smth net_ReplyArticle:m_lBoardId :[(NSString *)[reply objectForKey:@"id"] intValue] :strTitle :strCont];
        }else{
            if(m_lBoardId == nil || [m_lBoardId isEqualToString:@""]){
                UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"错误" message:[NSString stringWithFormat:@"请选择发表的版面."] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [altview show];
                return;
            }else{
                if([self uploadAtt] != 0){
                    return;
                }
                article_id = [net_smth net_PostArticle:m_lBoardId :strTitle :strCont];
            }
        }
    }

    if(net_smth->net_error == 0){
        m_bLoadRes = 1;
    }
    
}

-(void)updateContent
{
    [self removeAtt];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setContentInfo:(bool)to_mail :(NSString*)boardid :(NSString*)boardname :(NSDictionary *)reply_dict :(bool)_mail_from_article
{
    if(to_mail) {
        mailmode = true;
        mail_from_article = _mail_from_article;
        reply = [reply_dict mutableCopy];
    }else{
        mailmode = false;
        if(boardid == nil){
            m_lBoardId = nil;
        }else{
            m_lBoardId = [boardid copy];
        }
        if(boardname == nil) {
            m_lBoardName = nil;
        }else{
            m_lBoardName = [boardname copy];
        }
        reply = [reply_dict mutableCopy];
    }
}

- (IBAction)pressBtnMBSelect:(id)sender {
    waiting_for_mbselect = true;
    
    MBSelectViewController *artcontEditController = [UIViewController appGetView:@"MBSelectViewController"];

    [self presentViewController:artcontEditController animated:YES completion:nil];
}

- (void)removeAtt
{
    if(att0_fname != nil){
        //删除附件图片
        NSError *error = nil;
        NSString * path = apiGetUserdata_attpost_path(att0_fname);
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        att0_fname = nil;
    }
}

- (void)pressImageAtt {
    if(att0_fname != nil){
        //删除附件图片
        [self removeAtt];
        
        image_att.image = [UIImage imageNamed:@"camera.png"];
    }else{
        //菜单
        UIActionSheet * as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机", @"从相册获取", nil];
        [as showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0 || buttonIndex == 1){
        //相机
        UIImagePickerControllerSourceType sourceType;
        if(buttonIndex == 0){
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        if ([UIImagePickerController isSourceTypeAvailable:sourceType])
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            NSLog(@"无法打开相机");
        }
    }else{
        
    }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
#ifdef DEBUG
    NSLog(@"select one photo");
#endif
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]){
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data = apiConvertUploadPhoto(image);
        if(data == nil){
            NSLog(@"save image error");
            goto dismiss;
        }
        att0_fname = @"att0.jpg";
        
        //save to local
        NSString * localPath = apiGetUserdata_attpost_path(att0_fname);
        [data writeToFile:localPath atomically:NSAtomicWrite];
        
        //update preview
        image_att.image = image;

    }else{
        NSLog(@"not photo");
    }
    
dismiss:
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
    
    CGFloat overflow = line.origin.y + line.size.height - ( textView.contentOffset.y + textView.bounds.size.height- textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
            
        }];
    }
}

@end
