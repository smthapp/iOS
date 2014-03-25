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
#import "FriendListViewController.h"
#import "BoardListViewController.h"

static MessagesViewController * _g_message_view = nil;
static void message_view_update(){
    if(_g_message_view == nil){
        return;
    }
    [_g_message_view refresh];
}
void message_tabbar_update();

void message_unread_check(bool force)
{
    if(g_tabbar == nil){
        //not login, ignore
        return;
    }
    if(!force && appSetting->unread_apns_cnt == 0){
        return;
    }
    if(appSetting->unread_is_updating){
        return;
    }
    appSetting->unread_is_updating = true;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#ifdef DEBUG
        NSLog(@"real check unread");
#endif
        AppViewController * view_test = [[AppViewController alloc] init];
        [view_test init_without_UI];
            
        //load unread count
        [view_test update_unread];
        appSetting->unread_apns_cnt = 0;

        //set message view
        message_view_update();
        //set tabbar
        message_tabbar_update();

        appSetting->unread_is_updating = false;
    });
}

@interface MessagesViewController ()

@end

@implementation MessagesViewController
@synthesize m_tableView;
@synthesize navi;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    navi.title = [appSetting getLoginInfoUsr];
}

- (IBAction)pressBtnBack:(id)sender
{
    //no back
    return;
}

-(void)viewDidAppear:(BOOL)animated
{
    _g_message_view = self;

    message_unread_check(false);

    //clear APN in UI thread
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

-(void)viewWillAppear:(BOOL)animated
{
    _g_message_view = nil;
}

-(void)parseContent
{
    message_unread_check(true);
}

-(void)moreContent
{
    //disable more option
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"我的消息";
    }
    else
    {
        return @"我的关注";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 4;
    }else{
        return 3;
    }
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
    int unread = 0;
    NSString * icon_name = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    strName = @"回复我的文章";
                    unread = appSetting->reply_unread;
                    icon_name = @"refer_article.png";
                    break;
                case 1:
                    strName = @"@我的文章";
                    unread = appSetting->at_unread;
                    icon_name = @"refer_at.png";
                    break;
                case 2:
                    strName = @"邮件-收件箱";
                    unread = appSetting->mail_unread;
                    icon_name = @"email_inbox.png";
                    break;
                case 3:
                    strName = @"邮件-发件箱";
                    icon_name = @"email_sent.png";
                    break;
                default:
                    break;
            }
        }
        break;
        case 1:
        default:
        {
            switch (indexPath.row){
                case 0:
                    strName = @"我关注的好友";
                    icon_name = @"icon_contact.png";
                    break;
                case 1:
                    strName = @"我收藏的版面";
                    icon_name = @"icon_fav.png";
                    break;
                default:
                    strName = @"我关注的版面";
                    icon_name = @"icon_member.png";
                    break;
            }
        }
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

    [cell setContentInfo:strName :unread :(icon_name == nil ? nil : [UIImage imageNamed:icon_name])];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
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
    }else{
        switch (indexPath.row) {
            case 0:
                [self showFriendList];
                break;
            case 1:
                [self showFavBoard];
                break;
            default:
                [self showMemberBoardList];
                break;
        }
    }
    [m_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)showFavBoard
{
    BoardListViewController *brdlistViewController = [UIViewController appGetView:@"BoardListViewController"];
    
    [brdlistViewController setContentInfo:2 :nil];
    
    [self presentViewController:brdlistViewController animated:YES completion:nil];
    
}
-(void)showMemberBoardList
{
    BoardListViewController *brdlistViewController = [UIViewController appGetView:@"BoardListViewController"];
    
    [brdlistViewController setContentInfo:5 :nil];
    
    [self presentViewController:brdlistViewController animated:YES completion:nil];
}

-(void)showFriendList{
    FriendListViewController *friendlistViewController = [UIViewController appGetView:@"FriendListViewController"];

    [self presentViewController:friendlistViewController animated:YES completion:nil];
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
}

-(void)refresh
{
    [self performSelectorOnMainThread:@selector(updateContent) withObject:nil waitUntilDone:NO];
}

@end


