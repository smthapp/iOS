#import "UserfaceCache.h"


@implementation UserfaceCache

+ (UserfaceCache *) sharedCache
{
    static dispatch_once_t once;
    static id instance;
    
    dispatch_once(&once, ^{
        instance = [self new];
        [instance init_with_diskpath:@"Userface" :1];
    });
    
    return instance;
}

- (UIImage *) getImage:(NSString *)key
{
    NSData * data = [self get_data:key];
    if(data){
        if([data length] == 0){
            return [UIImage imageNamed:@"head00.png"];
        }
        UIImage * t = [UIImage imageWithData:data] ;
        if(t != nil){
            return t;
        }else{
            
        }
    }

    return nil;
}

@end
