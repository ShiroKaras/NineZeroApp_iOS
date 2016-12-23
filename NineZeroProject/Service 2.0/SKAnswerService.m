//
//  SKAnswerService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKAnswerService.h"

@implementation SKAnswerService

- (void)answerBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];// (NSTimeInterval) time = 1427189152.313643
    long long int currentTime=(long long int)time;      //NSTimeInterval返回的是double类型
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setValue:[NSString stringWithFormat:@"%lld",currentTime] forKey:@"time"];
    [mDict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"edition"];
    [mDict setValue:@"iOS" forKey:@"client"];
    [mDict setValue:[[SKStorageManager sharedInstance] getUserID] forKey:@"user_id"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DLog(@"Param:%@", jsonString);
    NSDictionary *param = @{@"data" : [NSString encryptUseDES:jsonString key:nil]};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager answerBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *desString = [NSString decryptUseDES:responseObject[@"data"] key:nil];
        DLog(@"Response:%@",desString);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:desString];
        callback(YES, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@", error);
        callback(NO, nil);
    }];
}

//限时关卡文字题答题接口
- (void)answerTimeLimitTextQuestionWithAnswerText:(NSString*)answerText callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"   :   @"answerText",
                            @"answer"   :   answerText
                            };
    [self answerBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//往期关卡答题接口
- (void)answerExpiredTextQuestionWithQuestionID:(NSString*)questionID answerText:(NSString*)answerText callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"   :   @"answerOldText",
                            @"qid"      :   questionID,
                            @"answer"   :   answerText
                            };
    [self answerBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//使用道具答题
- (void)answerExpiredTextQuestionWithQuestionID:(NSString*)questionID answerPropsCount:(NSString*)answerPropsCount callback:(SKResponseCallback)callback {
    if ([answerPropsCount integerValue] == 0) return;
    
    NSDictionary *param = @{
                            @"method"       :   @"answerOldText",
                            @"qid"          :   questionID,
                            @"answer_prop"  :   @"answer_prop"
                            };
    [self answerBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//限时关卡LBS题答题接口
- (void)answerLBSQuestionWithLocation:(CLLocation*)location callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"answerAR",
                            @"lat"          :   [NSString stringWithFormat:@"%f",location.coordinate.latitude],
                            @"lng"          :   [NSString stringWithFormat:@"%f",location.coordinate.longitude],
                            };
    [self answerBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//限时关卡扫描图片答题接口
- (void)answerScanningARWithQuestionID:(NSString*)questionID callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"answerScanningAR",
                            @"qid"          :   questionID,
                            @"area_id"      :   AppDelegateInstance.cityCode
                            };
    [self answerBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//极难题答题接口
- (void)answerDifficultQuestionWithQuestionID:(NSString*)questionID answerText:(NSString*)answerText callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"answerDifficultyText",
                            @"qid"          :   questionID,
                            @"answer"       :   answerText
                            };
    [self answerBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//获取奖励
- (void)getRewardWithQuestionID:(NSString *)questionID rewardID:(NSString*)rewardID callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"checkReward",
                            @"qid"          :   questionID,
                            @"reward_id"    :   rewardID
                            };
    [self answerBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

@end
