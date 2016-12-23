//
//  SKQuestionService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKQuestionService.h"
#import "SKServiceManager.h"

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
    DLog(@"Json ParamString: %@", jsonString);
    
    NSDictionary *param = @{@"data" : [NSString encryptUseDES:jsonString key:nil]};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager questionBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *desString = [NSString decryptUseDES:responseObject[@"data"] key:nil];
        DLog(@"Response:%@",desString);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:desString];
        callback(YES, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@", error);
        callback(NO, nil);
    }];
}

//全部关卡
- (void)getAllQuestionListCallback:(SKQuestionListCallback)callback {
    NSDictionary *param = @{
                            @"method"   :   @"getList",
                            @"area_id"  :   @"010"
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKQuestion *> *questions_season1 = [[NSMutableArray alloc] init];
        NSMutableArray<SKQuestion *> *questions_season2 = [[NSMutableArray alloc] init];
        for (int i = 0; i != [response.data[@"first_season"] count]; i++) {
            SKQuestion *question = [SKQuestion objectWithKeyValues:[response.data[@"first_season"] objectAtIndex:i]];
            [questions_season1 insertObject:question atIndex:0];
        }
        for (int i = 0; i != [response.data[@"second_season"] count]; i++) {
            SKQuestion *question = [SKQuestion objectWithKeyValues:[response.data[@"second_season"] objectAtIndex:i]];
            [questions_season2 insertObject:question atIndex:0];
        }
        callback (YES, (long)response.data[@"first_season_answered"], (long)response.data[@"second_season_answered"], questions_season1, questions_season2);
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
- (void)getQuestionDetailWithQuestionID:(NSString*)questionID callback:(SKQuestionDetialCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"detail",
                            @"area_id"      :   @"010",
                            @"qid"          :   questionID
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        SKQuestion *question = [SKQuestion objectWithKeyValues:[response.data keyValues]];
        NSMutableArray<NSString *> *downloadKeys = [NSMutableArray array];
        if (question.question_video) [downloadKeys addObject:question.question_video];
        if (question.question_video_cover) [downloadKeys addObject:question.question_video_cover];
        [[[SKServiceManager sharedInstance] commonService] getQiniuDownloadURLsWithKeys:downloadKeys callback:^(BOOL success, SKResponsePackage *response) {
            if (success) {
                if (question.question_video) question.question_video_url = response.data[question.question_video];
                if (question.question_video_cover) question.question_video_cover = response.data[question.question_video_cover];
                callback(success, question);
            } else {
                callback(false, question);
            }
        }];
    }];
}

//关卡线索列表
- (void)getQuestionDetailCluesWithQuestionID:(NSString*)questionID callback:(SKQuestionHintListCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"clueList",
                            @"area_id"      :   @"010",
                            @"qid"          :   questionID
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        SKHintList *hintList = [SKHintList objectWithKeyValues:[response.data keyValues]];
        callback(success, response.result, hintList);
    }];
}

//购买线索
- (void)purchaseQuestionClueWithQuestionID:(NSString*)questionID callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getClue",
                            @"area_id"      :   @"010",
                            @"qid"          :   questionID
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//查看答案
- (void)getQuestionAnswerDetailWithQuestionID:(NSString *)questionID callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getAnswerDetail",
                            @"area_id"      :   @"010",
                            @"qid"          :   questionID
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (void)getQuestionTop10WithQuestionID:(NSString *)questionID callback:(SKQuestionTop10Callback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getTopAnsweredUserList",
                            @"area_id"      :   @"010",
                            @"qid"          :   questionID
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray *rankList = [NSMutableArray array];
        for (int i=0; i<[response.data count]; i++) {
            SKUserInfo *userInfo = [SKUserInfo objectWithKeyValues:response.data[i]];
            [rankList addObject:userInfo];
        }
        callback(success, rankList);
    }];
}

@end
