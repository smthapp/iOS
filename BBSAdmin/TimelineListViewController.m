//
//  TimelineListViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/10/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "TimelineListViewController.h"
#import "ArticleContentViewController.h"
#import "UserData.h"
#import "ArticleContentEditController.h"
#import "UIViewController+AppGet.h"

#define ARTICLE_PAGE_SIZE 20

@interface TimelineListViewController ()

@end

@implementation TimelineListViewController
@synthesize m_mtarrayInfo,m_tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    m_mtarrayInfo = [NSMutableArray arrayWithCapacity:10];
    
    [self initContent];
}

- (void)initCurDate
{
    cur_time = [[NSDate date] timeIntervalSince1970];
}

- (void)initContent
{
    [m_mtarrayInfo removeAllObjects];

    from = 0;
    load_size = ARTICLE_PAGE_SIZE;
    
    [self loadContent];
}

-(void)parseContent
{
    last_read_time = apiGetUserData_BRC(@"___");
    
    NSArray * a = [net_smth net_LoadTimelineList:0 :from :load_size];
    
    if(net_smth->net_error == 0){
        [self initCurDate];

        NSEnumerator * e = [a objectEnumerator];
        for(id ele in e){
            [m_mtarrayInfo addObject:ele];
        }
        
        m_bLoadRes = 1;
        
        from += [a count];
        size += [a count];
        
        apiSetUserData_BRC(@"___", (long long int)cur_time);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_mtarrayInfo count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return 64.0f;
    else
        return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *root_cellId;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        root_cellId = @"TimelineListCell_iPad";
    else
        root_cellId = @"TimelineListCell_iPhone";
    TimelineListCell *cell = (TimelineListCell*)[self.m_tableView dequeueReusableCellWithIdentifier:root_cellId];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:root_cellId owner:self options:nil];
        cell = (TimelineListCell*)[nibArray objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary * dict = nil;
    if(indexPath.row < [m_mtarrayInfo count]){
        dict = [m_mtarrayInfo objectAtIndex:indexPath.row];
    }
    if(dict) {
        [cell setContentInfo:dict :cur_time :last_read_time :self];
    }else{
        [cell setContentInfo:nil :0 :0 :self];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [m_mtarrayInfo objectAtIndex:indexPath.row];
    
    [self showArticleContent:[dict objectForKey:@"board_id"] :[dict objectForKey:@"board_name"] :[[dict objectForKey:@"id"] intValue] :[(NSString *)[dict objectForKey:@"count"] intValue]];
}

//position: normalmode: article_cnt; refermode:position; mailmode:position
-(void)showArticleContent:(NSString *)boardid :(NSString *)boardname :(long)art_id :(int)position
{
    ArticleContentViewController *artcontViewController = [UIViewController appGetView:@"ArtContViewController"];

    [artcontViewController setContentInfo:0 :0 :boardid :boardname :art_id :position];
    
    [self presentViewController:artcontViewController animated:YES completion:nil];
}

-(void)updateContent
{
    [m_tableView reloadData];
}

- (IBAction)pressBtnNew:(id)sender {
    ArticleContentEditController *artcontEditController = [UIViewController appGetView:@"ArtContEditController"];
    
    [artcontEditController setContentInfo:false :nil :nil :nil :false];

    [self presentViewController:artcontEditController animated:YES completion:nil];
}
@end
