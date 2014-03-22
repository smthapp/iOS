#import <UIKit/UIKit.h>
#import "InfoCenter.h"
#import "UserfaceCache.h"
#import "UserinfoCache.h"

@interface UIFaceImageView : UIImageView
{
    //UserinfoCache * ic;
    UserfaceCache * fc;
    
    NSString * userid;
    
    //NSMutableData * info_responseData;
    NSMutableData * face_responseData;
    NSURLConnection * face_connection;
    int face_expect_size;
    int face_size;
    
    //int infodone;
    int click_userinfo;
    UIViewController * parent;
    
    int forcemode;
}

//public API
/**
 *@ click 0: disable click, 1: click to show userinfoview 2: click to edit profile
 */
- (void)setContentInfo:(NSString *)_userid :(int)click :(UIViewController *)_parent;

//+ (void)imageClearUserinfoCache;
+ (void)imageClearUserfaceCache;


@end