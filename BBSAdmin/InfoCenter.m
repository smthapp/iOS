//
//  InfoCenter.m
//  BBSAdmin
//
//  Created by HE BIAO on 14-1-7.
//  Copyright (c) 2014年 newsmth. All rights reserved.
//

#import "InfoCenter.h"
#import "Reachability.h"


#pragma mark - login information

bool USE_MEMBER = false;
NSString * help_board = nil;


static UIImage * _resizeUploadPhoto(UIImage * image)
{
    CGFloat width;
    switch(appSetting->upphoto_size){
        case 0:
            width = 240;
            break;
        case 2:
            width = 120;
            break;
        default:
            width = 1280;
            break;
    }
    
    CGFloat cur_width = image.size.width;
    
    if(cur_width <= width || cur_width == 0){
        return image;
    }
    
    UIImage * newImage = nil;
    
    CGFloat new_height = image.size.height * width / cur_width ;
    CGSize targetSize = CGSizeMake(width, new_height);
    
    UIGraphicsBeginImageContext(targetSize);
    
    [image drawInRect:CGRectMake(0, 0, width, new_height)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

NSData * apiConvertUploadPhoto(UIImage * image)
{
    UIImage * newImage = _resizeUploadPhoto(image);
    
    CGFloat qs = 1.0f;
    NSData * data = UIImageJPEGRepresentation(newImage, 1.0);
    
    CGFloat max_size = 1.0 * 1024 * 1024;
    int cur_size = (int)[data length];
    
    while(cur_size > max_size && qs > 0.1f){
        qs -= 0.1f;
        data = UIImageJPEGRepresentation(newImage, qs);
        cur_size = (int)[data length];
#ifdef DEBUG
        NSLog(@"qs:%f, size:%d", qs, cur_size);
#endif
    }
    
#ifdef DEBUG
    NSLog(@"photo size:%d", cur_size);
#endif
    return data;
}

static UIImage * _resizeUploadFace(UIImage * image)
{
    CGFloat width = 120;
    CGFloat new_height = 120 ;
    
    CGFloat cur_width = image.size.width;
    
    if(cur_width <= width || cur_width == 0){
        return image;
    }
    
    UIImage * newImage = nil;
    
    CGSize targetSize = CGSizeMake(width, new_height);
    
    UIGraphicsBeginImageContext(targetSize);
    
    [image drawInRect:CGRectMake(0, 0, width, new_height)];

    newImage = UIGraphicsGetImageFromCurrentImageContext();

    return newImage;
}

NSData * apiConvertUploadFace(UIImage * image)
{
    UIImage * newImage = _resizeUploadFace(image);
    
    CGFloat qs = 1.0f;
    NSData * data = UIImageJPEGRepresentation(newImage, 1.0);
    
    CGFloat max_size = 50 * 1024;
    int cur_size = (int)[data length];
    
    while(cur_size > max_size && qs > 0.1f){
        qs -= 0.1f;
        data = UIImageJPEGRepresentation(newImage, qs);
        cur_size = (int)[data length];
#ifdef DEBUG
        NSLog(@"qs:%f, size:%d", qs, cur_size);
#endif
    }
    
#ifdef DEBUG
    NSLog(@"face size:%d", cur_size);
#endif
    return data;
}


static NSString * _mb_select_id = nil;
static NSString * _mb_select_name = nil;

void apiSetMBSelect(NSString * board_id, NSString * board_name)
{
    if(board_id == nil){
        _mb_select_id = nil;
    }else{
        _mb_select_id = [board_id copy];
    }
    
    if(board_name == nil){
        _mb_select_name = nil;
    }else{
        _mb_select_name = [board_name copy];
    }
}
    
NSString * apiGetMBSelect()
{
    return _mb_select_id;
}
    
NSString * apiGetMBSelectName()
{
    return _mb_select_name;
}



//APNs

static bool _apns_token_ready = false;
static bool _apns_user_ready = false;
static NSString * _apns_user;
static NSString * _apns_token;

int apiUpdateAPNS(NSString * token)
{
    NSString * app_id = [[NSBundle mainBundle] bundleIdentifier];
    NSLog(@"bundle %@", app_id);
    if(![app_id isEqualToString:@"net.newsmth.SMTH"]){
        return 2;
    }
    
    if(token == nil){
        //username is valid
        _apns_user = [[appSetting getLoginInfoUsr] copy];
        _apns_user_ready = true;
    }else{
        _apns_token = [token copy];
        _apns_token_ready = true;
        
        NSLog(@"APNs string: %@", _apns_token);
    }
    
    if(_apns_token_ready && _apns_user_ready){
        //check if it's the same as previous setting
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        
#ifndef DEBUG
        NSString * str_prev_token = [defaults objectForKey:@"apns_token"];
        NSString * str_prev_user = [defaults objectForKey:@"apns_user"];

        if(str_prev_user != nil && [str_prev_user isEqualToString:_apns_user] && str_prev_token != nil && [str_prev_token isEqualToString:_apns_token]){
            NSLog(@"token same, skip");
            return 1;
        }
#endif
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#ifdef DEBUG
            NSString * strProfile = @"dev";
#else
            NSString * strProfile = @"dist";
#endif
            if(apiNetRegAPNS(_apns_user, _apns_token, strProfile) == 0){
                //OK
                NSLog(@"save apns info");
                [defaults setObject:_apns_user forKey:@"apns_user"];
                [defaults setObject:_apns_token forKey:@"apns_token"];
                [defaults synchronize];
            }
        });
        
        return 0;
        
        /*
        //update server
        if(apiNetRegAPNS(_apns_user, _apns_token) == 0){
            //OK
            NSLog(@"save apns info");
            [defaults setObject:_apns_user forKey:@"apns_user"];
            [defaults setObject:_apns_token forKey:@"apns_token"];
            [defaults synchronize];
            
            return 0;
        }else{
            return -1;
        }
         */
    }

    return 2;
}


