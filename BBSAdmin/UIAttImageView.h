#import <UIKit/UIKit.h>
#import "InfoCenter.h"
#import "AttCache.h"

@interface UIAttImageView : UIImageView
{
    AttCache * ac;
    NSString * key;
    
    NSMutableData * att_responseData;
    NSURLConnection * att_connection;
    int expect_size;
    int att_size;
    
    __weak UITableView * tv;
    NSIndexPath * index_path;
    
    int click_en; //1: click for full screen. 2: need update scroll
    UIViewController * parent;
    
    UILabel * label_progress;
    
    NSString * boardid;
    long reply;
    long pos;
}

- (void)att_set_cell:(UITableView *)_tv :(NSIndexPath *)_ip;
- (int)setContentInfo:(NSString *)board_id :(long)reply_id :(long)att_pos :(int)size :(int)click :(UIViewController *)_parent;
+ (void)imageClearAttCache;
+ (UIImage *)getImageFromCache:(NSString *)board_id :(long)reply_id :(long)att_pos :(int)size;


@end