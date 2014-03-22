//
//  ArticleForwardViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/8/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "ArticleForwardViewController.h"

@interface ArticleForwardViewController ()

@end

@implementation ArticleForwardViewController
@synthesize text_user,label_title;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [label_title setText:[NSString stringWithFormat:@"标题: %@",[reply objectForKey:@"subject"]]];
}

- (IBAction)pressBtnSend:(id)sender {
    [self loadContent];
}

-(void)parseContent
{
    NSString * receiver = text_user.text;
    if([receiver isEqualToString:@""]){
        return;
    }
    
    if(src_is_article) {
        [net_smth net_ForwardArticle:m_lBoardId :[(NSString *)[reply objectForKey:@"id"] intValue] :receiver];
    }else{
        [net_smth net_ForwardMail:[(NSString *)[reply objectForKey:@"position"] intValue] :receiver];
    }
    
    if(net_smth->net_error == 0){
        m_bLoadRes = 1;
    }
}

-(void)updateContent
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(bool)scroll_enabled
{
    return false;
}

- (void)setContentInfo:(bool)from_article :(NSString*)boardid :(NSString*)boardname :(NSDictionary *)reply_dict
{
    reply = [reply_dict mutableCopy];
    src_is_article = from_article;
    if(from_article) {
        m_lBoardId = [boardid copy];
        m_lBoardName = [boardname copy];
    }
}

@end
