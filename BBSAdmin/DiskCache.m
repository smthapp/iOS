#import "UIAttImageView.h"
#import "DiskCache.h"

@implementation DiskCache

@synthesize memCache;
@synthesize diskCachePath;
@synthesize key_subdir;

- (void) init_with_diskpath:(NSString *)disk_path :(int)_subdir
{
    key_subdir = _subdir;
    
    memCache = [[NSCache alloc] init];
    if(key_subdir){
        memCache.name = [NSString stringWithFormat:@"net.newsmth.SMTH.%@", disk_path];
    }else{
        memCache.name = [NSString stringWithFormat:@"net.newsmth.SMTH.%@.%@", disk_path, [appSetting getLoginInfoUsr]];
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:disk_path];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                withIntermediateDirectories:YES
                                attributes:nil
                                error:&error];
    }
    
    
    return;
}

- (NSString *) get_disk_path:(NSString *)key
{
    NSString *localUserPath;
    
    if(key_subdir){
        NSString * k0 = [[key substringToIndex:1] uppercaseString];
        localUserPath = [diskCachePath stringByAppendingPathComponent:k0];
    }else{
        localUserPath = [diskCachePath stringByAppendingPathComponent:[appSetting getLoginInfoUsr]];
    }

    if (![[NSFileManager defaultManager] fileExistsAtPath:localUserPath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:localUserPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }

    return [localUserPath stringByAppendingPathComponent:key];
}

- (void) clear_mem_cache
{
    [memCache removeAllObjects];
}

- (void) clear_disk_cache
{
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:diskCachePath error:&error];
}

- (void) clear_cache
{
    [self clear_mem_cache];
    [self clear_disk_cache];
}

- (id) get_data:(NSString *)key
{
    //first get image from memcache
    id t = [memCache objectForKey:key];
    if(t != nil){
        return t;
    }
    
    //then get from Disk
    NSString * localPath = [self get_disk_path:key];
    if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
        return nil;
    }
    
    t = [NSData dataWithContentsOfFile:localPath];
    if(t == nil){
        return nil;
    }
    
    //save the data to memcache
    [self add_data_mem:t :key];
    
#ifdef DEBUG
    //NSLog(@"diskcache from disk:%@ %@", localPath, key);
#endif
    return t;
}

- (void) add_data_mem:(id)data :(NSString *)key
{
    [memCache setObject:data forKey:key];
}

- (void) add_data:(id)data :(NSString *)key
{
    //add to memCache
    [self add_data_mem:data :key];
    
    //add to disk
    NSString * localPath = [self get_disk_path:key];

    [(NSData *)data writeToFile:localPath atomically:NSAtomicWrite];

#ifdef DEBUG
    if([(NSData *)data length]){
        NSLog(@"attcache to disk:%@ %@ %lu", localPath, key, (unsigned long)[(NSData *)data length]);
    }
#endif
}
@end