#pragma mark - check net status
int apiCheckNetStatus()
{
    Reachability *reachNet = [Reachability reachabilityWithHostName:@"www.apple.com"];//www.newsmth.net
    int retNetStatus = -1;
    switch ([reachNet currentReachabilityStatus]) {
        case NotReachable:
            retNetStatus = -1;
            break;
        case ReachableViaWWAN:
            retNetStatus = 0;
            break;
        case ReachableViaWiFi:
            retNetStatus = 1;
            break;            
        default:
            break;
    }
    
    return retNetStatus;
}

@implementation NSAppSetting

-(void)apiSetAccessToken:(NSString*)actoken
{
    mStrAccessToken = [actoken copy];
}

-(NSString*)apiGetAccessToken
{
    return mStrAccessToken;
}

-(void)setLoginInfo:(NSString *)usr :(NSString *)pwd
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:usr forKey:@"username"];
    [defaults setObject:pwd forKey:@"password"];
    [defaults synchronize];
    
    [self load_setting];
}

-(void)load_setting
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    attachment_images_size = [[defaults objectForKey:@"attachment_images_size"] intValue];
    upphoto_size = [[defaults objectForKey:@"upphoto_size"] intValue];
    brcmode = [[defaults objectForKey:@"brcmode"] intValue];
    
    strUsr = [defaults objectForKey:@"username"];
    strPwd = [defaults objectForKey:@"password"];

    my_notify_number = [(NSString *)[defaults objectForKey:@"my_notify_number"] intValue];
    my_dismiss_version = [defaults objectForKey:@"dismiss_version"];
    
    font_size = [(NSString *)[defaults objectForKey:@"font_size"] intValue];
    if(font_size < 8 || font_size > 32){
        font_size = 16;
    }
    
    article_sort = [(NSString *)[defaults objectForKey:@"article_sort"] intValue];
    
    order_threadid = [(NSString *)[defaults objectForKey:@"order_threadid"] intValue];
}

-(NSString *)getLoginInfoUsr
{
    return strUsr;
}

-(NSString *)getLoginInfoPwd
{
    return strPwd;
}

-(void)appSettingChange:(NSString *)name :(NSString *)value
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:name];
    [defaults synchronize];
    
    [self load_setting];
}
@end

NSAppSetting * appSetting = nil;

void apiAppSettingInit()
{
    if(appSetting == nil){
        appSetting = [[NSAppSetting alloc] init];
    }
    
    [appSetting load_setting];
}

NSString * appGetDateString_internal(NSTimeInterval time, NSTimeInterval cur_time, int after)
{
    if(cur_time == 0){
        cur_time = [[NSDate date] timeIntervalSince1970];
    }

    long long int ts = (long long int)time;
    long long int c_ts = (long long int)cur_time;
    
    if(after){
        if(ts <= c_ts){
            return @"现在";
        }
    }else{
        if(ts >= c_ts){
            return @"现在";
        }
    }
    if(ts == 0){
        return @"";
    }
    long long int d;
    NSString * post;
    if(after){
        d = ts - c_ts;
        post = @"后";
    }else{
        d = c_ts - ts;
        post = @"前";
    }
    
    if(d < 60){
        return [NSString stringWithFormat:@"%lld秒%@", d, post];
    }
    d /= 60;
    if(d < 60){
        return [NSString stringWithFormat:@"%lld分钟%@", d, post];
    }
    d /= 60;
    if(d < 24){
        return [NSString stringWithFormat:@"%lld小时%@", d, post];
    }
    d /= 24; //天数
    if(d < 7){
        return [NSString stringWithFormat:@"%lld天%@", d, post];
    }
    if(d < 30){
        return [NSString stringWithFormat:@"%lld周%@", d/7, post];
    }
    if(d < 365){
        return [NSString stringWithFormat:@"%lld月%@", d/30, post];
    }
    d /= 365;
    return [NSString stringWithFormat:@"%lld年%@", d, post];
}


NSString * appGetDateString(NSTimeInterval time, NSTimeInterval cur_time)
{
    return appGetDateString_internal(time, cur_time, 0);
}

NSString * appGetDateStringAfter(NSTimeInterval time, NSTimeInterval cur_time)
{
    return appGetDateString_internal(time, cur_time, 1);
}


