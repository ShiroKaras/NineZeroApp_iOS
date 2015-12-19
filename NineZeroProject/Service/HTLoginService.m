//
//  HTLoginService.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/15.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTLoginService.h"
#import "HTLogicHeader.h"

@implementation HTLoginService

- (instancetype)init {
    static BOOL hasCreate = NO;
    if (hasCreate == YES) [NSException exceptionWithName:@"手动crash" reason:@"重复创建HTLoginService" userInfo:nil];
    if (self = [super init]) {
        hasCreate = YES;
    }
    return self;
}

#pragma mark - Public Method

- (void)registerWithUser:(HTLoginUser *)user success:(HTHTTPSuccessCallback)successCallback error:(HTHTTPErrorCallback)errorCallback {
    NSDictionary *parameters = [user keyValues];
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager userBaseRegisterCGIKey] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        if ([responseObject[@"result"] integerValue] == 0) {
            NSDictionary *dataDict = responseObject[@"data"];
            [[HTStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[HTStorageManager sharedInstance] updateLoginUser:user];
        }
        successCallback(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
        errorCallback([NSString stringWithFormat:@"%@", error]);
    }];
}

- (void)registerWithUser:(HTLoginUser *)user completion:(HTResponseCallback)callback {
    NSDictionary *parameters = [user keyValues];
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager userBaseRegisterCGIKey] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        if ([responseObject[@"result"] integerValue] == 0) {
            NSDictionary *dataDict = responseObject[@"data"];
            [[HTStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[HTStorageManager sharedInstance] updateLoginUser:user];
        }
        callback(true, [HTResponsePackage objectWithKeyValues:responseObject]);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
        callback(false, nil);
    }];
}

- (void)loginWithUser:(HTLoginUser *)user success:(HTHTTPSuccessCallback)successCallback error:(HTHTTPErrorCallback)errorCallback {
    NSDictionary *para = @{
                           @"user_mobile" : user.user_mobile,
                           @"user_password" : user.user_password
                           };
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager userBaseLoginCGIKey] parameters:para success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        successCallback(responseObject);
        [[HTStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", responseObject[@"data"][@"user_id"]]];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@", error);
        errorCallback([NSString stringWithFormat:@"%@", error]);
    }];
}

- (void)loginWithUser:(HTLoginUser *)user completion:(HTResponseCallback)callback {
    NSDictionary *para = @{
                           @"user_mobile" : user.user_mobile,
                           @"user_password" : user.user_password
                           };
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager userBaseLoginCGIKey] parameters:para success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        callback(true, [HTResponsePackage objectWithKeyValues:responseObject]);
        [[HTStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", responseObject[@"data"][@"user_id"]]];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@", error);
        callback(false, nil);
    }];
}

- (void)getQiniuTokenWithCompletion:(HTGetTokenCallback)callback {
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQiniuTokenCGIKey] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        callback([NSString stringWithFormat:@"%@", responseObject[@"data"]]);
        [[HTStorageManager sharedInstance] updateQiniuToken:responseObject[@"data"]];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(nil);
    }];
}

- (void)resetPassword:(NSString *)password {
    
}

- (HTLoginUser *)loginUser {
    return [[HTStorageManager sharedInstance] getLoginUser];
}

- (NSString *)qiniuToken {
    return [[HTStorageManager sharedInstance] getQiniuToken];
}

@end
