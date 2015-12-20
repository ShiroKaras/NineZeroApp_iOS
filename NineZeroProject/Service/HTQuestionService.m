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
        HTQuestionInfo *questionInfo = [HTQuestionInfo objectWithKeyValues:responseObject[@"data"]];
        callback(YES, questionInfo);
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
        NSMutableArray<HTQuestion *> *questions = [[NSMutableArray alloc] init];
        for (int i = 0; i != [responseObject[@"data"] count]; i++) {
            [questions addObject:[HTQuestion objectWithKeyValues:[responseObject[@"data"] objectAtIndex:i]]];
        }
        callback(YES, questions);
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
    } else {
    }
    NSDictionary *dict = @{
                           @"user_id" : user_id,
                           @"question_id" : [NSString stringWithFormat:@"%ld", (unsigned long)questionID],
                           @"answer" : answer
                           };
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager verifyAnswerCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        callback(YES, [HTResponsePackage objectWithKeyValues:responseObject]);
        DLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)getQiniuDownloadURLWithKey:(NSString *)key callback:(HTResponseCallback)callback {
    if (key.length == 0) return;
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQiniuDownloadUrlCGIKey] parameters:@{ @"key" : key } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        callback(true, [HTResponsePackage objectWithKeyValues:responseObject]);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

@end
