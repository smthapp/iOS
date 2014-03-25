//
//  InfoCenter.h
//  BBSAdmin
//
//  Created by HE BIAO on 14-1-7.
//  Copyright (c) 2014年 newsmth. All rights reserved.
//  Info Center writed by C language

#ifndef __INFOCENTER_H_
#define __INFOCENTER_H_

extern bool USE_MEMBER;
extern NSString * help_board;

#define SCROLL_REFRESH_TH 0.15f

#include "libSMTH/smth_netop.h"

NSData * apiConvertUploadPhoto(UIImage * image);

NSData * apiConvertUploadFace(UIImage * image);

//Member
NSString * apiGetMBSelect();
NSString * apiGetMBSelectName();
void apiSetMBSelect(NSString * board_id, NSString * board_name);

//APNS
/* ret: 0:updated. 1:not updated because same as previous 2:not updated because waiting for token/user -1:update fail, server error */
int apiUpdateAPNS(NSString * token);

//check net status
int apiCheckNetStatus();//-1:net disconnection 0:mobile net 1:wifi

@interface NSAppSetting : NSObject
{
@public
    int attachment_images_size; //0:middle, 1:large, 2:none, 3:small
    int upphoto_size; //0:middle, 1:large, 2:small
    int brcmode;
    
    int my_notify_number;
    NSString * my_dismiss_version;
    
    int font_size;
    
    int article_sort;
    
    int mail_unread;
    int at_unread;
    int reply_unread;

    int unread_apns_cnt; //notifications from apns. set when received notifications. clear after message_unread_check(). The tarbar badge should set to unread+apns_cnt.
    bool unread_is_updating; //不管任何时候，只有一个dispatch_async()在跑。
    
    int order_threadid; //0: order by articleid, 1: order by threadid

@private
    NSString * strUsr;
    NSString * strPwd;
    NSString *mStrAccessToken;
}

-(void)setLoginInfo:(NSString *)usr :(NSString *)pwd;
-(void)load_setting;

-(NSString *)getLoginInfoUsr;
-(NSString *)getLoginInfoPwd;

-(void)appSettingChange:(NSString *)name :(NSString *)value;

-(NSString*)apiGetAccessToken;
-(void)apiSetAccessToken:(NSString*)actoken;
@end

extern NSAppSetting * appSetting;
void apiAppSettingInit();

NSString * appGetDateString(NSTimeInterval time, NSTimeInterval cur_time);
NSString * appGetDateStringAfter(NSTimeInterval time, NSTimeInterval cur_time);

//UI update func
//void message_tabbar_update();
//void message_view_update();

void message_unread_check(bool force); //force==0: check only unread_apns_cnt > 0

#endif
