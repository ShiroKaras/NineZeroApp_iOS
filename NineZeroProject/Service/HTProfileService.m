//
//  HTProfileService.m
//  NineZeroProject
//
//  Created by ronhu on 16/3/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfileService.h"
#import "HTLogicHeader.h"
#import "HTServiceManager.h"

@implementation HTProfileService

- (void)getProfileInfo:(HTGetProfileInfoCallback)callback {
    DLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    
    NSDictionary *dict = @{@"user_id" : [[HTStorageManager sharedInstance] getUserID]};
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getProfileInfoCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            HTProfileInfo *profileInfo = [HTProfileInfo objectWithKeyValues:rsp.data];
            callback(true, profileInfo);
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
            HTUserInfo *userInfo = [HTUserInfo objectWithKeyValues:rsp.data];
            callback(true, userInfo);
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

    NSMutableDictionary *paraDict = [@{@"user_id" : [[HTStorageManager sharedInstance] getUserID]} mutableCopy];
    HTUpdateUserInfoType type = (HTUpdateUserInfoType)userInfo.settingType;
    BOOL isAvatarOrName = NO;
    switch (type) {
        case HTUpdateUserInfoTypeAvatar: {
            [paraDict setObject:userInfo.user_avatar forKey:@"user_avatar"];
            isAvatarOrName = YES;
            break;
        }
        case HTUpdateUserInfoTypeName: {
            [paraDict setObject:userInfo.user_name forKey:@"user_name"];
            isAvatarOrName = YES;
            break;
        }
        case HTUpdateUserInfoTypePushSetting: {
            [paraDict setObject:@(userInfo.push_setting) forKey:@"push_setting"];
            break;
        }
        case HTUpdateUserInfoTypeAddressAndMobile: {
            [paraDict setObject:userInfo.address forKey:@"address"];
            [paraDict setObject:userInfo.mobile forKey:@"mobile"];
            break;
        }
    }
    NSString *cgiKey = (isAvatarOrName) ? [HTCGIManager updateUserInfoCGIKey] : [HTCGIManager updateSettingCGIKey];
    [[AFHTTPRequestOperationManager manager] POST:cgiKey parameters:paraDict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            callback(true, rsp);
            [[HTStorageManager sharedInstance] setUserInfo:userInfo];
        } else {
            callback(false, rsp);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)feedbackWithContent:(NSString *)content mobile:(NSString *)mobile completion:(HTResponseCallback)callback {
    NSDictionary *dict = @{@"content" : content,
                           @"contact" : mobile};
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager updateFeedbackCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        callback(true, rsp);
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

- (void)getArticlesInPastWithPage:(NSUInteger)page count:(NSUInteger)count callback:(HTGetArticlesCallback)callback {
    NSDictionary *dict = @{@"page" : @(page),
                           @"count" : @(count)
                           };

    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getArticlesCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        NSMutableArray<HTArticle *> *articles = [NSMutableArray array];
        if (rsp.resultCode == 0) {
            for (NSDictionary *dataDict in rsp.data) {
                HTArticle *article = [HTArticle objectWithKeyValues:dataDict];
                [articles addObject:article];
            }
            callback(true, articles);
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getCollectArticlesWithPage:(NSUInteger)page count:(NSUInteger)count callback:(HTGetArticlesCallback)callback {
    DLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    
    NSDictionary *dict = @{@"user_id" : [[HTStorageManager sharedInstance] getUserID],
                           @"page" : @(page),
                           @"count" : @(count)
                           };

    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getCollectArticlesCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        NSMutableArray<HTArticle *> *articles = [NSMutableArray array];
        if (rsp.resultCode == 0) {
            for (NSDictionary *dataDict in rsp.data) {
                HTArticle *article = [HTArticle objectWithKeyValues:dataDict];
                [articles addObject:article];
            }
            callback(true, articles);
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getBadges:(HTGetBadgesCallback)callback {
    NSLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getBadgesCGIKey] parameters:@{ @"user_id" : [[HTStorageManager sharedInstance] getUserID] } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            NSMutableArray *badges = [NSMutableArray array];
            for (NSDictionary *dataDict in rsp.data) {
                HTBadge *badge = [HTBadge objectWithKeyValues:dataDict];
                [badges addObject:badge];
            }
            callback(true, badges);
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
