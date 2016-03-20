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

- (void)registerWithUser:(HTLoginUser *)user completion:(HTResponseCallback)callback {
    NSDictionary *parameters = [user keyValues];
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager userBaseRegisterCGIKey] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        HTResponsePackage *package = [HTResponsePackage objectWithKeyValues:responseObject];
        if (package.resultCode == 0) {
            NSDictionary *dataDict = package.data;
            [[HTStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[HTStorageManager sharedInstance] updateLoginUser:user];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
        callback(false, nil);
    }];
}

- (void)loginWithUser:(HTLoginUser *)user completion:(HTResponseCallback)callback {
    NSDictionary *para = @{
                           @"user_mobile" : user.user_mobile,
                           @"user_password" : user.user_password
                           };
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager userBaseLoginCGIKey] parameters:para success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        HTResponsePackage *resp = [HTResponsePackage objectWithKeyValues:responseObject];
        callback(true, resp);
        if (resp.resultCode == 0) {
            [[HTStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", responseObject[@"data"][@"user_id"]]];
            [[HTStorageManager sharedInstance] updateLoginUser:user];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@", error);
        callback(false, nil);
    }];
}

- (void)getQiniuPrivateTokenWithCompletion:(HTGetTokenCallback)callback {
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQiniuPrivateUploadTokenCGIKey] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        callback([NSString stringWithFormat:@"%@", responseObject[@"data"]]);
        [[HTStorageManager sharedInstance] updateQiniuToken:responseObject[@"data"]];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(nil);
    }];
}

- (void)getQiniuPublicTokenWithCompletion:(HTGetTokenCallback)callback {
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQiniuPublicUploadTokenCGIKey] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        callback([NSString stringWithFormat:@"%@", responseObject[@"data"]]);
        [[HTStorageManager sharedInstance] setQiniuPublicToken:responseObject[@"data"]];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(nil);
    }];
}

- (void)resetPasswordWithUser:(HTLoginUser *)user completion:(HTResponseCallback)callback
{
    NSDictionary *dict = @{ @"user_mobile" : user.user_mobile,
                            @"user_password" : user.user_password,
                            @"code" : user.code
                            };
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager userBaseResetPwdCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        callback(true, [HTResponsePackage objectWithKeyValues:responseObject]);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (void)verifyMobile:(NSString *)mobile completion:(HTResponseCallback)callback {
    if (mobile.length == 0) return;
    NSDictionary *dict = @{ @"user_mobile" : mobile };
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager userBaseVerifyMobileCGIKey] parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        callback(true, [HTResponsePackage objectWithKeyValues:responseObject]);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (HTLoginUser *)loginUser {
    return [[HTStorageManager sharedInstance] getLoginUser];
}

- (NSString *)qiniuToken {
    return [[HTStorageManager sharedInstance] getQiniuToken];
}

- (void)quitLogin {
    [[HTStorageManager sharedInstance] clearLoginUser];
    [[HTStorageManager sharedInstance] clearUserID];
}

@end
