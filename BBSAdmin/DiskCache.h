#import <UIKit/UIKit.h>
#import "InfoCenter.h"

@interface DiskCache : NSObject

@property (strong, nonatomic) NSCache * memCache;
@property (strong, nonatomic) NSString *diskCachePath;
//key_subdir: if 1, file will be ROOT/disk_path/KEY[0]/key
//if 0, file will be ROOT/disk_path/USERID/key
@property (nonatomic) int key_subdir;

- (void) init_with_diskpath:(NSString *)disk_path :(int)_subdir;

- (void) add_data:(id)data :(NSString *)key;
- (id) get_data:(NSString *)key;

- (void) clear_cache;

@end
