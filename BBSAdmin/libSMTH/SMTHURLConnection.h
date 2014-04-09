//
//  SMTHURLConnection.h
//  BBSAdmin
//
//  Created by HE BIAO on 3/7/14.
//  Copyright (c) 2014 newsmth. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMTHURLConnectionDelegate;

@interface SMTHURLConnection : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
@public
    int net_error;
    NSString * net_error_desc;
    int net_progress;

@private
    bool net_notoken_nosig;
    int net_nocheckerror;
    
    bool net_usercancel;
    
    NSCondition * net_cond;
    NSMutableData *net_responseData;
    
    NSURLConnection * net_connection;
    
    long last_thread_cnt;
}

@property (weak) id<SMTHURLConnectionDelegate> delegate;

/* must call after [[alloc]init] */
-(void)init_smth;
/* must call before net_query */
-(void)reset_status;
/* cancel operation */
-(void)cancel;

//thread
-(long)net_GetThreadCnt:(NSString *)board_id;
-(NSArray *)net_LoadThreadList:(NSString *)board_id :(long)from :(long)size :(int)brcmode;
-(NSArray *)net_SearchArticle:(NSString *)board_id :(NSString *)title :(NSString *)user :(long)from :(long)size;
-(NSArray *)net_GetThread:(NSString *)board_id :(long)article_id :(long)from :(long)size :(int)sort;
-(long)net_GetLastThreadCnt;
-(long)net_GetArticleCnt:(NSString *)board_id;
-(NSDictionary*)net_GetArticle:(NSString *)board_id :(long)article_id;
-(long)net_PostArticle:(NSString *)board_id :(NSString *)title :(NSString *)content;
-(long)net_ForwardArticle:(NSString *)board_id :(long)article_id :(NSString *)user;
-(long)net_ReplyArticle:(NSString *)board_id :(long)reply_id :(NSString *)title :(NSString *)content;
-(long)net_CrossArticle:(NSString *)board_id :(long)article_id :(NSString *)dest_board;
//mail
-(int)net_GetMailCountSent;
-(NSDictionary *)net_GetMailCount;
-(NSArray *)net_LoadMailSentList:(long)from :(long)size;
-(NSArray *)net_LoadMailList:(long)from :(long)size;
-(NSDictionary *)net_GetMailSent:(int)position;
-(NSDictionary *)net_GetMail:(int)position;
-(int)net_ReplyMail:(int)position :(NSString *)title :(NSString *)content;
-(long)net_ForwardMail:(int)position :(NSString *)receiver;
-(int)net_PostMail:(NSString *)receiver :(NSString *)title :(NSString *)content;
//refer
-(NSDictionary *)net_GetReferCount:(int)mode;
-(NSArray *)net_LoadRefer:(int)mode :(long)from :(long)size;
-(int)net_SetReferRead:(int)mode :(int)position;
//hot topics
-(NSArray *)net_LoadSectionHot:(long)section;
//favorite
-(NSArray *)net_LoadFavorites:(long)group;
-(void)net_AddFav:(NSString *)board_id;
-(void)net_DelFav:(NSString *)board_id;
//board
-(NSArray *)net_LoadBoards:(long)group;
-(NSArray *)net_QueryBoard:(NSString *)search;
//section
-(NSArray *)net_LoadSection;
-(NSArray *)net_ReadSection:(long)section :(long)group;
//user
-(NSDictionary *)net_QueryUser:(NSString *)userid;
-(NSArray *)net_LoadUserAllFriends:(NSString *)userid;
-(long long)net_LoadUserFriendsTS:(NSString *)userid;
-(int)net_AddUserFriend:(NSString *)userid;
-(int)net_DelUserFriend:(NSString *)userid;

-(NSDictionary *)net_modifyFace:(NSString *)face_fname;
//member
-(NSArray *)net_LoadMember:(NSString *)userid :(long)from :(long)size;
-(int)net_JoinMember:(NSString *)board_id;
-(int)net_QuitMember:(NSString *)board_id;
//timeline
-(NSArray *)net_LoadTimelineList:(int)friends :(int)loadold :(long)oldid :(long)size :(int)order_thread;
//guess
-(NSArray *)net_ListGuess;
-(NSArray *)net_ListMatch;
-(NSDictionary *)net_LoadGuess:(int)guessid;
-(NSArray *)net_ListGuessTop:(int)guessid;
-(int)net_RegGuess:(int)guessid :(NSString *)realname :(NSString *)phone;
-(NSDictionary *)net_LoadMatch:(int)guessid :(int)matchid;
-(int)net_VoteMatch:(int)guessid :(int)matchid :(int)sel :(int)money;
//login
-(NSDictionary*)net_GetVersion;
-(int)net_LoginBBS:(NSString*)usr :(NSString*)pwd;
-(void)net_LogoutBBS;


@end

@protocol SMTHURLConnectionDelegate <NSObject>

@optional
/* called when progress updated */
-(void)smth_update_progress:(SMTHURLConnection *)con;

@end
