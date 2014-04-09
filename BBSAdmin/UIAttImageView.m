#import "UIAttImageView.h"
#import "PictureViewController.h"
#import "UIViewController+AppGet.h"

@implementation UIAttImageView

+ (NSString *)att_get_key:(NSString *)board_id :(long)reply_id :(long)att_pos :(int)size
{
    return [NSString stringWithFormat:@"%@_%ld_%ld", board_id, reply_id, att_pos];
}

+ (UIImage *)getImageFromCache:(NSString *)board_id :(long)reply_id :(long)att_pos :(int)size
{
    AttCache * _ac = [AttCache sharedCache];
    NSString * _key = [UIAttImageView att_get_key:board_id :reply_id :att_pos :size];
    
    //find in cache
    UIImage * t = [_ac getImage:_key :size];
    if(t != nil) {
        return t;
    }else{
        return [UIImage imageNamed:@"att_loading.png"];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if([((NSHTTPURLResponse *)response) statusCode] >= 400){
        att_responseData = nil;
        [self att_download_done];
        return;
    }
    att_responseData = [[NSMutableData alloc] init];
    expect_size = (response.expectedContentLength > 0) ? (int)response.expectedContentLength : 0;
    
    if(expect_size){
        label_progress = [[UILabel alloc] initWithFrame:self.frame];
        label_progress.text = [NSString stringWithFormat:@"[0/%d KB]",(expect_size+1023)/1024];
        [self addSubview:label_progress];
        label_progress.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        label_progress.textAlignment = NSTextAlignmentCenter;
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(att_responseData){
        [att_responseData appendData:data];
        if(label_progress){
            label_progress.text = [NSString stringWithFormat:@"[%d/%d KB]",((int)[att_responseData length]+1023)/1024, (expect_size+1023)/1024];
        }
    }
}

-(void)att_download_done
{
#ifdef DEBUG
    NSLog(@"att download done");
#endif
    if(label_progress){
        [label_progress removeFromSuperview];
        label_progress = nil;
    }
    if(att_responseData == nil || [att_responseData length] == 0){
        return;
    }
    //NSData * data =[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    UIImage * image = [UIImage imageWithData:att_responseData];
    
    if(image != nil){
        //add to cache
        [ac addImage:att_responseData :key :att_size];
        //don't refresh image immediately.
        self.image = image;
        if(tv){
#ifdef DEBUG
            NSLog(@"reload row");
#endif
            [tv reloadRowsAtIndexPaths:[NSArray arrayWithObject:index_path] withRowAnimation:UITableViewRowAnimationNone];
        }
        if(click_en == 2){
            PictureViewController * pic = (PictureViewController *)parent;
            [pic enable_scroll];
        }
        return;
    }

}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self att_download_done];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    att_responseData = nil;
    [self att_download_done];
}



- (void)onClickImage
{
    PictureViewController *picViewController = [UIViewController appGetView:@"PictureViewController"];

    [picViewController SetContentInfo:boardid :reply :pos];
    [parent presentViewController:picViewController animated:YES completion:nil];
}


- (int)setContentInfo:(NSString *)board_id :(long)reply_id :(long)att_pos :(int)size :(int)click :(UIViewController *)_parent
{
    click_en = click;
    parent = _parent;
    
    boardid = [board_id copy];
    reply = reply_id;
    pos = att_pos;
    
    ac = [AttCache sharedCache];
    key = [UIAttImageView att_get_key:board_id :reply_id :att_pos :size];
    att_size = size;
    
    if(click_en == 1){
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage)];
        [self addGestureRecognizer:singleTap];
    }
    
    NSString * strsize;
    if(size == 1){
        strsize = @"large";
    }else if(size == 3){
        strsize = @"small";
    }else{
        strsize = @"middle";
    }
    
    //find in cache
    UIImage * t = [ac getImage:key :size];
    if(t != nil) {
        self.image = t;
        return 1;
    }
    
    self.image = [UIImage imageNamed:@"att_loading.png"];
    
    //not in cache, retrieve
#ifdef DEBUG
    //NSLog(@"real get image:%ld", att_pos);
#endif
    
    NSString * url = [NSString stringWithFormat:@"http://att.newsmth.net/nForum/att/%@/%ld/%ld/%@", board_id, reply_id, att_pos, strsize];
#ifdef DEBUG
    NSLog(@"real get image:%@",url);
#endif
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    att_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [att_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [att_connection start];

    return 0;
}

- (void)att_set_cell:(UITableView *)_tv :(NSIndexPath *)_ip
{
    tv = _tv;
    index_path = _ip;
}

- (void)dealloc
{
    if(att_connection){
        [att_connection cancel];
        att_connection = nil;
    }
}

+ (void)imageClearAttCache
{
    AttCache * ac = [AttCache sharedCache];
    
    [ac clear_cache];
}

@end