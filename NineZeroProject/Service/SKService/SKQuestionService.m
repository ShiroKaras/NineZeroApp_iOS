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
        DLog(@"HTTP Response Body: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)getRelaxDayInfo:(SKResponseCallback)callback {
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"access_key": SECRET_STRING,
                                 @"action": [SKCGIManager restday_getRestday_Action],
                                 @"user_id": [[SKStorageManager sharedInstance] getUserID],
                                 @"login_token": [[SKStorageManager sharedInstance] getUserToken],
                                 @"city_code": @"010"
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager restdayCGIKey] parameters:bodyObject error:NULL];
    
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
        DLog(@"HTTP Response Body: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
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
