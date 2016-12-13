//
//  SKQuestionService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKQuestionService.h"

#import "NSString+AES256.h"
#define AES_KEY @"a!dg#8ai@o43ht9s"

@implementation SKQuestionService

- (void)questionBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];// (NSTimeInterval) time = 1427189152.313643
    long long int currentTime=(long long int)time;      //NSTimeInterval返回的是double类型
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setValue:[NSString stringWithFormat:@"%lld",currentTime] forKey:@"time"];
    [mDict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"edition"];
    [mDict setValue:@"iOS" forKey:@"client"];
    [mDict setValue:[[SKStorageManager sharedInstance] getUserID]  forKey:@"user_id"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"data" : jsonString};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager questionBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"Response:%@",responseObject);
        NSString *jsonString = [responseObject[@"data"] aes256_decrypt:AES_KEY];
        //        DLog(@"Method:%@\n%@",dict[@"method"], [jsonString dictionaryWithJsonString]);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        callback(YES, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

//全部关卡
- (void)getAllQuestionListCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"   :   @"getList",
                            @"area_id"  :   @"010"
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];

}

//极难题列表
- (void)getDifficultQuestionListCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"   :   @"difficultProblem",
                            @"area_id"  :   @"010"
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//题目详情
- (void)getQuestionDetailWithQuestionID:(NSString*)questionID callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"detail",
                            @"area_id"      :   @"010",
                            @"question_id"  :   questionID
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//关卡线索列表
- (void)getQuestionDetailCluesWithQuestionID:(NSString*)questionID callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"clueList",
                            @"area_id"      :   @"010",
                            @"question_id"  :   questionID
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//购买线索
- (void)purchaseQuestionClueWithQuestionID:(NSString*)questionID callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"clueList",
                            @"area_id"      :   @"010",
                            @"question_id"  :   questionID
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

@end
