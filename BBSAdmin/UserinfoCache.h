#import <UIKit/UIKit.h>
#import "InfoCenter.h"
#import "DiskCache.h"

@interface UserinfoCache : DiskCache

+ (UserinfoCache *) sharedCache;

@end
