//
//  GuessTopCell.h
//  BBSAdmin
//
//  Created by HE BIAO on 2/9/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuessTopCell : UITableViewCell
{
}

@property (strong, nonatomic) IBOutlet UILabel *label_rank;
@property (strong, nonatomic) IBOutlet UILabel *label_userid;
@property (strong, nonatomic) IBOutlet UILabel *label_money;
@property (strong, nonatomic) IBOutlet UILabel *label_match;


-(void)setContentInfo:(NSDictionary *)rank;

@end

