//
//  HTMascotService.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/25.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTMascotService.h"
#import "HTLogicHeader.h"

@implementation HTMascotService

- (void)getUserMascots:(HTGetMascotsCallback)callback {
    DLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getMascotsCGIKey] parameters:@{ @"user_id" : [[HTStorageManager sharedInstance] getUserID] } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage mj_objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            NSMutableArray<HTMascot *> *mascots = [[NSMutableArray alloc] init];
            for (int i = 0; i != [responseObject[@"data"] count]; i++) {
                HTMascot *mascot = [HTMascot mj_objectWithKeyValues:[responseObject[@"data"] objectAtIndex:i]];
                //获取未读文章数
                mascot.unread_articles = mascot.articles - [[HTStorageManager sharedInstance] getMascotInfoWithIndex:mascot.mascotID].articles;
                [mascots addObject:mascot];
            }
            callback(true, mascots);
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getUserMascotDetail:(uint64_t)mascotID completion:(HTGetMascotCallback)callback {
    DLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    
    NSDictionary *dataDict = @{@"user_id" : [[HTStorageManager sharedInstance] getUserID],
                               @"pet_id"  : @(mascotID)};
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getMascotInfoCGIKey] parameters:dataDict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage mj_objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0 && responseObject[@"data"] && responseObject[@"data"][@"articles"]) {
            HTMascot *mascot = [HTMascot mj_objectWithKeyValues:responseObject[@"data"][@"detail"]];
            NSMutableArray<HTArticle *> *articleList = [NSMutableArray array];
            for (NSDictionary *articleDict in responseObject[@"data"][@"articles"]) {
                HTArticle *article = [HTArticle mj_objectWithKeyValues:articleDict];
                [articleList addObject:article];
            }
            mascot.article_list = articleList;
            //存储已读文章数
            mascot.articles = mascot.article_list.count;
            [[HTStorageManager sharedInstance] setMascotInfo:mascot withIndex:mascotID];
            callback(true, mascot);
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getUserProps:(HTGetPropsCallback)callback {
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getMascotPropsCGIKey] parameters:@{ @"user_id" : [[HTStorageManager sharedInstance] getUserID] } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage mj_objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            NSMutableArray<HTMascotProp *> *props = [[NSMutableArray alloc] init];
            for (int i = 0; i != [responseObject[@"data"] count]; i++) {
                [props addObject:[HTMascotProp mj_objectWithKeyValues:[responseObject[@"data"] objectAtIndex:i]]];
            }
            callback(true, props);
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)exchangeProps:(HTMascotProp *)prop completion:(HTResponseCallback)callback {
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    
    NSDictionary *paraDict = @{@"user_id" : [[HTStorageManager sharedInstance] getUserID],
                               @"prop_id" : @(prop.prop_id)};
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager exchangePropCGIKey] parameters:paraDict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage mj_objectWithKeyValues:responseObject];
        callback(true, rsp);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getRewardWithID:(uint64_t)rewardID questionID:(uint64_t)qid completion:(HTGetRewardCallback)callback {
    NSDictionary *paraDict = @{@"reward_id" : @(rewardID),
                               @"user_id" : [[HTStorageManager sharedInstance] getUserID],
                               @"qid" : @(qid)};
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getRewardCGIKey] parameters:paraDict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage mj_objectWithKeyValues:responseObject];
        callback(true, rsp);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

@end
