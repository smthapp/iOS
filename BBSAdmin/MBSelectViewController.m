//
//  MBSelectViewController.m
//  BBSAdmin
//
//  Created by HE BIAO on 2/11/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import "MBSelectViewController.h"
#import "BoardListViewController.h"
#import "UIViewController+AppGet.h"
#import "ArticleListViewController.h"

@interface MBSelectViewController ()

@end

@implementation MBSelectViewController
@synthesize  m_tableView;
@synthesize searchbar;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    in_search = false;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableview_tapped)];
    waiting_for_mbselect = false;
    
    mblist = apiGetUserData_MBList();

    if(mblist == nil){
        [self loadContent];
    }else{
        [self updat_bhis];
    }
}

- (void)updat_bhis{
    bhis = [[NSMutableArray alloc] init];
    NSMutableArray * h = apiGetUserData_bhis();
    int i;
    for(i = ((int)[h count]-1); i >= 0; i--){
        NSDictionary * hdict = [h objectAtIndex:i];
        int j;
        for(j=0; j<[mblist count]; j++){
            NSDictionary * mbdict = [mblist objectAtIndex:j];
            if([(NSString *)[hdict objectForKey:@"id"] caseInsensitiveCompare:(NSString *)[mbdict objectForKey:@"id"]] == NSOrderedSame){
                break;
            }
        }
        if(j >= [mblist count]){
            [bhis addObject:hdict];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(waiting_for_mbselect){
        NSString * new_boardid = apiGetMBSelect();
        
        if(new_boardid != nil){
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        waiting_for_mbselect = false;
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
        
        [self updat_bhis];
    }
}

-(bool)scroll_enabled
{
    return false;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return @"我的关注";
    }else{
        return @"我的历史";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        if(mblist == nil){
            return 0;
        }
        return [mblist count];
    }else{
        return [bhis count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return 54.0f;
    else
        return 40.0f;
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

    NSDictionary * dict;
    
    if(indexPath.section == 0){
        dict = [mblist objectAtIndex:(indexPath.row)];
    }else{
        dict = [bhis objectAtIndex:(indexPath.row)];
    }
    
    cell.textLabel.text = [dict objectForKey:@"id"];
    cell.detailTextLabel.text = [dict objectForKey:@"name"];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict;
    
    if(indexPath.section == 0){
        dict = [mblist objectAtIndex:(indexPath.row)];
    }else{
        dict = [bhis objectAtIndex:(indexPath.row)];
    }

    apiSetMBSelect([dict objectForKey:@"id"], [dict objectForKey:@"name"]);
        
    [self dismissViewControllerAnimated:NO completion:nil];
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



- (void)do_search:(NSString *)_query
{
    waiting_for_mbselect = true;
    
    BoardListViewController *brdlistViewController = [UIViewController appGetView:@"BoardListViewController"];
    
    [brdlistViewController setContentInfo:4 :_query];
    
    [self presentViewController:brdlistViewController animated:YES completion:nil];
}

- (IBAction)pressBtnSearch:(id)sender {
    [searchbar setHidden:NO];
    [searchbar becomeFirstResponder];
    in_search = true;
    
    [m_tableView addGestureRecognizer:tap];
}

-(void)hide_searchbar
{
    [searchbar resignFirstResponder];
    [searchbar setHidden:YES];
    in_search = false;
    [m_tableView removeGestureRecognizer:tap];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self hide_searchbar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self hide_searchbar];
    [self do_search:searchbar.text];
}

-(void)tableview_tapped{
    if(in_search) {
        [self hide_searchbar];
    }
}

@end
