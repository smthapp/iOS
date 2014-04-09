//
//  MatchListViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 1/30/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "MatchListViewController.h"
#import "GuessRegViewController.h"
#import "UIViewController+AppGet.h"

@interface MatchListViewController ()

@end

@implementation MatchListViewController
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
    if(allmatch_mode){
        NSArray * matches = [net_smth net_ListMatch];
        
        if(net_smth->net_error == 0){
            m_bLoadRes = 1;
            [m_mtarrayInfo removeAllObjects];
            [m_mtarrayInfo addObjectsFromArray:matches];
        }
    }else{
        NSDictionary * match_dict = [net_smth net_LoadGuess:guessid];
    
        if(net_smth->net_error == 0){
            NSArray * matches = [match_dict objectForKey:@"matches"];
            [m_mtarrayInfo removeAllObjects];
            m_bLoadRes = 1;
            if(matches && [matches count] > 0){
                [m_mtarrayInfo addObjectsFromArray:matches];
            }
            guess_mymoney = [(NSString *)[match_dict objectForKey:@"mymoney"] intValue];
            guess_mode = [(NSString *)[match_dict objectForKey:@"mode"] intValue];
        }else if(net_smth->net_error == 11401){
            m_bLoadRes = 2;
            [m_mtarrayInfo removeAllObjects];
        }
    }
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
    if(allmatch_mode){
        return [m_mtarrayInfo count];
    }else{
        return 2 + [m_mtarrayInfo count];
    }
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
        root_cellId = @"MatchInfoCell_iPad";
    else
        root_cellId = @"MatchInfoCell_iPhone";
    MatchInfoCell *cell = (MatchInfoCell*)[self.m_tableView dequeueReusableCellWithIdentifier:root_cellId];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:root_cellId owner:self options:nil];
        cell = (MatchInfoCell*)[nibArray objectAtIndex:0];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    if(!allmatch_mode && indexPath.row == 1){
        //it's top menu
        [cell setContentInfo:@"此主题排行榜" :1];
    }else if(!allmatch_mode && indexPath.row == 0){
        [cell setContentInfo:[NSString stringWithFormat:@"您有%d%@", guess_mymoney, guess_mode==1?@"积分":@"竞猜分"] :2];
    }else{
        int idx = (int)indexPath.row;
        if(!allmatch_mode){
            idx -= 2;
        }
        
        NSDictionary * dict = nil;
        if(idx < [m_mtarrayInfo count]){
            dict = [m_mtarrayInfo objectAtIndex:(idx)];
        }
        
        if(dict){
            [cell setContentInfo:[dict objectForKey:@"name"] :0];
        }
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!allmatch_mode && indexPath.row == 1){
        //it's top menu
        [self showGuessTop:guessid];
        return;
    }
    if(!allmatch_mode && indexPath.row == 0){
        return;
    }
    
    int idx = (int)indexPath.row;
    if(!allmatch_mode){
        idx -= 2;
    }

    NSDictionary * dict = [m_mtarrayInfo objectAtIndex:(idx)];

    if(allmatch_mode){
        [self showMatch:[(NSString *)[dict objectForKey:@"matchid"] intValue] :[(NSString *)[dict objectForKey:@"guessid"] intValue]];
    }else{
        [self showMatch:[(NSString *)[dict objectForKey:@"matchid"] intValue] :guessid];
    }
}

-(void)showGuessTop:(int)_guessid
{
    GuessTopViewController *matchCtViewController = [UIViewController appGetView:@"GuessTopViewController"];

    [matchCtViewController setContentInfo:_guessid];
    
    [self presentViewController:matchCtViewController animated:YES completion:nil];
}

-(void)showMatch:(int)matchid :(int)_guessid
{
    MatchContentViewController *matchCtViewController = [UIViewController appGetView:@"MatchContentViewController"];
    
    [matchCtViewController setContentInfo:_guessid :matchid];
    
    [self presentViewController:matchCtViewController animated:YES completion:nil];
}

-(void)showReg:(int)_guessid
{
    GuessRegViewController *guessRegViewController = [UIViewController appGetView:@"GuessRegViewController"];
    
    [guessRegViewController setContentInfo:_guessid :[appSetting getLoginInfoUsr]];
    
    [self presentViewController:guessRegViewController animated:YES completion:nil];
}

#pragma mark MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	if (m_progressBar)
    {
        if (m_bLoadRes == 1)
        {
            [m_tableView reloadData];
        }
        
        [m_progressBar removeFromSuperview];
        m_progressBar = nil;
        
        if(m_bLoadRes == 2){
            //need reg
            UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"需要先在此主题注册，以便领取获胜奖品"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注册", nil];
            [altview show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        //cancel:
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(buttonIndex == 1){
        //reg view
        [self showReg:guessid];
    }
}

-(void)setContentInfo:(int)i_guessid :(int)allmatch
{
    guessid = i_guessid;

    allmatch_mode = allmatch;
}
@end
