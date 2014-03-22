//
//  MatchContentViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/3/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "MatchContentViewController.h"
#import "GuessRegViewController.h"
#import "UIViewController+AppGet.h"

@interface MatchContentViewController ()

@end

@implementation MatchContentViewController
@synthesize m_tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    addvotemode = 0;
    [self loadContent];
}

-(void)VoteMatch:(int)sel :(int)addmoney;
{
    vote_sel = sel;
    vote_addmoney = addmoney;
    addvotemode = 1;
    
    [self loadContent];
}

-(void)parseContent
{
    if(addvotemode){
        addvotemode = 0;
        
        if(vote_addmoney > canvote){
            UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"错误" message:[NSString stringWithFormat:@"投注额超过限额"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [altview show];
            return;
        }

        [net_smth net_VoteMatch:guessid :matchid :vote_sel :vote_addmoney];
        if(net_smth->net_error != 0){
            UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"错误" message:[NSString stringWithFormat:@"投注失败"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [altview show];
        }else{
            UIAlertView *altview = [[UIAlertView alloc]initWithTitle:@"成功" message:[NSString stringWithFormat:@"投注成功"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [altview show];
        }
    }

    match = [net_smth net_LoadMatch:guessid :matchid];
    
    if(net_smth->net_error == 0){
        m_bLoadRes = 1;
        
        matchmode = [(NSString *)[match objectForKey:@"mode"] intValue];
        options = (NSArray *)[match objectForKey:@"options"];
        mymoney = [match objectForKey:@"my_money"];
        myvotes = (NSArray *)[match objectForKey:@"my_votes"];
        status = [(NSString *)[match objectForKey:@"status"] intValue];
        selnum = [(NSString *)[match objectForKey:@"selnum"] intValue];
        canvote = [[mymoney objectForKey:@"avail"] intValue] ;

        
        int i;
        for(i=0; i<MAX_OPTIONS_PER_MATCH; i++){
            my_voted_money[i] = 0;
        }
        if(myvotes && [myvotes count] > 0){
            NSEnumerator * e = [myvotes objectEnumerator];
            for(NSDictionary * ele in e){
                int sel = [(NSString *)[ele objectForKey:@"sel"] intValue];
                if(sel >= 0 && sel < MAX_OPTIONS_PER_MATCH){
                    my_voted_money[sel] += [(NSString *)[ele objectForKey:@"money"] intValue];
                }
            }

        }
    }else if(net_smth->net_error == 11401){
        m_bLoadRes = 2;
    }
}

-(void)moreContent
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + selnum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 80.0f;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return 80.0f;
    else
        return 86.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        static NSString *cellId;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            cellId = @"MatchHeadCell_iPad";
        else
            cellId = @"MatchHeadCell_iPhone";
        MatchHeadCell *cell = (MatchHeadCell*)[self.m_tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
            cell = (MatchHeadCell*)[nibArray objectAtIndex:0];
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        NSString * strStatus;
        if(status == 0){
            strStatus = @"竞猜尚未开始";
        }else if(status == 1){
            strStatus = [NSString stringWithFormat:@"竞猜进行中,%@结束", appGetDateStringAfter([(NSString *)[match objectForKey:@"closedate"] intValue], 0)];
        }else{
            strStatus = @"竞猜已结束";
        }
        
        [cell setContentInfo:[match objectForKey:@"matchname"] :[NSString stringWithFormat:@"共有%d分，已投注%d分，还可投注%d分",
                                                                [[mymoney objectForKey:@"total"] intValue],
                                                                [[mymoney objectForKey:@"voted"] intValue],
                                                                canvote
                                                                 ] :strStatus];
        
        return cell;

    }else if(indexPath.row < 1 + [options count]){
        //options
        static NSString *root_cellId;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            root_cellId = @"MatchOptionCell_iPad";
        else
            root_cellId = @"MatchOptionCell_iPhone";
        MatchOptionCell *cell = (MatchOptionCell*)[self.m_tableView dequeueReusableCellWithIdentifier:root_cellId];
        if (cell == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:root_cellId owner:self options:nil];
            cell = (MatchOptionCell*)[nibArray objectAtIndex:0];
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        NSDictionary * dict_opt = [options objectAtIndex:(indexPath.row-1)];

        [cell setContentInfo:[NSString stringWithFormat:@"选项%d: %@", (int)indexPath.row, [dict_opt objectForKey:@"name"]] :matchmode :[[dict_opt objectForKey:@"odds"] floatValue] :my_voted_money[indexPath.row - 1] :(int)indexPath.row :status :self];
        return cell;
    }else{
        return nil;
    }
    
}

-(void)showReg:(int)_guessid
{
    GuessRegViewController *guessRegViewController = [UIViewController appGetView:@"GuessRegViewController"];
    
    [guessRegViewController setContentInfo:_guessid :[appSetting getLoginInfoUsr]];
    
    [self presentViewController:guessRegViewController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	if (m_progressBar)
    {
        if (m_bLoadRes == 1)
        {
            [m_tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [m_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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

-(void)setContentInfo:(int)guess_id :(int)match_id
{
    guessid = guess_id;
    matchid = match_id;
}
@end
