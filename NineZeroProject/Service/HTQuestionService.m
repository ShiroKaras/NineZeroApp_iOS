//
//  HTQuestionService.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTQuestionService.h"
#import "HTLogicHeader.h"
#import "HTStorageManager.h"
#import "HTServiceManager.h"

@implementation HTQuestionService {
    HTLoginUser *_loginUser;
}

- (instancetype)init {
    static BOOL hasCreate = NO;
    if (hasCreate == YES) [NSException exceptionWithName:@"手动crash" reason:@"重复创建HTQuestionService" userInfo:nil];
    if (self = [super init]) {
        hasCreate = YES;
    }
    return self;
}

#pragma mark - Public Method

- (void)setLoginUser:(HTLoginUser *)loginUser {
    _loginUser = loginUser;
}

- (void)getQuestionInfoWithCallback:(HTQuestionInfoCallback)callback {
    NSDictionary *dict = @{@"area_id" : @"1"};
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQuestionInfoCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            HTQuestionInfo *questionInfo = [HTQuestionInfo objectWithKeyValues:responseObject[@"data"]];
            callback(YES, questionInfo);
        } else {
            callback(NO, nil);
        }
        DLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)getQuestionListWithPage:(NSUInteger)page count:(NSUInteger)count callback:(HTQuestionListCallback)callback {
    NSDictionary *dict = @{@"area_id" : @"1",
                           @"page"    : [NSString stringWithFormat:@"%lud", (unsigned long)page],
                           @"count"   : [NSString stringWithFormat:@"%lud", (unsigned long)count]
                           };
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQuestionListCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HTResponsePackage *rsp = [HTResponsePackage objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            NSMutableArray<HTQuestion *> *questions = [[NSMutableArray alloc] init];
            NSMutableArray<NSString *> *downloadKeys = [NSMutableArray array];
            for (int i = 0; i != [responseObject[@"data"] count]; i++) {
                HTQuestion *question = [HTQuestion objectWithKeyValues:[responseObject[@"data"] objectAtIndex:i]];
                [questions addObject:question];
                [downloadKeys addObject:question.videoName];
                [downloadKeys addObject:question.descriptionPic];
            }
            [self getQiniuDownloadURLsWithKeys:downloadKeys callback:^(BOOL success, HTResponsePackage *response) {
                if (success) {
                    for (HTQuestion *question in questions) {
                        NSDictionary *dataDict = response.data;
                        question.descriptionURL = dataDict[question.descriptionPic];
                        question.videoURL = dataDict[question.videoName];
                    }
                    [[[HTServiceManager sharedInstance] profileService] getProfileInfo:^(BOOL success, HTProfileInfo *profileInfo) {
                        if (success) {
                            for (HTProfileAnswer *answer in profileInfo.answer_list) {
                                for (HTQuestion *question in questions) {
                                    if (answer.qid == question.questionID) {
                                        question.isPassed = YES;
                                    } else {
                                        question.isPassed = NO;
                                    }
                                }
                            }
                            callback(YES, questions);
                        } else {
                            callback(false, questions);
                        }
                    }];
                } else {
                    callback(false, nil);
                }
            }];
        } else {
            callback(NO, nil);
        }
        DLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)getQuestionDetailWithQuestionID:(NSUInteger)questionID callback:(HTQuestionCallback)callback {
    NSDictionary *dict = @{@"question_id" : [NSString stringWithFormat:@"%ld", (unsigned long)questionID]};
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQuestionDetailCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        callback(YES, [HTQuestion objectWithKeyValues:responseObject[@"data"]]);
        DLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)verifyQuestion:(NSUInteger)questionID withAnswer:(NSString *)answer callback:(HTResponseCallback)callback {
    NSString *user_id = [[HTStorageManager sharedInstance] getUserID];
    if (user_id.length == 0) {
        callback(false, nil);
        return;
    }
    NSDictionary *dict = @{
                           @"user_id" : user_id,
                           @"question_id" : [NSString stringWithFormat:@"%ld", (unsigned long)questionID],
                           @"answer" : answer
                           };
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager verifyAnswerCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        callback(YES, [HTResponsePackage objectWithKeyValues:responseObject]);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)getQiniuDownloadURLsWithKeys:(NSArray<NSString *> *)keys callback:(HTResponseCallback)callback {
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
        callback(true, [HTResponsePackage objectWithKeyValues:responseObject]);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)getRelaxDayInfo:(HTResponseCallback)callback {
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getRelaxDayInfoCGIKey] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        callback(YES, [HTResponsePackage objectWithKeyValues:responseObject]);
        DLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)getIsRelaxDay:(HTResponseCallback)callback {
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getIsMondayCGIKey] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        callback(YES, [HTResponsePackage objectWithKeyValues:responseObject]);
        DLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

@end
