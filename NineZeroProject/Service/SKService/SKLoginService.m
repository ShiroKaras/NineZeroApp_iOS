//
//  SKLoginService.m
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKLoginService.h"
#import "HTLogicHeader.h"

@implementation SKLoginService {
    NSString *register_token;
    NSString *resetPassword_token;
}

- (instancetype)init {
    static BOOL hasCreate = NO;
    if (hasCreate == YES) [NSException exceptionWithName:@"手动crash" reason:@"重复创建HTLoginService" userInfo:nil];
    if (self = [super init]) {
        hasCreate = YES;
    }
    return self;
}

#pragma mark - Public Method
#pragma mark 登录
- (void)loginWithUser:(HTLoginUser *)user completion:(SKResponseCallback)callback {
    NSDictionary *param = @{@"access_key"           : SECRET_STRING,
                            @"action"               : [SKCGIManager login_Phonenumber_Action],
                            @"mobile_phone_number"  : user.user_mobile,
                            @"password"             : user.user_password};
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userBaseLoginCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if ([package.resultCode isEqualToString:@"200"]) {
            NSDictionary *dataDict = package.data;
            [[HTStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[HTStorageManager sharedInstance] updateUserToken:[NSString stringWithFormat:@"%@", dataDict[@"token"]]];
            [[HTStorageManager sharedInstance] updateLoginUser:user];
        }
        callback(true, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)bindUserWithThirdPlatform:(HTLoginUser *)user completion:(SKResponseCallback)callback {
    NSDictionary *param = @{@"access_key"           : SECRET_STRING,
                            @"action"               : [SKCGIManager login_ThirdPlatform_Action],
                            @"mobile_phone_number"  : user.user_mobile,
                            @"password"             : user.user_password};
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userBaseLoginCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if ([package.resultCode isEqualToString:@"200"]) {
            NSDictionary *dataDict = package.data;
            [[HTStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[HTStorageManager sharedInstance] updateUserToken:[NSString stringWithFormat:@"%@", dataDict[@"token"]]];
            [[HTStorageManager sharedInstance] updateLoginUser:user];
        }
        callback(true, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

#pragma mark 注册
- (void)createRegisterService:(SKResponseCallback)callback {
    // 申请注册服务 (POST http://90app-test.daoapp.io/api/register)
    
    // JSON Body
    NSDictionary *param = @{@"access_key"   : SECRET_STRING,
                            @"action"       : [SKCGIManager register_newService_Action]};
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userBaseRegisterCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if ([package.resultCode isEqualToString:@"200"]) {
            register_token = package.data[@"token"];
            callback(true, package);
        }else
            callback(false, package);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)getRegisterVerifyCodeWithMobile:(NSString *)mobile completion:(SKResponseCallback)callback {
    if (mobile.length == 0) return;
    if (register_token == nil || [register_token isEqualToString:@""]) return;
    NSDictionary *param = @{@"access_key"   : SECRET_STRING,
                            @"action"       : [SKCGIManager register_sendVerificationCode_Action],
                            @"action_token" : register_token,
                            @"phone"        : mobile};
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userBaseRegisterCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if ([package.resultCode isEqualToString:@"200"]) {
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)checkRegisterVerifyCodeWithPhone:(NSString *)mobile code:(NSString *)code completion:(SKResponseCallback)callback {
    if (mobile.length == 0) return;
    if (register_token == nil || [register_token isEqualToString:@""]) return;
    NSDictionary *param = @{@"access_key"       : SECRET_STRING,
                            @"action"           : [SKCGIManager register_checkVerificaitonCode_Action],
                            @"action_token"     : register_token,
                            @"phone"            : mobile,
                            @"verification_code": code};
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userBaseRegisterCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if ([package.resultCode isEqualToString:@"200"]) {
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)registerWithUser:(HTLoginUser *)user completion:(SKResponseCallback)callback {
    if (user.user_name.length == 0)     return;
    if (user.user_password.length == 0) return;
    if (user.user_mobile.length == 0)   return;
    
    NSDictionary *data  =  @{@"name"       :   user.user_name,
                             @"phone"      :   user.user_mobile,
                             @"password"   :   user.user_password
                             };
    NSDictionary *param = @{@"access_key"   : SECRET_STRING,
                            @"action"       : [SKCGIManager register_create_Action],
                            @"action_token" : register_token,
                            @"data"         : data
                            };
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userBaseInfoCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if ([package.resultCode isEqualToString:@"200"]) {
            NSDictionary *dataDict = package.data;
            [[HTStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[HTStorageManager sharedInstance] updateUserToken:[NSString stringWithFormat:@"%@", dataDict[@"token"]]];
            [[HTStorageManager sharedInstance] updateLoginUser:user];
        }
        callback(true, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

#pragma mark 重置密码
- (void)createResetPasswordService:(SKResponseCallback)callback {
    NSDictionary *param = @{@"access_key"   : SECRET_STRING,
                            @"action"       : [SKCGIManager resetPassword_newService_Action]};
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userResetPasswordCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if ([package.resultCode isEqualToString:@"200"]) {
            resetPassword_token = package.data[@"token"];
            callback(true, package);
        }else
            callback(false, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)getResetPasswordVerifyCodeWithMobile:(NSString *)mobile completion:(SKResponseCallback)callback {
    if (mobile.length == 0) return;
    if (resetPassword_token == nil || [resetPassword_token isEqualToString:@""]) return;
    NSDictionary *param = @{@"access_key"   : SECRET_STRING,
                            @"action"       : [SKCGIManager resetPassword_sendVerificationCode_Action],
                            @"action_token" : resetPassword_token,
                            @"phone"        : mobile};
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userResetPasswordCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if ([package.resultCode isEqualToString:@"200"]) {
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)checkResetPasswordVerifyCodeWithPhone:(NSString *)mobile code:(NSString *)code completion:(SKResponseCallback)callback {
    if (mobile.length == 0) return;
    if (resetPassword_token == nil || [resetPassword_token isEqualToString:@""]) return;
    NSDictionary *param = @{@"access_key"       : SECRET_STRING,
                            @"action"           : [SKCGIManager register_checkVerificaitonCode_Action],
                            @"action_token"     : resetPassword_token,
                            @"phone"            : mobile,
                            @"verification_code": code};
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userResetPasswordCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if ([package.resultCode isEqualToString:@"200"]) {
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)resetPasswordWithUser:(HTLoginUser *)user completion:(SKResponseCallback)callback {
    if (user.user_mobile.length == 0) return;
    if (user.user_password.length == 0) return;
    if (resetPassword_token == nil || [resetPassword_token isEqualToString:@""]) return;
    
    NSDictionary *data  =  @{@"phone"      :   user.user_mobile,
                             @"password"   :   user.user_password
                             };
    NSDictionary *param = @{@"access_key"   : SECRET_STRING,
                            @"action"       : [SKCGIManager resetPassword_update_Action],
                            @"action_token" : resetPassword_token,
                            @"data"         : data
                            };
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userBaseInfoCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if ([package.resultCode isEqualToString:@"200"]) {
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

#pragma mark 七牛
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
