//
//  UserinfoViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/26/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "UserinfoViewController.h"
#import "UserinfoHeadCell.h"
#import "UserData.h"
#import "ArticleContentEditController.h"
#import "UIViewController+AppGet.h"

@interface UserinfoViewController ()

@end

@implementation UserinfoViewController
@synthesize m_tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    parse_mode = 0;
    [self loadContent];

}

-(void)parseContent
{
    if(parse_mode == 0){
        userinfo = [net_smth net_QueryUser:userid];
        if(userinfo && net_smth->net_error == 0){
            m_bLoadRes = 1;
        }
    }else if(parse_mode == 1){
        [net_smth net_AddUserFriend:userid];
        if(net_smth->net_error == 0){
            is_friend = YES;
            apiSetUserData_add_friend(userid);
            m_bLoadRes = 1;
        }
    }else if(parse_mode == 2){
        [net_smth net_DelUserFriend:userid];
        if(net_smth->net_error == 0){
            is_friend = NO;
            apiSetUserData_del_friend(userid);
            m_bLoadRes = 1;
        }
    }else if(parse_mode == 3){
        if(face_fname != nil){
            NSDictionary * new_userinfo = [net_smth net_modifyFace:apiGetUserdata_attpost_path(face_fname)];
            
            if(new_userinfo && net_smth->net_error == 0){
                userinfo = new_userinfo;
                m_bLoadRes = 1;
            }
            //remove local file
            NSError *error = nil;
            NSString * path = apiGetUserdata_attpost_path(face_fname);
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            face_fname = nil;
        }
    }
    
    parse_mode = 0;
}

- (void)setContentInfo:(NSString *)_userid
{
    userid = [_userid copy];
    if(apiGetUserData_is_friends(userid)){
        is_friend = YES;
    }else{
        is_friend = NO;
    }

}

#pragma mark - UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 7;
    }else{
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"用户信息";
    }
    else
    {
        return @"操作";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        if(indexPath.section == 0 && indexPath.row == 0){
            return 240.0f;
        }else if(indexPath.section == 0){
            return 40.0f;
        }else{
            return 54.0f;
        }
    }else{
        if(indexPath.section == 0 && indexPath.row == 0){
            return 120.0f;
        }else if(indexPath.section == 0){
            return 30.0f;
        }else{
            return 40.0f;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0){
        //picture
        static NSString *cellId;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            cellId = @"UserinfoHeadCell_iPad";
        else
            cellId = @"UserinfoHeadCell_iPhone";
        UserinfoHeadCell *cell = (UserinfoHeadCell*)[self.m_tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
            cell = (UserinfoHeadCell*)[nibArray objectAtIndex:0];
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        
        if(userinfo){
            [cell setContentInfo:[userinfo objectForKey:@"id"] :[userinfo objectForKey:@"title"] :[userinfo objectForKey:@"faceurl"] :[[userinfo objectForKey:@"gender"] intValue] :self];
        }
        
        return cell;
        
    }else{
        NSString *cellId = [NSString stringWithFormat:@"UserinfoCell%ld_%ld", (long)indexPath.section, (long)[indexPath row]];
        UITableViewCell *cell = [m_tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        }
        
        //set cell
        [cell setBackgroundColor:[UIColor clearColor]];

        if(userinfo == nil) {
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
        }else{
            if(indexPath.section == 0){
                switch (indexPath.row) {
                    case 1:
                        cell.textLabel.text = @"昵称";
                        cell.detailTextLabel.text = [userinfo objectForKey:@"nick"];
                        break;
                    case 2:
                        cell.textLabel.text = @"等级";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%d)",[userinfo objectForKey:@"life"], [(NSString *)[userinfo objectForKey:@"level"] intValue] ];
                        break;
                    case 3:
                        cell.textLabel.text = @"登录数";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [(NSString *)[userinfo objectForKey:@"logins"] intValue]];
                        break;
                    case 4:
                        cell.textLabel.text = @"发文数";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [(NSString *)[userinfo objectForKey:@"posts"] intValue]];
                        break;
                    case 5:
                        cell.textLabel.text = @"积分";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [(NSString *)[userinfo objectForKey:@"score"] intValue]];
                        break;
                    case 6:
                    {
                        cell.textLabel.text = @"最近登录";
                        NSDate * date = [NSDate dateWithTimeIntervalSince1970:( [[userinfo objectForKey:@"last_login"] longLongValue]) ];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *dateStr = [dateFormatter stringFromDate:date];
                        
                        cell.detailTextLabel.text = dateStr;
                        break;
                    }
                    default:
                        cell.textLabel.text = @"";
                        cell.detailTextLabel.text = @"";
                        break;
                }
            }else{
                //section 1
                cell.detailTextLabel.text = @"";
                
                switch (indexPath.row) {
                    case 0:
                        if(is_friend){
                            cell.textLabel.text = @"取消好友";
                        }else{
                            cell.textLabel.text = @"加为好友";
                        }
                        break;
                    case 1:
                        cell.textLabel.text = @"发送邮件";
                        break;
                    default:
                        cell.textLabel.text = @"";
                        break;
                }
                        
            }
        }
        
        return cell;
    }
}

- (void)moreContent
{
    //disable more option
}

- (bool)scroll_enabled
{
    return false;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                if(is_friend){
                    NSString * notify_msg = [NSString stringWithFormat:@"确定取消关注%@?",userid];
                    UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"" message:notify_msg delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"取消关注", nil];
                    [altview show];
                }else{
                    parse_mode = 1;
                    [self loadContent];
                }
                break;
            case 1:
                [self send_mail];
                break;
            default:
                break;
        }
    }
}


- (void)updateContent
{
    [m_tableView reloadData];
}

-(void)send_mail
{
    ArticleContentEditController *artcontEditController = [UIViewController appGetView:@"ArtContEditController"];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"subject", userid, @"author_id", nil];
    [artcontEditController setContentInfo:true :nil :nil :dict :true];
    
    [self presentViewController:artcontEditController animated:YES completion:nil];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        //cancel:
    }else{
        parse_mode = 2;
        [self loadContent];
    }
}

- (void)edit_face
{
    UIActionSheet * as = [[UIActionSheet alloc] initWithTitle:@"更改个人头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机", @"从相册获取", nil];
    [as showInView:self.view];
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
            picker.allowsEditing = YES;
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

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]){
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data = apiConvertUploadFace(image);
        if(data == nil){
            NSLog(@"save image error");
            goto error;
        }
        face_fname = @"face.jpg";
        
        //save to local
        NSString * localPath = apiGetUserdata_attpost_path(face_fname);
        [data writeToFile:localPath atomically:NSAtomicWrite];
        
        //upload
        parse_mode = 3;
        [self loadContent];
        
        return;
    }else{
        NSLog(@"not photo");
    }

error:
    {
        NSString * notify_msg = @"照片处理出错";
        UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"错误" message:notify_msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [altview show];
    }
    
    return;
}

@end
