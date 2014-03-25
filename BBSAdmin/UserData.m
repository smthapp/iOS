#import <UIKit/UIKit.h>
#import "UserData.h"
#import "InfoCenter.h"

static NSMutableDictionary * userdata_brc_dict = nil;
static NSString * userdata_brc_userid;

static NSString * userdata_get_path(NSString * userid){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserData"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
    
    NSString *localUserPath = [diskCachePath stringByAppendingPathComponent:userid];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:localUserPath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:localUserPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
    
    return localUserPath;
}

static NSString * userdata_brc_get_fname(NSString * userid){
    NSString *localUserPath = userdata_get_path(userid);
    
    return [localUserPath stringByAppendingPathComponent:@"brc"];
}

static void userdata_load_brc(NSString * userid)
{
    if(userdata_brc_dict && [userid isEqualToString:userdata_brc_userid]){
        return;
    }
    
    userdata_brc_dict = nil;
    
    NSString * fname = userdata_brc_get_fname(userid);
#ifdef DEBUG
    NSLog(@"init brc:%@", fname);
#endif
    
    userdata_brc_dict = [NSMutableDictionary dictionaryWithContentsOfFile:fname];
    userdata_brc_userid = [userid copy];
}

long long int apiGetUserData_BRC(NSString * board_id)
{
    userdata_load_brc([appSetting getLoginInfoUsr]);
    
    if(userdata_brc_dict == nil){
        return 0;
    }
    
    long long int ts = [(NSString *)[userdata_brc_dict objectForKey:board_id] longLongValue];
#ifdef DEBUG
    //NSLog(@"ts:%lld", ts);
#endif
    return ts;
}

int apiSetUserData_BRC(NSString * board_id, long long int last_art_id)
{
    userdata_load_brc([appSetting getLoginInfoUsr]);
    
    if(userdata_brc_dict == nil) {
        userdata_brc_dict = [[NSMutableDictionary alloc] init];
    }
    
    [userdata_brc_dict setObject:[NSString stringWithFormat:@"%lld", last_art_id] forKey:board_id];
    
    NSString * fname = userdata_brc_get_fname([appSetting getLoginInfoUsr]);
    [userdata_brc_dict writeToFile:fname atomically:YES];
    
    return 0;
}


//mblist

static NSMutableArray * userdata_mblist = nil;
static NSString * userdata_mblist_userid;

static NSString * userdata_mblist_get_fname(NSString * userid){
    NSString *localUserPath = userdata_get_path(userid);
    
    return [localUserPath stringByAppendingPathComponent:@"mblist"];
}

static void userdata_load_mblist(NSString * userid)
{
    if(userdata_mblist && [userid isEqualToString:userdata_mblist_userid]){
        return;
    }
    
    userdata_mblist = nil;
    
    NSString * fname = userdata_mblist_get_fname(userid);
#ifdef DEBUG
    NSLog(@"init mbist:%@", fname);
#endif
    
    userdata_mblist = [NSMutableArray arrayWithContentsOfFile:fname];
    userdata_mblist_userid = [userid copy];
}

NSMutableArray * apiGetUserData_MBList()
{
    userdata_load_mblist([appSetting getLoginInfoUsr]);
    
    return userdata_mblist;
}

int apiSetUserData_MBList(NSMutableArray * mblist)
{
    NSString * fname = userdata_mblist_get_fname([appSetting getLoginInfoUsr]);
    [mblist writeToFile:fname atomically:YES];

    userdata_mblist = nil;
    
    userdata_load_mblist([appSetting getLoginInfoUsr]);

    return 0;
}


NSString * apiGetUserdata_attpost_path(NSString * fname){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"PostAtt"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }

    return [diskCachePath stringByAppendingPathComponent:fname];
}

/******* friends *******/
static NSMutableDictionary * userdata_friends = nil;
static NSString * userdata_friends_userid;

static NSString * userdata_friends_get_fname(NSString * userid){
    NSString *localUserPath = userdata_get_path(userid);
    
    return [localUserPath stringByAppendingPathComponent:@"friends"];
}

static void userdata_load_friends(NSString * userid)
{
    if(userdata_friends && [userid isEqualToString:userdata_friends_userid]){
        return;
    }
    
    userdata_friends = nil;
    
    NSString * fname = userdata_friends_get_fname(userid);
#ifdef DEBUG
    NSLog(@"init friends:%@", fname);
#endif
    
    userdata_friends = [NSMutableDictionary dictionaryWithContentsOfFile:fname];
    userdata_friends_userid = [userid copy];
}

NSMutableDictionary * apiGetUserData_friends()
{
    userdata_load_friends([appSetting getLoginInfoUsr]);
    
    return userdata_friends;
}

