#import "UserinfoCache.h"


@implementation UserinfoCache

+ (UserinfoCache *) sharedCache
{
    static dispatch_once_t once;
    static id instance;
    
    dispatch_once(&once, ^{
        instance = [self new];
        [instance init_with_diskpath:@"Userinfo" :1];
    });
    
    return instance;
}
@end
