//
//  HTQuestionService.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTQuestionService.h"
#import "HTLogicHeader.h"

@implementation HTQuestionService

- (instancetype)init {
    static BOOL hasCreate = NO;
    if (hasCreate == YES) [NSException exceptionWithName:@"手动crash" reason:@"重复创建HTLoginService" userInfo:nil];
    if (self = [super init]) {
        hasCreate = YES;
    }
    return self;
}

#pragma mark - Public Method

- (void)getQuestionInfoWithCallback:(HTNetworkCallback)callback {
    NSDictionary *dict = @{@"area_id" : @"1"};
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQuestionInfoCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        callback(YES, responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
    }];
}

- (void)getQuestionListWithPage:(NSUInteger)page count:(NSUInteger)count callback:(HTNetworkCallback)callback {
    NSDictionary *dict = @{@"area_id" : @"1",
                           @"page"    : [NSString stringWithFormat:@"%ld", page],
                           @"count"   : [NSString stringWithFormat:@"%ld", count]
                           };
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQuestionListCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        callback(YES, responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
    }];
}

- (void)getQuestionDetailWithQuestionID:(NSUInteger)questionID callback:(HTNetworkCallback)callback {
    NSDictionary *dict = @{@"qid" : @"2015120423201902904"};
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQuestionDetailCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        callback(YES, responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
    }];
}

@end
