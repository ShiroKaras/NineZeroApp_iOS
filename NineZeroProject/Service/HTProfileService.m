//
//  HTProfileService.m
//  NineZeroProject
//
//  Created by ronhu on 16/3/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfileService.h"
#import "HTLogicHeader.h"

@implementation HTProfileService

- (void)getProfileInfo:(HTGetProfileInfoCallback)callback {
    DLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    
    NSDictionary *dict = @{@"user_id" : [[HTStorageManager sharedInstance] getUserID]};
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getProfileInfoCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getUserInfo:(HTGetUserInfoCallback)callback {
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    NSDictionary *dict = @{@"user_id" : [[HTStorageManager sharedInstance] getUserID]};
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getUserInfoCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)updateUserInfo:(HTUserInfo *)userInfo completion:(HTResponseCallback)callback {
    DLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;

    NSDictionary *dict = @{@"user_id" : [[HTStorageManager sharedInstance] getUserID],
                           @"address" : userInfo.address,
                           @"mobile"  : userInfo.mobile,
                           @"push_setting" : userInfo.push_setting};
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager updateSettingCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            
        } else {
            callback(false, rsp);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];    
}

- (void)getNotifications:(HTGetNotificationsCallback)callback {
    DLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    
    NSDictionary *dict = @{@"user_id" : [[HTStorageManager sharedInstance] getUserID],
                           @"pet_id" : @"1"};
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getUserNoticesCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        NSMutableArray<HTNotification *> *notifications = [NSMutableArray array];
        if (rsp.resultCode == 0) {
            for (NSDictionary *dataDict in rsp.data) {
                HTNotification *notification = [HTNotification objectWithKeyValues:dataDict];
                [notifications addObject:notification];
            }
            callback(true, notifications);
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getRewards:(HTGetRewardsCallback)callback {
    NSLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getUserTicketsCGIKey] parameters:@{ @"user_id" : [[HTStorageManager sharedInstance] getUserID] } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            NSMutableArray *rewards = [NSMutableArray array];
            for (NSDictionary *dataDict in rsp.data) {
                HTReward *reward = [HTReward objectWithKeyValues:dataDict];
                [rewards addObject:reward];
            }
            callback(true, rewards);
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getMyRank:(HTGetMyRankCallback)callback {
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    NSDictionary *dict = @{@"user_id" : [[HTStorageManager sharedInstance] getUserID]};
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getMyRankCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            HTRanker *ranker = [HTRanker objectWithKeyValues:rsp.data];
            callback(true, ranker);
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getRankList:(HTGetRankListCallback)callback {
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getAllRanksCGIKey] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            NSMutableArray<HTRanker *> *rankers = [NSMutableArray array];
            for (NSDictionary *dataDict in rsp.data) {
                HTRanker *ranker = [HTRanker objectWithKeyValues:dataDict];
                [rankers addObject:ranker];
            }
            callback(true, rankers);
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

@end
