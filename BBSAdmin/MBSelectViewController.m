//
//  MBSelectViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/11/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "MBSelectViewController.h"

@interface MBSelectViewController ()

@end

@implementation MBSelectViewController
@synthesize  m_tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    mblist = apiGetUserData_MBList();

    if(mblist == nil){
        [self loadContent];
    }
}

- (void) parseContent
{
    NSArray * array = [net_smth net_LoadMember:[appSetting getLoginInfoUsr] :0 :100];
    if(net_smth->net_error == 0){
        m_bLoadRes = 1;
        NSMutableArray * a = [NSMutableArray arrayWithCapacity:10];
        [a removeAllObjects];
        NSEnumerator * e = [array objectEnumerator];
        for(NSDictionary * ele in e){
            NSDictionary * dict_board = [ele objectForKey:@"board"];
            if(dict_board){
                [a addObject:dict_board];
            }
        }
        apiSetUserData_MBList(a);
    }
}

-(bool)scroll_enabled
{
    return false;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(mblist == nil){
        return 1;
    }
    return 1 + [mblist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return 64.0f;
    else
        return 48.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"MBSelectViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }

    //set cell
    [cell setBackgroundColor:[UIColor clearColor]];

    if(indexPath.row == 0){
        cell.textLabel.text = @"---只列出驻版版面---";
        cell.detailTextLabel.text = @"";
    }else{
        if(indexPath.row <= [mblist count]){
            NSDictionary * dict = [mblist objectAtIndex:(indexPath.row-1)];
            cell.textLabel.text = [dict objectForKey:@"id"];
            cell.detailTextLabel.text = [dict objectForKey:@"name"];
        }else{
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
        }
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return;
    }
    if(indexPath.row <= [mblist count]){
        NSDictionary * dict = [mblist objectAtIndex:(indexPath.row-1)];
        apiSetMBSelect([dict objectForKey:@"id"], [dict objectForKey:@"name"]);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)pressBtnBack:(id)sender {
    apiSetMBSelect(nil, nil);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateContent
{
    mblist = apiGetUserData_MBList();
    [m_tableView reloadData];
}


@end
