#import "UIFaceImageView.h"
#import "UserinfoViewController.h"
#import "UIViewController+AppGet.h"

@implementation UIFaceImageView

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
#ifdef DEBUG
    //NSLog(@"receive resp:%@ %d", userid, [((NSHTTPURLResponse *)response) statusCode]);
#endif
    if([((NSHTTPURLResponse *)response) statusCode] >= 400){
        face_responseData = nil;
        if([((NSHTTPURLResponse *)response) statusCode] == 404){
            [self face_download_done];
        }
        return;
    }
    
    face_responseData = [[NSMutableData alloc] init];
    face_expect_size = (response.expectedContentLength > 0) ? (int)response.expectedContentLength : 0;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(face_responseData){
        [face_responseData appendData:data];
    }
}

-(void)face_download_done
{
    if(face_responseData == nil){
        face_responseData = [[NSMutableData alloc] init];
    }
    
#ifdef DEBUG
    //NSLog(@"face download done:%@ %d", userid, [face_responseData length]);
#endif
    
    [fc add_data:face_responseData :userid];
    
    if([face_responseData length] > 0){
        UIImage * image = [UIImage imageWithData:face_responseData];
    
        if(image != nil){
            self.image = image;
        
            return;
        }
    }
    
    face_responseData = nil;

}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(face_responseData){
        [self face_download_done];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    face_responseData = nil;
    return;
}

- (void)onClickImage
{
    if(parent == nil){
        return;
    }
    
    if(click_userinfo == 1){
        UserinfoViewController *userinfoViewController = [UIViewController appGetView:@"UserinfoViewController"];
        
        [userinfoViewController setContentInfo:userid];
        [parent presentViewController:userinfoViewController animated:YES completion:nil];
    }else if(click_userinfo == 2){
        UserinfoViewController * v = (UserinfoViewController *)parent;
        [v edit_face];
    }else{
    }
}

- (void)setContentInfo:(NSString *)_userid :(int)click :(UIViewController *)_parent;
{
    click_userinfo = click;
    parent = _parent;
    
    NSRange t_range = [_userid rangeOfString:@"."];
    if(t_range.location != NSNotFound){
        userid = [_userid substringToIndex:t_range.location];
        forcemode = 1;
    }else{
        userid = [_userid copy];
        forcemode = 0;
    }
    
    if(click_userinfo){
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage)];
        [self addGestureRecognizer:singleTap];
    }
    
    //infodone = 0;
    fc = [UserfaceCache sharedCache];
    face_responseData = nil;
    //ic = [UserinfoCache sharedCache];

    //find userinfo cache
    if(!forcemode){
        UIImage * t = [fc getImage:userid];
        if(t != nil) {
            self.image = t;
            return;
        }
    }

    //if userface not exist in cache, download userface
#ifdef DEBUG
    NSLog(@"real get userface:%@,%@,%d", userid, _userid, forcemode);
#endif
    
    NSString * url;
    if(!forcemode){
        url = [NSString stringWithFormat:@"http://images.newsmth.net/nForum/uploadFace/%@/%@.jpg", [[userid substringToIndex:1] uppercaseString], userid];
    }else{
        url = [NSString stringWithFormat:@"http://images.newsmth.net/nForum/uploadFace/%@/%@", [[userid substringToIndex:1] uppercaseString], _userid];
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    face_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    return;
}

- (void)dealloc
{
    if(face_connection){
        [face_connection cancel];
        face_connection = nil;
    }
}

+ (void)imageClearUserfaceCache
{
    UserfaceCache * ac = [UserfaceCache sharedCache];
    
    [ac clear_cache];
}

@end