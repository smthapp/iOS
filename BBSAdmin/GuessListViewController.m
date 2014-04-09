//
//  GuessListViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 1/30/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "GuessListViewController.h"
#import "MatchListViewController.h"
#import "UIViewController+AppGet.h"

@interface GuessListViewController ()

@end

@implementation GuessListViewController
@synthesize m_tableView;
@synthesize m_mtarrayInfo;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    m_mtarrayInfo = [NSMutableArray arrayWithCapacity:10];
    
    [self loadContent];
}

-(void)parseContent
{
    NSArray * arrayInfo = [net_smth net_ListGuess];
    
    if(net_smth->net_error == 0){
        m_bLoadRes = 1;
        [m_mtarrayInfo removeAllObjects];
        [m_mtarrayInfo addObjectsFromArray:arrayInfo];
    }
}

- (IBAction)pressBtnBack:(id)sender
{
    //no back
    return;
}

-(void)moreContent
{
    //disable more option
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_mtarrayInfo count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return 64.0f;
    else
        return 54.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *root_cellId;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        root_cellId = @"GuessInfoCell_iPad";
    else
        root_cellId = @"GuessInfoCell_iPhone";
    GuessInfoCell *cell = (GuessInfoCell*)[self.m_tableView dequeueReusableCellWithIdentifier:root_cellId];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:root_cellId owner:self options:nil];
        cell = (GuessInfoCell*)[nibArray objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if(indexPath.row == 0){
        [cell setContentInfo:@"----所有进行中的竞猜----"];
    }else{
        NSDictionary * dict = nil;
        if(indexPath.row <= [m_mtarrayInfo count]){
            dict = [m_mtarrayInfo objectAtIndex:(indexPath.row - 1)];
        }
        if(dict) {
            [cell setContentInfo:[dict objectForKey:@"name"]];
        }else{
            [cell setContentInfo:@"--------"];
        }
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        [self showGuess:-1];
    }else{
        NSDictionary * dict = [m_mtarrayInfo objectAtIndex:(indexPath.row - 1)];

        [self showGuess:[(NSString *)[dict objectForKey:@"id"] intValue]];
    }
}

-(void)showGuess:(int)guessid
{
    MatchListViewController *matchlistViewController = [UIViewController appGetView:@"MatchListViewController"];
    
    if(guessid == -1){
        [matchlistViewController setContentInfo:0 :1];
    }else{
        [matchlistViewController setContentInfo:guessid :0];
    }
    
    [self presentViewController:matchlistViewController animated:YES completion:nil];
}

-(void)updateContent
{
    [m_tableView reloadData];
}


@end
