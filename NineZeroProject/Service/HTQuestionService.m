//
//  HTQuestionService.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/12/9.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTQuestionService.h"
#import "HTLogicHeader.h"
#import "HTStorageManager.h"
#import "HTServiceManager.h"

@implementation HTQuestionService {
    HTLoginUser *_loginUser;
    NSMutableArray<HTQuestion *> *_questionListSuccessful;
    NSMutableArray<HTQuestion *> *_questionList;
    HTQuestionInfo *_questionInfo;
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
    NSDictionary *dict = @{@"area_id" : AppDelegateInstance.cityCode};
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQuestionInfoCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HTResponsePackage *rsp = [HTResponsePackage mj_objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            HTQuestionInfo *questionInfo = [HTQuestionInfo mj_objectWithKeyValues:responseObject[@"data"]];
            _questionInfo = questionInfo;
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

- (HTQuestionInfo *)questionInfo {
    return _questionInfo;
}

- (void)getQuestionListWithPage:(NSUInteger)page count:(NSUInteger)count callback:(HTQuestionListCallback)callback {
    NSDictionary *dict = @{@"area_id" : AppDelegateInstance.cityCode,
                           @"page"    : @(0) /* 全量拉取 */,
                           @"count"   : [NSString stringWithFormat:@"%lud", (unsigned long)count]
                           };
    // 1. 取全部题目
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQuestionListCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HTResponsePackage *rsp = [HTResponsePackage mj_objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            NSMutableArray<HTQuestion *> *questions = [[NSMutableArray alloc] init];
            NSMutableArray<NSString *> *downloadKeys = [NSMutableArray array];
            for (int i = 0; i != [responseObject[@"data"] count]; i++) {
                @autoreleasepool {
                    HTQuestion *question = [HTQuestion mj_objectWithKeyValues:[responseObject[@"data"] objectAtIndex:i]];
                    [questions insertObject:question atIndex:0]; // UI需要反向
                    if (question.videoName) [downloadKeys addObject:question.videoName];
                    if (question.descriptionPic) [downloadKeys addObject:question.descriptionPic];
                    if (question.question_ar_pet) [downloadKeys addObject:question.question_ar_pet];
                    if (question.question_video_cover) [downloadKeys addObject:question.question_video_cover];
                }
            }
            // 2. 从私有云上取下载链接
            [self getQiniuDownloadURLsWithKeys:downloadKeys callback:^(BOOL success, HTResponsePackage *response) {
                if (success) {
                    for (HTQuestion *question in questions) {
                        @autoreleasepool {
                            NSDictionary *dataDict = response.data;
                            if (question.descriptionPic) question.descriptionURL = dataDict[question.descriptionPic];
                            if (question.videoName) question.videoURL = dataDict[question.videoName];
                            if (question.question_video_cover) question.question_video_cover = dataDict[question.question_video_cover];
                            if (question.question_ar_pet) question.question_ar_pet = dataDict[question.question_ar_pet];
                        }
                    }
                    // 3. 找到哪些问题已经回答成功
                    [[[HTServiceManager sharedInstance] profileService] getProfileInfo:^(BOOL success, HTProfileInfo *profileInfo) {
                        if (success) {
                            _questionListSuccessful = [NSMutableArray array];
                            for (HTQuestion *question in questions) {
                                question.isPassed = NO;
                                for (HTQuestion *answer_question in profileInfo.answer_list) {
                                    answer_question.isPassed = YES;
                                    if (answer_question.questionID == question.questionID) {
                                        question.isPassed = YES;
                                    }
                                }
                            }
                            for (HTQuestion *answer_question in profileInfo.answer_list) {
                                [_questionListSuccessful addObject:answer_question];
                            }
                            _questionList = questions;
                            callback(YES, questions);
                        } else {
                            _questionList = questions;
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

- (NSArray<HTQuestion *> *)questionListSuccessful {
    return _questionListSuccessful;
}

- (NSArray<HTQuestion *> *)questionList {
    return _questionList;
}

- (void)getQuestionDetailWithQuestionID:(uint64_t)questionID callback:(HTQuestionCallback)callback {
    NSDictionary *dict = @{@"question_id" : [NSString stringWithFormat:@"%llu", questionID],
                           @"area_id" : AppDelegateInstance.cityCode,
                           @"user_id" : [[HTStorageManager sharedInstance] getUserID]};
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQuestionDetailCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        callback(YES, [HTQuestion mj_objectWithKeyValues:responseObject[@"data"]]);
        DLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)getAnswerDetailWithQuestionID:(NSString *)questionID callback:(HTAnswerDetailInfoCallback)callback {
    NSDictionary *dict = @{@"question_id" : questionID,
                           @"area_id" : AppDelegateInstance.cityCode,
                           @"user_id" : [[HTStorageManager sharedInstance] getUserID]};
    DLog(@"%@", dict);
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getAnswerDetailCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HTResponsePackage *rsp = [HTResponsePackage mj_objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            HTAnswerDetail *answerDetail = [HTAnswerDetail mj_objectWithKeyValues:responseObject[@"data"]];
            callback (YES, answerDetail);
        } else {
            callback(NO, nil);
        }
        DLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)getRankListWithQuestion:(uint64_t)questionID callback:(HTResponseCallback)callback {
    NSDictionary *dict = @{@"qid" : [NSString stringWithFormat:@"%llu", questionID]};
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getAnswerDetailCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HTResponsePackage *package = [HTResponsePackage objectWithKeyValues:responseObject];
        if (package.resultCode == 0) {
            callback(YES,package);
        } else {
            callback(NO, nil);
        }
        DLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)verifyQuestion:(uint64_t)questionID withAnswer:(NSString *)answer callback:(HTResponseCallback)callback {
    NSString *user_id = [[HTStorageManager sharedInstance] getUserID];
    if (user_id.length == 0) {
        callback(false, nil);
        return;
    }
    NSDictionary *dict = @{
                           @"user_id" : user_id,
                           @"question_id" : [NSString stringWithFormat:@"%llu", questionID],
                           @"answer" : answer
                           };
    
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager verifyAnswerCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        HTResponsePackage *rsp = [HTResponsePackage mj_objectWithKeyValues:responseObject];
        if (rsp.resultCode == 0) {
            [self getQuestionDetailWithQuestionID:questionID callback:^(BOOL success, HTQuestion *question) {
                if (success) {
                    // 回答成功的问题加入回答成功的列表中
                    __block BOOL isFound = NO;
                    [_questionListSuccessful enumerateObjectsUsingBlock:^(HTQuestion * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.questionID == questionID) {
                            isFound = YES;
                            *stop = YES;
                        }
                    }];
                    // 已经在回答成功的列表中的问题不需要重复添加
                    if (!isFound) {
                        HTQuestion *question = [self findQuestionInQuestionList:questionID];
                        if (question) {
                            question.isPassed = YES;
                            if (rsp.data[@"reward_id"]) {
                                question.rewardID = [[NSString stringWithFormat:@"%@", rsp.data[@"reward_id"]] integerValue];
                            }
                            [_questionListSuccessful addObject:question];
                        }
                    }
                    callback(YES, rsp);
                } else {
                    callback(NO, rsp);
                }
            }];
        } else {
            callback(NO, rsp);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)verifyQuestion:(uint64_t)questionID withLocation:(CGPoint)location callback:(HTResponseCallback)callback {
    NSDictionary *dataDict = @{@"area_id" : AppDelegateInstance.cityCode,
                               @"question" : @(questionID),
                               @"lng" : @(location.x),
                               @"lat" : @(location.y),
                               @"user_id" : [[HTStorageManager sharedInstance] getUserID]};
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager verifyLocationCGIKey] parameters:dataDict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        HTResponsePackage *rsp = [HTResponsePackage mj_objectWithKeyValues:responseObject];
        // 回答成功的问题加入回答成功的列表中
        __block BOOL isFound = NO;
        [_questionListSuccessful enumerateObjectsUsingBlock:^(HTQuestion * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.questionID == questionID) {
                isFound = YES;
                *stop = YES;
            }
        }];
        // 已经在回答成功的列表中的问题不需要重复添加
        if (!isFound) {
            HTQuestion *question = [self findQuestionInQuestionList:questionID];
            if (question) {
                question.isPassed = YES;
                if (rsp.data[@"reward_id"]) {
                    question.rewardID = [[NSString stringWithFormat:@"%@", rsp.data[@"reward_id"]] integerValue];
                }
                [_questionListSuccessful addObject:question];
            }
        }
        DLog(@"%@", responseObject);
        callback(YES, rsp);
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
        callback(true, [HTResponsePackage mj_objectWithKeyValues:responseObject]);
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
        DLog(@"%@",responseObject);
        callback(YES, [HTResponsePackage mj_objectWithKeyValues:responseObject]);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)getIsRelaxDay:(HTResponseCallback)callback {
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getIsMondayCGIKey] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        callback(YES, [HTResponsePackage mj_objectWithKeyValues:responseObject]);
        DLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)getCoverPicture:(HTResponseCallback)callback {
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getCoverPictureCGIKey] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        callback(YES, [HTResponsePackage mj_objectWithKeyValues:responseObject]);
        DLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (HTQuestion *)findQuestionInQuestionList:(uint64_t)questionID {
    __block HTQuestion *question;
    [_questionList enumerateObjectsUsingBlock:^(HTQuestion * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (questionID == obj.questionID) {
            question = obj;
            obj.isPassed = YES;
            *stop = YES;
        }
    }];
    return question;
}

@end
