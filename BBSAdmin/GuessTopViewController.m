//
//  GuessTopViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/9/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "GuessTopViewController.h"

@interface GuessTopViewController ()

@end

@implementation GuessTopViewController
@synthesize m_mtarrayInfo, m_tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    m_mtarrayInfo = [NSMutableArray arrayWithCapacity:10];
    
    [self loadContent];
}

-(void)parseContent
{
    NSArray * top = [net_smth net_ListGuessTop:guessid];
    if(net_smth->net_error == 0){
        m_bLoadRes = 1;
        
        [m_mtarrayInfo removeAllObjects];
        [m_mtarrayInfo addObjectsFromArray:top];
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
        return 54.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *root_cellId;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        root_cellId = @"GuessTopCell_iPad";
    else
        root_cellId = @"GuessTopCell_iPhone";
    GuessTopCell *cell = (GuessTopCell*)[self.m_tableView dequeueReusableCellWithIdentifier:root_cellId];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:root_cellId owner:self options:nil];
        cell = (GuessTopCell*)[nibArray objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell setContentInfo:[m_mtarrayInfo objectAtIndex:(indexPath.row)]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)updateContent
{
    [m_tableView reloadData];
}

- (bool)scroll_enabled
{
    return false;
}

- (void)setContentInfo:(int)_guessid
{
    guessid = _guessid;
}

@end
