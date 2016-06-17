//
//  SKLoginService.m
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKLoginService.h"
#import "HTLogicHeader.h"

const NSString *secretSting = @"90app529D";

@implementation SKLoginService

- (instancetype)init {
    static BOOL hasCreate = NO;
    if (hasCreate == YES) [NSException exceptionWithName:@"手动crash" reason:@"重复创建HTLoginService" userInfo:nil];
    if (self = [super init]) {
        hasCreate = YES;
    }
    return self;
}

#pragma mark - Public Method

- (void)loginWithUser:(HTLoginUser *)user completion:(SKResponseCallback)callback {
    NSDictionary *param = @{@"access_key"           : secretSting,
                            @"action"               : [SKCGIManager login_Phonenumber_Action],
                            @"mobile_phone_number"  : user.user_mobile,
                            @"password"             : user.user_password};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager userBaseLoginCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            NSDictionary *dataDict = package.data;
            [[HTStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[HTStorageManager sharedInstance] updateUserToken:[NSString stringWithFormat:@"%@", dataDict[@"token"]]];
            [[HTStorageManager sharedInstance] updateLoginUser:user];
        }
        callback(true, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
        callback(false, nil);
    }];
}

- (void)bindUserWithThirdPlatform:(HTLoginUser *)user completion:(SKResponseCallback)callback {
    NSDictionary *param = @{@"access_key"           : secretSting,
                            @"action"               : [SKCGIManager login_ThirdPlatform_Action],
                            @"mobile_phone_number"  : user.user_mobile,
                            @"password"             : user.user_password};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager userBaseLoginCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            NSDictionary *dataDict = package.data;
            [[HTStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[HTStorageManager sharedInstance] updateUserToken:[NSString stringWithFormat:@"%@", dataDict[@"token"]]];
            [[HTStorageManager sharedInstance] updateLoginUser:user];
        }
        callback(true, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
        callback(false, nil);
    }];
}

- (void)createRegisterService:(SKResponseCallback)callback {
    NSDictionary *param = @{@"access_key"   : secretSting,
                            @"action"       : [SKCGIManager register_newService_Action]};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager userBaseRegisterCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            callback(true, package);
        }else
            callback(false, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
        callback(false, nil);
    }];
}

- (void)getRegisterVerifyCodeWithMobile:(NSString *)mobile token:(NSString *)token completion:(SKResponseCallback)callback {
    if (mobile.length == 0) return;
    NSDictionary *param = @{@"access_key"   : secretSting,
                            @"action"       : [SKCGIManager register_sendVerificationCode_Action],
                            @"action_token" : token,
                            @"phone"        : mobile};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager userBaseRegisterCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
        callback(false, nil);
    }];
}

- (void)checkRegisterVerifyCodeWithPhone:(NSString *)mobile token:(NSString *)token code:(NSString *)code completion:(SKResponseCallback)callback {
    if (mobile.length == 0) return;
    NSDictionary *param = @{@"access_key"       : secretSting,
                            @"action"           : [SKCGIManager register_sendVerificationCode_Action],
                            @"action_token"     : token,
                            @"phone"            : mobile,
                            @"verification_code": code};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager userBaseRegisterCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
        callback(false, nil);
    }];
}

- (void)registerWithUser:(HTLoginUser *)user token:(NSString *)token completion:(SKResponseCallback)callback {
    if (user.user_name.length == 0)     return;
    if (user.user_password.length == 0) return;
    if (user.user_mobile.length == 0)   return;
    
    NSDictionary *data  =  @{@"name"       :   user.user_name,
                             @"phone"      :   user.user_mobile,
                             @"password"   :   user.user_password
                             };
    NSDictionary *param = @{@"access_key"   : secretSting,
                            @"action"       : [SKCGIManager register_sendVerificationCode_Action],
                            @"action_token" : token,
                            @"data"         : data
                            };
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager userBaseInfoCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            NSDictionary *dataDict = package.data;
            [[HTStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[HTStorageManager sharedInstance] updateUserToken:[NSString stringWithFormat:@"%@", dataDict[@"token"]]];
            [[HTStorageManager sharedInstance] updateLoginUser:user];
        }
        callback(true, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
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

- (HTLoginUser *)loginUser {
    return [[HTStorageManager sharedInstance] getLoginUser];
}

- (NSString *)qiniuToken {
    return [[HTStorageManager sharedInstance] getQiniuToken];
}

- (void)quitLogin {
    [[HTStorageManager sharedInstance] clearLoginUser];
    [[HTStorageManager sharedInstance] clearUserID];
    [[HTStorageManager sharedInstance] clearUserToken];
    [[HTStorageManager sharedInstance] setUserInfo:[[HTUserInfo alloc] init]];
    [[HTStorageManager sharedInstance] setProfileInfo:[[HTProfileInfo alloc] init]];
}

@end
