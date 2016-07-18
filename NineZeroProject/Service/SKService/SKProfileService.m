//
//  SKProfileService.m
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKProfileService.h"
#import "SKServiceManager.h"

@implementation SKProfileService

#pragma  mark 修改用户名
- (void)updateUsername:(SKUserInfo *)username completion:(SKResponseCallback)callback {
    DLog(@"userid = %@", [[SKStorageManager sharedInstance] getUserID]);
    if ([[SKStorageManager sharedInstance] getUserID]==nil) return;
    
    NSDictionary *param = @{@"access_key": SECRET_STRING,
                            @"login_token":[[SKStorageManager sharedInstance] getUserToken],
                            @"action": [SKCGIManager updateUserName_Action],
                            @"user_id": [[SKStorageManager sharedInstance] getUserID],
                            @"data": @{
                                @"name": username
                                }
                            };
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userBaseInfoCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
        callback(false, nil);
    }];
    
    [manager.operationQueue addOperation:operation];
}

#pragma mark 修改头像
- (void)createUpdateAvatarService:(SKResponseCallback)callback {
    NSDictionary *param = @{@"access_key": SECRET_STRING,
                            @"action": @"new_update_user_avatar",
                            @"login_token": [[SKStorageManager sharedInstance] getUserToken],
                            @"user_id": [[SKStorageManager sharedInstance] getUserID],
                            };
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userBaseInfoCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
        callback(false, nil);
    }];
    
    [manager.operationQueue addOperation:operation];
}

#pragma mark 主页信息

//TODO Success callback
- (void)getProfileInfo:(SKGetProfileInfoCallback)callback {
    DLog(@"userid = %@", [[SKStorageManager sharedInstance] getUserID]);
    if ([[SKStorageManager sharedInstance] getUserID] == nil) return;
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"access_key": SECRET_STRING,
                                 @"user_id": [[SKStorageManager sharedInstance] getUserID],
                                 @"login_token": [[SKStorageManager sharedInstance] getUserToken],
                                 @"action": [SKCGIManager profile_getProfile_Action]
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userProfileCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@",responseObject);
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 0) {
            SKProfileInfo *profileInfo = [SKProfileInfo mj_objectWithKeyValues:package.data];
            if (profileInfo.answer_list.count!=0) {
                NSMutableArray<SKQuestion *> *answerList = [NSMutableArray new];
                NSMutableArray<NSString *> *downloadKeys = [NSMutableArray new];
                for (int i = 0; i != [responseObject[@"data"][@"user_answers"] count]; i++) {
                    @autoreleasepool {
                        SKQuestion *answer = [SKQuestion mj_objectWithKeyValues:[responseObject[@"data"][@"user_answers"] objectAtIndex:i]];
                        answer.isPassed = YES;
                        [answerList addObject:answer];
                        if (answer.videoCoverPic) [downloadKeys addObject:answer.videoCoverPic];
                        if (answer.descriptionPic) [downloadKeys addObject:answer.descriptionPic];
                    }
                }
                //从七牛上获取下载链接
                [[[SKServiceManager sharedInstance] questionService] getQiniuDownloadURLsWithKeys:downloadKeys callback:^(BOOL success, SKResponsePackage *response) {
                    for (SKQuestion *answer in answerList) {
                        @autoreleasepool {
                            NSDictionary *dataDict = response.data;
                            if (answer.videoCoverPic) answer.videoCoverPicURL = dataDict[answer.videoCoverPic];
                            if (answer.descriptionPic) answer.descriptionPicURL = dataDict[answer.descriptionPic];
                        }
                    }
                    profileInfo.answer_list = answerList;
                    [[SKStorageManager sharedInstance] setProfileInfo:profileInfo];
                    callback(true, profileInfo);
                }];
            } else {
                callback(true, profileInfo);
            }
        } else {
            callback(false, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
        callback(false, nil);
    }];
    
    [manager.operationQueue addOperation:operation];
}

