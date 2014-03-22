#import <UIKit/UIKit.h>
#import "InfoCenter.h"
#import "DiskCache.h"

@interface AttCache : DiskCache

+ (AttCache *) sharedCache;

- (UIImage *) getImage:(NSString *)key :(int)size;
- (void) addImage:(NSData *)_data :(NSString *)key :(int)size;

@end
