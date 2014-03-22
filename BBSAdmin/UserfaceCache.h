#import <UIKit/UIKit.h>
#import "InfoCenter.h"
#import "DiskCache.h"

@interface UserfaceCache : DiskCache

+ (UserfaceCache *) sharedCache;

- (UIImage *) getImage:(NSString *)key;

@end
