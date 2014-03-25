#ifndef _USERDATA_H_
#define _USERDATA_H_

//userdata

//BRC
//for normal board, last_art_id the latest article ID read.
//for "___" board, timeline mode, is the latest time updated.
long long int apiGetUserData_BRC(NSString * board_id);
int apiSetUserData_BRC(NSString * board_id, long long int last_art_id);
//Member Boards List
NSMutableArray * apiGetUserData_MBList();
int apiSetUserData_MBList(NSMutableArray * mblist);

//post att
NSString * apiGetUserdata_attpost_path(NSString * fname);

//friends
int apiSetUserData_friends(NSMutableDictionary * friends);
int apiSetUserData_add_friend(NSString * userid);
int apiSetUserData_del_friend(NSString * userid);
NSMutableDictionary * apiGetUserData_friends();
int apiGetUserData_is_friends(NSString * userid);

//board history
int apiSetUserData_add_bhis(NSDictionary * brd);
NSMutableArray * apiGetUserData_bhis();

//config
int apiSetUserData_config(NSString * key, NSString * value);
NSString * apiGetUserData_config(NSString * key);

#endif