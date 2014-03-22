#import "UIViewController+AppGet.h"

@implementation UIViewController (AppGet)

+ (id)appGetView:(NSString *)view_id
{
    UIStoryboard *mainStoryboard = nil;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    }
    else
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    }
    
    UIViewController * newViewController = [mainStoryboard instantiateViewControllerWithIdentifier:view_id];
    newViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    return newViewController;
}

@end
