//
//  GuessTopCell.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/9/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "GuessTopCell.h"

@implementation GuessTopCell
@synthesize label_match,label_money,label_rank,label_userid;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContentInfo:(NSDictionary *)rank
{
    [label_rank setText:[NSString stringWithFormat:@"(%d)", [(NSString *)[rank objectForKey:@"rank"] intValue]]];
    [label_userid setText:[rank objectForKey:@"userid"]];
    int winmoney = [(NSString *)[rank objectForKey:@"money_win"] intValue];
    int total = [(NSString *)[rank objectForKey:@"money_in"] intValue];
    NSString * winstr;
    if(winmoney >= 0){
        winstr = @"赢";
    }else{
        winstr = @"输";
    }
    int percent;
    if(total == 0){
        percent = 0;
    }else{
        percent = winmoney * 100 / total;
    }
    [label_money setText:[NSString stringWithFormat:@"%@%d分(投%d分,%d%%回报)",winstr,(winmoney >= 0 ? winmoney : 0 - winmoney),total, percent] ];
    
    int m_win = [(NSString *)[rank objectForKey:@"match_win"] intValue];
    int m_all = [(NSString *)[rank objectForKey:@"match_in"] intValue];
    if(m_all == 0){
        percent = 0;
    }else{
        percent = m_win * 100 / m_all;
    }
    [label_match setText:[NSString stringWithFormat:@"赢%d场(共%d场,%d%%胜)",m_win, m_all, percent]];
}

@end