int apiSetUserData_friends(NSMutableDictionary * friends)
{
    NSString * fname = userdata_friends_get_fname([appSetting getLoginInfoUsr]);
    [friends writeToFile:fname atomically:YES];
    
    userdata_friends = nil;
    
    userdata_load_friends([appSetting getLoginInfoUsr]);
    
    return 0;
}

int apiSetUserData_add_friend(NSString * userid)
{
    userdata_load_friends([appSetting getLoginInfoUsr]);
    
    [userdata_friends setObject:userid forKey:userid];
    
    apiSetUserData_friends(userdata_friends);
    
    return 0;
}

int apiSetUserData_del_friend(NSString * userid)
{
    userdata_load_friends([appSetting getLoginInfoUsr]);
    
    [userdata_friends removeObjectForKey:userid];
                                        
    apiSetUserData_friends(userdata_friends);
    
    return 0;
}

int apiGetUserData_is_friends(NSString * userid)
{
    userdata_load_friends([appSetting getLoginInfoUsr]);

    if(userdata_friends == nil){
        return 0;
    }
    
    if([userdata_friends objectForKey:userid] != nil){
        return 1;
    }
    return 0;
}

/**** board history *****/
static NSMutableArray * userdata_bhis = nil;
static NSString * userdata_bhis_userid;

static NSString * userdata_bhis_get_fname(NSString * userid){
    NSString *localUserPath = userdata_get_path(userid);
    
    return [localUserPath stringByAppendingPathComponent:@"bhistory"];
}

static void userdata_load_bhis(NSString * userid)
{
    if(userdata_bhis && [userid isEqualToString:userdata_bhis_userid]){
        return;
    }
    
    userdata_bhis = nil;
    
    NSString * fname = userdata_bhis_get_fname(userid);
#ifdef DEBUG
    NSLog(@"init bhis:%@", fname);
#endif
    
    userdata_bhis = [NSMutableArray arrayWithContentsOfFile:fname];
    if(userdata_bhis == nil){
        userdata_bhis = [[NSMutableArray alloc] init];
    }
    userdata_bhis_userid = [userid copy];
}

NSMutableArray * apiGetUserData_bhis()
{
    userdata_load_bhis([appSetting getLoginInfoUsr]);
    
    return userdata_bhis;
}

static int apiSetUserData_bhis(NSMutableArray * bhis)
{
    NSString * fname = userdata_bhis_get_fname([appSetting getLoginInfoUsr]);
    [bhis writeToFile:fname atomically:YES];
    
    userdata_bhis = nil;
    
    userdata_load_bhis([appSetting getLoginInfoUsr]);
    
    return 0;
}

#define MAX_BHIS 30
int apiSetUserData_add_bhis(NSDictionary * brd)
{
    userdata_load_bhis([appSetting getLoginInfoUsr]);
    
    int i;
    for(i=0; i < [userdata_bhis count]; i++){
        NSDictionary * a = [userdata_bhis objectAtIndex:i];
        if([(NSString *)[a objectForKey:@"id"] caseInsensitiveCompare:(NSString *)[brd objectForKey:@"id"]] == NSOrderedSame){
            break;
        }
    }
    if(i < [userdata_bhis count]){
        [userdata_bhis removeObjectAtIndex:i];
    }
    
    if([userdata_bhis count] >= MAX_BHIS){
        [userdata_bhis removeObjectAtIndex:0];
    }
    
    [userdata_bhis addObject:brd];
    
    apiSetUserData_bhis(userdata_bhis);
    
    return 0;
}

//config
static NSMutableDictionary * userdata_config = nil;
static NSString * userdata_config_userid;

static NSString * userdata_config_get_fname(NSString * userid){
    NSString *localUserPath = userdata_get_path(userid);
    
    return [localUserPath stringByAppendingPathComponent:@"config"];
}

static void userdata_load_config(NSString * userid)
{
    if(userdata_config && [userid isEqualToString:userdata_config_userid]){
        return;
    }
    
    userdata_config = nil;
    
    NSString * fname = userdata_config_get_fname(userid);
#ifdef DEBUG
    NSLog(@"init config:%@", fname);
#endif
    
    userdata_config = [NSMutableDictionary dictionaryWithContentsOfFile:fname];
    userdata_config_userid = [userid copy];
}

NSString * apiGetUserData_config(NSString * key)
{
    userdata_load_config([appSetting getLoginInfoUsr]);
    
    if(userdata_config == nil){
        return nil;
    }
    return (NSString *)[userdata_config objectForKey:key];
}

int apiSetUserData_config(NSString * key, NSString * value)
{
    userdata_load_config([appSetting getLoginInfoUsr]);
    if(userdata_config == nil){
        userdata_config = [[NSMutableDictionary alloc] init];
    }
    [userdata_config setObject:value forKey:key];
    
    NSString * fname = userdata_config_get_fname([appSetting getLoginInfoUsr]);
    [userdata_config writeToFile:fname atomically:YES];

    return 0;
}