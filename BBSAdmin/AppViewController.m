#import "AppViewController.h"
#import "InfoCenter.h"

@implementation AppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    refreshed = false;
    
    net_smth = [[SMTHURLConnection alloc] init];
    [net_smth init_smth];
    net_smth.delegate = self;

    UISwipeGestureRecognizer * swipeGr = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    [self.view addGestureRecognizer:swipeGr];
    
}

-(IBAction)pressBtnBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)swipeAction:(UIGestureRecognizer*)sender
{
    UISwipeGestureRecognizerDirection dir = [(UISwipeGestureRecognizer *)sender direction];
    if(dir == UISwipeGestureRecognizerDirectionRight){
        [self pressBtnBack:sender];
    }
}

- (void)moreContent
{
    [self loadContent];
}

- (void)initContent
{
    [self loadContent];
}

-(void)parseContent
{
    
}

- (bool)scroll_enabled
{
    return true;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(![self scroll_enabled]){
        return;
    }
    
    if(refreshed){
        return;
    }
    
    float height = scrollView.contentSize.height > self.view.frame.size.height ? self.view.frame.size.height : scrollView.contentSize.height;
    
    if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > SCROLL_REFRESH_TH) {
        
        [self moreContent];
        
        refreshed = true;
    }
    
    if (- scrollView.contentOffset.y / self.view.frame.size.height > SCROLL_REFRESH_TH) {
        [self initContent];
        
        refreshed = true;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    refreshed = false;
}

-(void)loadContent
{
    [net_smth reset_status];
    
    m_bLoadRes = 0;
    net_ops = 1;
    net_ops_done = 0;
    net_ops_percent = 0;
    net_usercancel = 0;

    m_progressBar = [[MBProgressHUD alloc] initWithView:self.view];
    m_progressBar.delegate = self;
    m_progressBar.labelText = @"努力加载中(00%%)...";
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HudTapped)];
    tap.delegate = self;
    [m_progressBar addGestureRecognizer:tap];
    [self.view addSubview:m_progressBar];
    
    [m_progressBar showWhileExecuting:@selector(parseContent) onTarget:self withObject:nil animated:YES];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    int dx = m_progressBar.frame.size.width/2 - [touch locationInView:m_progressBar].x;
    int dy = m_progressBar.frame.size.height/2 - [touch locationInView:m_progressBar].y;
    
    if(abs(dx) <= 75 && abs(dy) <= 50){
        return YES;
    }
    return NO;
}

- (void)updateContent
{
    
}

-(NSString *)get_error_msg
{
    switch(net_smth->net_error){
        case 10319:
            return @"添加失败,该版面可能已在收藏夹";
        case 10401:
            return @"您没有关注任何版面。在版面列表长按版面可以关注版面";
        case 10402:
            return @"关注失败,您可能已关注此版(驻版)";
        default:
            return nil;
    }
}

#pragma mark MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	if (m_progressBar)
    {
        if (net_smth->net_error != 0 && !net_usercancel) {
            //TODO: 更加详细的出错信息提示
            NSString * errmsg;
            if((errmsg = [self get_error_msg]) != nil){
            }else if(net_smth->net_error < 0) {
                errmsg = @"网络或者服务器错误";
            }else if(net_smth->net_error < 11000){
                //11000一下不显示错误原因
                errmsg = @"系统错误";
            }else if(net_smth->net_error_desc && ![net_smth->net_error_desc isEqualToString:@""]){
                errmsg = net_smth->net_error_desc;
            }else{
                errmsg = @"未知错误";
            }
            UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"错误" message:[NSString stringWithFormat:@"%@(%d)", errmsg, net_smth->net_error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [altview show];
        }
        
        if (m_bLoadRes == 1)
        {
            [self updateContent];
        }
        
        [m_progressBar removeFromSuperview];
        m_progressBar = nil;
    }
}

-(void)HudTapped
{
    [net_smth cancel];
    net_usercancel = true;

    m_progressBar.labelText = [NSString stringWithFormat:@"取消加载..."];
    usleep(500000);
}

- (void)update_netop_show
{
    if(m_progressBar){
        m_progressBar.labelText = [NSString stringWithFormat:@"努力加载中(%02d%%)...",net_ops_percent];
    }
}
-(void)init_without_UI
{
    m_progressBar = nil;
    
    net_smth = [[SMTHURLConnection alloc] init];
    [net_smth init_smth];
    net_smth.delegate = self;
}



-(void)smth_update_progress:(SMTHURLConnection *)con
{
    int percent = con->net_progress;
    
    if(net_ops == 0){
        net_ops = 1;
    }
    net_ops_percent = (net_ops_done * 100 + percent) / net_ops;
    
    [self update_netop_show];
}

-(void)update_unread
{
    net_ops = 3;

    NSDictionary * dict = [net_smth net_GetReferCount:2];
    if(dict) {
        appSetting->reply_unread = [(NSString*)[dict objectForKey:@"new_count"] intValue];
    }
    dict = [net_smth net_GetReferCount:1];
    if(dict) {
        appSetting->at_unread = [(NSString*)[dict objectForKey:@"new_count"] intValue];
    }
    dict = [net_smth net_GetMailCount];
    if(dict) {
        appSetting->mail_unread = [(NSString*)[dict objectForKey:@"new_count"] intValue];
    }
}

@end