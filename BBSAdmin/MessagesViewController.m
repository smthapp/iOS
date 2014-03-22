//
//  MessagesViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 1/24/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "MessagesViewController.h"
#import "ParentTabBarViewController.h"
#import "UIViewController+AppGet.h"

@interface MessagesViewController ()

@end

@implementation MessagesViewController
@synthesize m_tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    reply_count = 0;
    reply_unread = 0;
    
    [self loadContent];
}

- (IBAction)pressBtnBack:(id)sender
{
    //no back
    return;
}

-(void)parseContent
{
    m_bLoadRes = 1;
    net_ops = 3;
    
    NSDictionary * dict = [net_smth net_GetReferCount:2];
    if(dict) {
        reply_count = [(NSString*)[dict objectForKey:@"total_count"] intValue];
        reply_unread = [(NSString*)[dict objectForKey:@"new_count"] intValue];
    }
    dict = [net_smth net_GetReferCount:1];
    if(dict) {
        at_count = [(NSString*)[dict objectForKey:@"total_count"] intValue];
        at_unread = [(NSString*)[dict objectForKey:@"new_count"] intValue];
    }

    dict = [net_smth net_GetMailCount];
    if(dict) {
        mail_count = [(NSString*)[dict objectForKey:@"total_count"] intValue];
        mail_unread = [(NSString*)[dict objectForKey:@"new_count"] intValue];
        mail_isfull = [(NSString *)[dict objectForKey:@"is_full"] intValue];
    }
    mail_count_send = -1;
}

-(void)moreContent
{
    //disable more option
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return 64.0f;
    else
        return 54.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strName = @"";
    switch (indexPath.row) {
        case 0:
            strName = @"回复我的文章";
            break;
        case 1:
            strName = @"@我的文章";
            break;
        case 2:
            strName = @"邮件-收件箱";
            break;
        case 3:
            strName = @"邮件-发件箱";
            break;
        default:
            break;
    }
    
    static NSString *root_cellId;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        root_cellId = @"MessageInfoCell_iPad";
    else
        root_cellId = @"MessageInfoCell_iPhone";
    MessageInfoCell *cell = (MessageInfoCell*)[self.m_tableView dequeueReusableCellWithIdentifier:root_cellId];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:root_cellId owner:self options:nil];
        cell = (MessageInfoCell*)[nibArray objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];

    switch (indexPath.row) {
        case 0:
            [cell setContentInfo:strName :reply_count :reply_unread :[UIImage imageNamed:@"refer_article.png"]];
            break;
        case 1:
            [cell setContentInfo:strName :at_count :at_unread :[UIImage imageNamed:@"refer_at.png"]];
            break;
        case 2:
            [cell setContentInfo:strName :mail_count :mail_unread :[UIImage imageNamed:@"email_inbox.png"]];
            break;
        case 3:
            [cell setContentInfo:strName :mail_count_send :0 :[UIImage imageNamed:@"email_sent.png"]];
            break;
        default:
            [cell setContentInfo:strName :0 :0 :nil];
            break;
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self showReferList:2];
            break;
        case 1:
            [self showReferList:1];
            break;
        case 2:
            [self showReferList:10];
            break;
        case 3:
            [self showReferList:11];
            break;
        default:
            break;
    }
    
}

-(void)showReferList:(int)refermode
{
    ArticleListViewController *artlistViewController = [UIViewController appGetView:@"ArtListViewController"];
    
    if(refermode == 10){
        [artlistViewController setMailmode:0];
    }else if(refermode == 11){
        [artlistViewController setMailmode:1];
    }else{
        [artlistViewController setRefermode:refermode];
    }
    
    [self presentViewController:artlistViewController animated:YES completion:nil];
}

-(void)updateContent
{
    [m_tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [m_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //clear APN in UI thread
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    tabbar_message_set_notify(0);
    tabbar_message_check_notify();
}

@end
