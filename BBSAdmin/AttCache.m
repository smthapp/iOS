#import "AttCache.h"


@implementation AttCache

+ (AttCache *) sharedCache
{
    static dispatch_once_t once;
    static id instance;
    
    dispatch_once(&once, ^{
        instance = [self new];
        [instance init_with_diskpath:@"ImageCache" :0];
    });
    
    return instance;
}

- (NSString *) key_with_size:(NSString *)key :(int)size
{
    return [NSString stringWithFormat:@"%@_%d", key, size];;
}

- (UIImage *) getImage_fixsize:(NSString *)key :(int)size
{
    NSString * realkey = [self key_with_size:key :size];
    
    NSData * data = [self get_data:realkey];
    if(data){
        UIImage * t = [UIImage imageWithData:data] ;
        if(t != nil){
            return t;
        }
    }

    return nil;
}

- (UIImage *) getImage:(NSString *)key :(int)size
{
    UIImage * t = [self getImage_fixsize:key :size];
    if(t != nil){
        return t;
    }
    //find large resolution
    if(size == 1){
        return nil;
    }
    t = [self getImage_fixsize:key :1];
    if(t != nil){
        return t;
    }
    
    if(size == 2){
        return nil;
    }
    t = [self getImage_fixsize:key :2];
    if(t != nil){
        return t;
    }
    
    return nil;
}

- (void) addImage:(NSData *)_data :(NSString *)key :(int)size
{
    NSString * realkey = [self key_with_size:key :size];

    //add to memCache
    [self add_data:_data :realkey];
}

@end
