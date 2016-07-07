//
//  HTProfileService.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/14.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTProfileService.h"
#import "HTLogicHeader.h"
#import "HTServiceManager.h"

@implementation HTProfileService

- (void)backupUserInfoWithDict:(NSDictionary*)dict callback:(SKBackupUserInfoCallBack)callback {
    [[AFHTTPRequestOperationManager manager] POST:@"http://90server.daoapp.io/api/user_info_backup" parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

- (void)getbackupUserInfo:(SKBackupUserInfoCallBack)callback {
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    [bodyDict setObject:@"90app529D" forKey:@"access_token"];
    
    NSMutableDictionary *baseInfo = [NSMutableDictionary new];
    if ([[HTStorageManager sharedInstance] getLoginUser].user_mobile != nil && ![[[HTStorageManager sharedInstance] getLoginUser].user_mobile isEqualToString:@""])
        [baseInfo setObject:[[HTStorageManager sharedInstance] getLoginUser].user_mobile forKey:@"mobile"];
    if ([[HTStorageManager sharedInstance] getLoginUser].user_password != nil && ![[[HTStorageManager sharedInstance] getLoginUser].user_password isEqualToString:@""])
        [baseInfo setObject:[[HTStorageManager sharedInstance] getLoginUser].user_password forKey:@"password"];
    if ([[HTStorageManager sharedInstance] getLoginUser].third_id != nil && ![[[HTStorageManager sharedInstance] getLoginUser].third_id isEqualToString:@""])
        [baseInfo setObject:[[HTStorageManager sharedInstance] getLoginUser].third_id forKey:@"third_id"];
    
    //获取基本信息（user_name push_setting user_avatar）
    [[[HTServiceManager sharedInstance] profileService] getUserInfo:^(BOOL success, HTUserInfo *userInfo) {
        if (success) {
            [baseInfo setObject:userInfo.user_name forKey:@"username"];
            [baseInfo setValue:@(userInfo.push_setting) forKey:@"push_setting"];
            if (userInfo.user_avatar != nil && ![userInfo.user_avatar isEqualToString:@""]) {
                [baseInfo setObject:userInfo.user_avatar forKey:@"user_avatar"];
            }
            
            //获取用户闯关数据
            [[[HTServiceManager sharedInstance] profileService] getProfileInfo:^(BOOL success, HTProfileInfo *profileInfo) {
                if (success) {
                    [baseInfo setObject:@([profileInfo.gold integerValue]) forKey:@"gold"];
                    NSMutableArray *answer_list = [NSMutableArray array];
                    for (HTQuestion *question in profileInfo.answer_list) {
                        [answer_list addObject:@{@"serial":@(question.serial), @"use_time":@(question.use_time)}];
                    }
                    
                    //获取用户收藏文章
                    [[[HTServiceManager sharedInstance] profileService] getCollectArticlesWithPage:0 count:0 callback:^(BOOL success, NSArray<HTArticle *> *articles) {
                        if (success) {
                            NSMutableArray *article_collections = [NSMutableArray array];
                            for (HTArticle *article in articles) {
                                [article_collections addObject:@{@"article_title":article.articleTitle, @"pet_id":@(article.mascotID)}];
                            }
                            [dataDict setObject:baseInfo forKey:@"base_info"];
                            [dataDict setObject:answer_list forKey:@"answer_list"];
                            [dataDict setObject:article_collections forKey:@"article_collections"];
                            [bodyDict setObject:dataDict forKey:@"data"];
                            callback(YES, bodyDict);
                        } else {
                            callback(NO, nil);
                        }
                    }];
                } else {
                    callback(NO, nil);
                }
            }];
        } else {
            callback(NO, nil);
        }
    }];
}



- (void)getProfileInfo:(HTGetProfileInfoCallback)callback {
    DLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    
    NSDictionary *dict = @{@"user_id" : [[HTStorageManager sharedInstance] getUserID]};
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getProfileInfoCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            HTProfileInfo *profileInfo = [HTProfileInfo objectWithKeyValues:rsp.data];
            if (profileInfo.answer_list.count!=0) {
                NSMutableArray<HTQuestion *> *answerList = [NSMutableArray new];
                NSMutableArray<NSString *> *downloadKeys = [NSMutableArray new];
                for (int i = 0; i != [responseObject[@"data"][@"answer_list"] count]; i++) {
                    @autoreleasepool {
                        HTQuestion *answer = [HTQuestion objectWithKeyValues:[responseObject[@"data"][@"answer_list"] objectAtIndex:i]];
                        answer.isPassed = YES;
                        [answerList addObject:answer];
                        if (answer.question_video_cover) [downloadKeys addObject:answer.question_video_cover];
                        if (answer.descriptionPic) [downloadKeys addObject:answer.descriptionPic];
                        if (answer.videoName) [downloadKeys addObject:answer.videoName];
                    }
                }
                //从七牛上获取下载链接
                [[[HTServiceManager sharedInstance] questionService] getQiniuDownloadURLsWithKeys:downloadKeys callback:^(BOOL success, HTResponsePackage *response) {
                    for (HTQuestion *answer in answerList) {
                        @autoreleasepool {
                            NSDictionary *dataDict = response.data;
                            if (answer.question_video_cover) answer.question_video_cover = dataDict[answer.question_video_cover];
                            if (answer.descriptionPic) answer.descriptionURL = dataDict[answer.descriptionPic];
                            if (answer.videoName) answer.videoURL = dataDict[answer.videoName];
                        }
                    }
                    profileInfo.answer_list = answerList;
                    [[HTStorageManager sharedInstance] setProfileInfo:profileInfo];
                    callback(true, profileInfo);
                }];
            } else {
                callback(true, profileInfo);
            }
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

- (void)updateUserInfoFromSvr {
    [self getUserInfo:^(BOOL success, HTUserInfo *userInfo) {
        if (success) {
            [[HTStorageManager sharedInstance] setUserInfo:userInfo];
        }
    }];
}

- (void)updateProfileInfoFromServer {
    [self getProfileInfo:^(BOOL success, HTProfileInfo *profileInfo) {
        if (success) {
            [[HTStorageManager sharedInstance] setProfileInfo:profileInfo];
        }
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
        HTNotification *firstNotification = [HTNotification objectWithKeyValues:
        @{
            @"time": @"0",
            @"content": @"欢迎加入“九零”，你已经被零仔锁定，现在，你可以通过这里帮助九零发现更大的世界！"
        }];
        [notifications addObject:firstNotification];
        if (rsp.resultCode == 0) {
            for (NSDictionary *dataDict in rsp.data) {
                HTNotification *notification = [HTNotification objectWithKeyValues:dataDict];
                [notifications insertObject:notification atIndex:0];
            }
            [UD setInteger:notifications.count forKey:@"notificationsHasReadKey"];
            callback(true, notifications);
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getRewards:(HTGetRewardsCallback)callback {
    DLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getUserTicketsCGIKey] parameters:@{ @"user_id" : [[HTStorageManager sharedInstance] getUserID] } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            NSMutableArray *rewards = [NSMutableArray array];
            for (NSDictionary *dataDict in rsp.data) {
                HTTicket *reward = [HTTicket objectWithKeyValues:dataDict];
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
    if ([[HTStorageManager sharedInstance] getUserID]==nil) return;
    NSDictionary *dict = @{@"user_id"   : [[HTStorageManager sharedInstance] getUserID],
                           @"page"      : @(page),
                           @"count"     : @(count)
                           };

    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getArticlesCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        NSMutableArray<HTArticle *> *articles = [NSMutableArray array];
        if (rsp.resultCode == 0) {
            for (NSDictionary *dataDict in rsp.data) {
                HTArticle *article = [HTArticle objectWithKeyValues:dataDict];
//                [articles addObject:article];
                [articles insertObject:article atIndex:0];
            }
            callback(true, articles);
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getArticle:(uint64_t)articleID completion:(HTGetArticleCallback)callback {
    NSDictionary *dict;
    if ([[HTStorageManager sharedInstance] getUserID]){
        dict = @{@"article_id"  :   @(articleID),
                 @"user_id"     :   [[HTStorageManager sharedInstance] getUserID]};
    }else{
        dict = @{@"article_id"  :   @(articleID)};
    }
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getArticleCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        HTArticle *article = [HTArticle objectWithKeyValues:rsp.data];
        if (rsp.data) {
            article = [HTArticle objectWithKeyValues:rsp.data];
        }
        callback(true, article);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getCollectArticlesWithPage:(NSUInteger)page count:(NSUInteger)count callback:(HTGetArticlesCallback)callback {
    DLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    
    NSDictionary *dict = @{@"user_id"   : [[HTStorageManager sharedInstance] getUserID],
                           @"page"      : @(page),
                           @"count"     : @(count)
                           };

    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getCollectArticlesCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        NSMutableArray<HTArticle *> *articles = [NSMutableArray array];
        if (rsp.resultCode == 0) {
            for (NSDictionary *dataDict in rsp.data) {
                HTArticle *article = [HTArticle objectWithKeyValues:dataDict];
                article.is_collect = YES;
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

- (void)readArticleWithArticleID:(NSUInteger)articleID completion:(HTResponseCallback)callback {
    if ([[HTStorageManager sharedInstance] getUserID]==nil) return;
    NSDictionary *dict = @{@"article_id"  :   @(articleID),
                           @"user_id"     :   [[HTStorageManager sharedInstance] getUserID]};
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager readArticleCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        callback(true, rsp);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)getBadges:(HTGetBadgesCallback)callback {
    DLog(@"userid = %@", [[HTStorageManager sharedInstance] getUserID]);
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
//        DLog(@"%@",responseObject);
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

- (void)collectArticleWithArticleID:(NSUInteger)articleID completion:(HTResponseCallback)callback {
    if ([[HTStorageManager sharedInstance] getUserID] == nil) return;
    NSDictionary *dict = @{@"user_id" : [[HTStorageManager sharedInstance] getUserID],
                           @"article_id" : @(articleID)};
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager collectArticleCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        callback(true, rsp);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

@end
