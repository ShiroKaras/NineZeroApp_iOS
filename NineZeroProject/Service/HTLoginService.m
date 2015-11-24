//
//  HTLoginService.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/15.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTLoginService.h"
#import "HTLoginUser.h"
#import <AFNetworking.h>
#import "HTCGIManager.h"
#import "MJExtension.h"
#import "HTLog.h"
#import "HTStorageManager.h"

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

- (void)registerWithUser:(HTLoginUser *)user success:(HTLoginSuccessCallback)successCallback error:(HTLoginErrorCallback)errorCallback {
    NSDictionary *parameters = [user keyValues];
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager userBaseRegisterCGIKey] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        if ([responseObject[@"result"] isEqualToString:@"0"]) {
            NSDictionary *dataDict = responseObject[@"data"];
            [[HTStorageManager sharedInstance] updateUserID:dataDict[@"user_id"]];
            [[HTStorageManager sharedInstance] updatePwdSalt:dataDict[@"user_salt"]];
            [[HTStorageManager sharedInstance] updateLoginUser:user];
        }
        successCallback(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
        errorCallback([NSString stringWithFormat:@"%@", error]);
    }];
}

- (void)loginWithUser:(HTLoginUser *)user success:(HTLoginSuccessCallback)successCallback error:(HTLoginErrorCallback)errorCallback {
    
    NSDictionary *para = @{
                           @"user_name" : user.user_name,
                           @"user_password" : user.user_password
                           };
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager userBaseLoginCGIKey] parameters:para success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        successCallback(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@", error);
        errorCallback([NSString stringWithFormat:@"%@", error]);
    }];
}

- (void)loginWithName:(NSString *)name password:(NSString *)password {

}

- (void)resetPassword:(NSString *)password {
    
}

@end
