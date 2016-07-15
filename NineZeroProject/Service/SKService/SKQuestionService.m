//
//  SKQuestionService.m
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKQuestionService.h"

@implementation SKQuestionService

#pragma mark - 休息日
- (void)getIsRelaxDay:(SKResponseCallback)callback {
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"city_code": @"010",
                                 @"access_key": SECRET_STRING,
                                 @"action": [SKCGIManager restday_isRestday_Action]
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager restdayCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        DLog(@"HTTP Response Body: %@", responseObject);
        callback(true, package);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
        callback(false, nil);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)getRelaxDayInfo:(SKGetRestDayCallback)callback {
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
//    NSDictionary* bodyObject = @{
//                                 @"access_key": SECRET_STRING,
//                                 @"action": [SKCGIManager restday_getRestday_Action],
//                                 @"user_id": [[SKStorageManager sharedInstance] getUserID],
//                                 @"login_token": [[SKStorageManager sharedInstance] getUserToken],
//                                 @"city_code": @"010"
//                                 };
    NSDictionary* bodyObject = @{
                                 @"access_key": SECRET_STRING,
                                 @"action": [SKCGIManager restday_getRestday_Action],
                                 @"user_id": @"6",
                                 @"login_token": @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE0NjkyNzA5NTAsIm5hbWUiOiIiLCJzYWx0IjoiODEzOCIsInVzZXJfaWQiOiI2In0.CMm7FbVG4fOWI4Z4zjsgfcOpuGjgXnmRnF3L5qWR2Cw",
                                 @"city_code": @"010"
                                 };

    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager restdayCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"HTTP Response Body: %@", responseObject);
        SKResponsePackage *rsp = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (rsp.resultCode == 200) {
            callback(true, [SKRestDay mj_objectWithKeyValues:responseObject[@"data"]]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
        callback(false, nil);
    }];
    
    [manager.operationQueue addOperation:operation];
}

#pragma mark - 问题相关

- (void)getQuestionListWithPage:(NSUInteger)page count:(NSUInteger)count callback:(SKQuestionListCallback)callback {
    // Question List (POST http://90app-test.daoapp.io/api/question)
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"access_key": SECRET_STRING,
                                 @"action": [SKCGIManager question_getQuestionList_Action],
                                 @"user_id": [[SKStorageManager sharedInstance] getUserID],
                                 @"login_token": [[SKStorageManager sharedInstance] getUserToken],
                                 @"city_code": @"010",
                                 @"page": [NSString stringWithFormat:@"%lu", (unsigned long)page],
                                 @"page_size": [NSString stringWithFormat:@"%lu", (unsigned long)count]
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager questionCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            NSMutableArray<SKQuestion *> *questions = [[NSMutableArray alloc] init];
            for (int i = 0; i != [responseObject[@"data"] count]; i++) {
                @autoreleasepool {
                    SKQuestion *question = [SKQuestion mj_objectWithKeyValues:[responseObject[@"data"] objectAtIndex:i]];
                    [questions addObject:question];
                }
            }
            callback(true, questions);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
        callback(false, nil);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)getQuestionListSuccessfulWithPage:(NSUInteger)page count:(NSUInteger)count callback:(SKQuestionListCallback)callback {
    // Answer List (POST http://90app-test.daoapp.io/api/question)
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"access_key": SECRET_STRING,
                                 @"action": [SKCGIManager question_getQuestionList_Successful_Action],
                                 @"user_id": [[SKStorageManager sharedInstance] getUserID],
                                 @"login_token": [[SKStorageManager sharedInstance] getUserToken],
                                 @"page": [NSString stringWithFormat:@"%lu", (unsigned long)page],
                                 @"page_size": [NSString stringWithFormat:@"%lu", (unsigned long)count]
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://90app-test.daoapp.io/api/question" parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {                                                                                                                                                          DLog(@"HTTP Response Body: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

#pragma mark - 奖励
- (void)getRewardWithID:(NSUInteger)rewardID questionID:(NSUInteger)qid completion:(SKGetRewardCallback)callback {
    // Reward userid=6 (POST http://90app-test.daoapp.io/api/reward)
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"access_key": SECRET_STRING,
                                 @"city_code": @"010",
                                 @"reward_id": [NSString stringWithFormat:@"%lu", (unsigned long)rewardID],
                                 @"user_id": [[SKStorageManager sharedInstance] getUserID],
                                 @"login_token": [[SKStorageManager sharedInstance] getUserToken],
                                 @"action": [SKCGIManager reward_getReward_Action]
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager rewardCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"HTTP Response Body: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];

}

#pragma mark - 七牛
- (void)getQiniuDownloadURLsWithKeys:(NSArray<NSString *> *)keys callback:(SKResponseCallback)callback {
    if (keys.count == 0) return;
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!dataDict[obj]) {
            [dataDict setObject:obj forKey:obj];
        }
    }];
    NSString *string = [self dictionaryToJson:dataDict];
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQiniuDownloadUrlCGIKey] parameters:@{@"url_array" : string} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        callback(true, [SKResponsePackage mj_objectWithKeyValues:responseObject]);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
