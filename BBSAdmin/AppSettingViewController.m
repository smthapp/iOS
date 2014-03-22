//
//  AppSettingViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 14-1-3.
//  Copyright (c) 2014年 newsmth. All rights reserved.
//

#import "AppSettingViewController.h"
#import "UIAttImageView.h"
#import "ParentTabBarViewController.h"
#import "ArticleContentEditController.h"
#import "UIViewController+AppGet.h"
#import "UserinfoViewController.h"
#import "UIViewController+AppGet.h"
#import "ArticleListViewController.h"
#import "FontSizeCell.h"

@interface AppSettingViewController ()

@end

@implementation AppSettingViewController
@synthesize m_tableView;
@synthesize m_strAppVer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //count cell width
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        m_nCellWidth = [UIScreen mainScreen].bounds.size.width;
        m_nCellHeightCenter = 6;
    }
    else
    {
        m_nCellWidth = [UIScreen mainScreen].bounds.size.height;
        m_nCellHeightCenter = 10;
    }

    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    m_strAppVer = [infoDic objectForKey:@"CFBundleVersion"];
}

-(bool)scroll_enabled
{
    return false;
}

-(void)pressBtnBack:(id)sender
{
    return;
}

#pragma mark - UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else if(section == 1)
    {
        return 6;
    }
    else
    {
        if(help_board){
            return 3;
        }else{
            return 2;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        if(indexPath.section == 1 && indexPath.row == 4){
            return 72.0f;
        }
        return 49.0f;
    }else{
        if(indexPath.section == 1 && indexPath.row == 4){
            return 72.0f;
        }
        return 40.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 4){
        static NSString *cellId;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            cellId = @"FontSizeCell_iPad";
        else
            cellId = @"FontSizeCell_iPhone";
        FontSizeCell *cell = (FontSizeCell*)[self.m_tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
            cell = (FontSizeCell*)[nibArray objectAtIndex:0];
        }
        
        //clear cell
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell loadFontSize];
        return cell;
    }
    
    NSString *cellId = [NSString stringWithFormat:@"AppSettingCell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    UISwitch *swhBt = [[UISwitch alloc]initWithFrame:CGRectMake(m_nCellWidth-80, m_nCellHeightCenter, 79, 27)];
    [swhBt addTarget:self action:@selector(switchSettingAction:) forControlEvents:UIControlEventValueChanged];
    
    //clear cell
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    
    //set cell
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"账户";
                cell.detailTextLabel.text = [appSetting getLoginInfoUsr];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.textLabel.text = @"注销";
                cell.accessoryType = UITableViewCellAccessoryNone;
                break;
            default:
                break;
        }
    }
    else if(indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 3:
                cell.textLabel.text = @"进版面";
                if(appSetting->brcmode == 0){
                    cell.detailTextLabel.text = @"清除所有文章未读";
                }else if(appSetting->brcmode == 1){
                    cell.detailTextLabel.text = @"清最后一文未读";
                }else{
                    cell.detailTextLabel.text = @"不清未读";
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;

            case 0:
                cell.textLabel.text = @"显示图片";
                if(appSetting->attachment_images_size == 0){
                    cell.detailTextLabel.text = @"中";
                }else if(appSetting->attachment_images_size == 1){
                    cell.detailTextLabel.text = @"大";
                }else if(appSetting->attachment_images_size == 2){
                    cell.detailTextLabel.text = @"无";
                }else{
                    cell.detailTextLabel.text = @"小";
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.textLabel.text = @"清除图片缓存";
                break;
            case 2:
                cell.textLabel.text = @"上传图片尺寸";
                if(appSetting->upphoto_size == 0){
                    cell.detailTextLabel.text = @"中";
                }else if(appSetting->upphoto_size == 1){
                    cell.detailTextLabel.text = @"大";
                }else{
                    cell.detailTextLabel.text = @"小";
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 5:
                cell.textLabel.text = @"文章回复显示次序";
                if(appSetting->article_sort == 0){
                    cell.detailTextLabel.text = @"逆序";
                }else{
                    cell.detailTextLabel.text = @"正序";
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 2:
                cell.textLabel.text = @"帮助";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.textLabel.text = @"应用反馈";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 0:
                cell.textLabel.text = @"关于";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"登陆信息";
    }
    else if(section == 1)
    {
        return @"阅读设置";
    }
    else
    {
        return @"应用信息";
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
                [self showUserInfo];
                break;
            case 1:
                action = 1;
                [self loadContent];
                break;
            default:
                break;
        }
    }
    else if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                appSetting->attachment_images_size ++;
                if(appSetting->attachment_images_size > 3){
                    appSetting->attachment_images_size = 0;
                }
                NSString * str = [NSString stringWithFormat:@"%d", appSetting->attachment_images_size];
                [appSetting appSettingChange:@"attachment_images_size" :str];
                [m_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
            case 1:
            {
                [UIAttImageView imageClearAttCache];
                UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"已经清空图片缓存"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [altview show];
                break;
            }
            case 2:
            {
                appSetting->upphoto_size ++;
                if(appSetting->upphoto_size > 2){
                    appSetting->upphoto_size = 0;
                }
                NSString * str = [NSString stringWithFormat:@"%d", appSetting->upphoto_size];
                [appSetting appSettingChange:@"upphoto_size" :str];
                [m_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
            case 3:
            {
                appSetting->brcmode ++;
                if(appSetting->brcmode > 2){
                    appSetting->brcmode = 0;
                }
                NSString * str = [NSString stringWithFormat:@"%d", appSetting->brcmode];
                [appSetting appSettingChange:@"brcmode" :str];
                [m_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
            case 5:
            {
                appSetting->article_sort ++;
                if(appSetting->article_sort > 1){
                    appSetting->article_sort = 0;
                }
                NSString * str = [NSString stringWithFormat:@"%d", appSetting->article_sort];
                [appSetting appSettingChange:@"article_sort" :str];
                [m_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 1:
                [self sendFeedback];
                break;
            case 0:
                [self showAbout];
                break;
            case 2:
                [self showHelp];
                break;
            default:
                break;
        }
    }
}

-(void)switchSettingAction:(UISwitch *)sender;
{
    
}

-(void)showHelp
{
    if(help_board){
        ArticleListViewController *artlistViewController = [UIViewController appGetView:@"ArtListViewController"];
        
        [artlistViewController setBoardArticleMode:help_board :nil];
        
        [self presentViewController:artlistViewController animated:YES completion:nil];
    }
}

-(void)showUserInfo
{
    UserinfoViewController *userinfoViewController = [UIViewController appGetView:@"UserinfoViewController"];
    
    [userinfoViewController setContentInfo:[appSetting getLoginInfoUsr]];
    [self presentViewController:userinfoViewController animated:YES completion:nil];
}

-(void)logoutAccount
{
    [net_smth net_LogoutBBS];
    
    g_tabbar = nil;
}

-(void)parseContent
{
    if(action == 1){
        m_bLoadRes = 1;
        [self logoutAccount];
    }
}

-(void)updateContent
{
    if(action == 1){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)showAbout
{
    NSDictionary *dict_cur = [[NSBundle mainBundle] infoDictionary];
    NSString * appVer = [dict_cur objectForKey:@"CFBundleVersion"];
    
    NSString * msg = [NSString stringWithFormat:@"水木社区官方APP %@\n\n网址: http://www.newsmth.net\nBugReport:站内发信给SYSOP", appVer];
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"水木社区欢迎您" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
}

-(void)sendFeedback
{
    ArticleContentEditController *artcontEditController = [UIViewController appGetView:@"ArtContEditController"];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"iOS应用反馈", @"subject", @"SYSOP", @"author_id", nil];
    [artcontEditController setContentInfo:true :nil :nil :dict :true];
    
    [self presentViewController:artcontEditController animated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 80301)
    {
        if (buttonIndex != [alertView cancelButtonIndex])
        {
            NSString *strURLDownload = @"https://itunes.apple.com/app/id610175169?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURLDownload]];
        }
    }
}

@end