#pragma mark 排行榜
- (void)getRankList:(SKGetRankListCallback)callback {
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"top_number": @"500",
                                 @"user_id": [[SKStorageManager sharedInstance] getUserID],
                                 @"access_key": SECRET_STRING,
                                 @"login_token": [[SKStorageManager sharedInstance] getUserToken],
                                 @"action": [SKCGIManager profile_getRankList_Action]
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userRankCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"HTTP Response Body: %@", responseObject);
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            NSMutableArray *rankListArray = [NSMutableArray array];
            for (int i=0; i!=[package.data count]; i++) {
                SKRanker *ranker = [SKRanker mj_objectWithKeyValues:package.data[i]];
                ranker.rank = i+1;
                [rankListArray addObject:ranker];
            }
            callback(true, rankListArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
        callback(false, nil);
    }];
    
    [manager.operationQueue addOperation:operation];
}

#pragma mark 金币记录
- (void)getGoldRecord:(SKGetGoldRecordCallback)callback {

    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"user_id": [[SKStorageManager sharedInstance] getUserID],
                                 @"access_key": SECRET_STRING,
                                 @"login_token": [[SKStorageManager sharedInstance] getUserToken],
                                 @"action": [SKCGIManager profile_getGoldRecords_Action]
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userProfileCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            NSMutableArray<SKGoldRecord *> *goldRecordArray = [NSMutableArray array];
            for (int i=0; i!=[package.data count]; i++) {
                SKGoldRecord *record = [SKGoldRecord mj_objectWithKeyValues:package.data[i]];
                [goldRecordArray addObject:record];
            }
            callback(true, goldRecordArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
        callback(false, nil);
    }];
    
    [manager.operationQueue addOperation:operation];

}

#pragma 文章收藏列表
- (void)getArticleCollectionList:(SKGetArticleListCallback)callback {
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"user_id": [[SKStorageManager sharedInstance] getUserID],
                                 @"access_key": SECRET_STRING,
                                 @"login_token": [[SKStorageManager sharedInstance] getUserToken],
                                 @"action": [SKCGIManager profile_getCollectionAticles_Action]
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userProfileCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"HTTP Response Body: %@", responseObject);
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            //TODO 待接口完善
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
        callback(false, nil);
    }];
    
    [manager.operationQueue addOperation:operation];
}

#pragma 获取消息列表
- (void)getNotificationList:(SKGetNotificationsCallback)callback {
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"user_id": [[SKStorageManager sharedInstance] getUserID],
                                 @"access_key": SECRET_STRING,
                                 @"login_token": [[SKStorageManager sharedInstance] getUserToken],
                                 @"action": [SKCGIManager profile_getNotification_Action]
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager messageCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"HTTP Response Body: %@", responseObject);
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        NSMutableArray<SKNotification *> *notifications = [NSMutableArray array];
        if (package.resultCode == 200) {
            for (NSDictionary *dataDict in package.data) {
                SKNotification *notification = [SKNotification mj_objectWithKeyValues:dataDict];
                [notifications insertObject:notification atIndex:0];
            }
            callback(true, notifications);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
        callback(false, nil);
    }];
    
    [manager.operationQueue addOperation:operation];
}

#pragma mark 获取文章

- (void)getArticle:(NSString *)articleID completion:(SKGetArticleCallback)callback {
    // get Article (POST http://90app-test.daoapp.io/api/article)
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"access_key": SECRET_STRING,
                                 @"article_id": articleID,
                                 @"user_id": [[SKStorageManager sharedInstance] getUserID],
                                 @"login_token": [[SKStorageManager sharedInstance] getUserToken],
                                 @"action": [SKCGIManager article_get_article]
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager articleCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];

}

- (void)getArticlesInPastWithPage:(NSUInteger)page count:(NSUInteger)count callback:(SKGetArticleListCallback)callback {
    
}

- (void)collectArticleWithArticleID:(NSUInteger)articleID completion:(SKResponseCallback)callback {

}

- (void)cancelCollectArticleWithArticleID:(NSUInteger)articleID completion:(SKResponseCallback)callback {

}

- (void)readArticleWithArticleID:(NSUInteger)articleID completion:(SKResponseCallback)callback {
    
}

@end
