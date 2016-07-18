//
//  SKLoginService.m
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rigSKS reserved.
//

#import "SKLoginService.h"

@interface SKLoginService()

@property (nonatomic, strong) NSString *register_create_token;
@property (nonatomic, strong) NSString *register_newUser_token;
@property (nonatomic, strong) NSString *resetPassword_create_token;
@property (nonatomic, strong) NSString *resetPassword_newPassword_token;

@end

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
#pragma mark 登录
- (void)loginWithUser:(SKLoginUser *)user completion:(SKResponseCallback)callback {
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // JSON Body
    NSDictionary* bodyObject = @{
                                 @"access_key": SECRET_STRING,
                                 @"action": [SKCGIManager login_Phonenumber_Action],
                                 @"mobile_phone_number": user.user_mobile,
                                 @"password": user.user_password
                                 };
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userBaseLoginCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
        NSDictionary *dataDict = package.data;
            [[SKStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[SKStorageManager sharedInstance] updateLoginUser:user];
            [[SKStorageManager sharedInstance] updateUserToken:[NSString stringWithFormat:@"%@", dataDict[@"token"]]];
        }
        callback(true, package);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"HTTP Request failed: %@", error);
        callback(false, nil);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)bindUserWithThirdPlatform:(SKLoginUser *)user completion:(SKResponseCallback)callback {
    NSDictionary* bodyObject = @{
                                 @"access_key": SECRET_STRING,
                                 @"action": [SKCGIManager login_ThirdPlatform_Action],
                                 @"third_party_id": user.third_id,
                                 @"avatar_url": user.user_avatar,
                                 @"name": user.user_name
                                 };

    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userBaseLoginCGIKey] parameters:bodyObject error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            NSDictionary *dataDict = package.data;
            [[SKStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[SKStorageManager sharedInstance] updateUserToken:[NSString stringWithFormat:@"%@", dataDict[@"token"]]];
            [[SKStorageManager sharedInstance] updateLoginUser:user];
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
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            _register_create_token = package.data[@"token"];
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
    if (_register_create_token == nil || [_register_create_token isEqualToString:@""]) return;
    NSDictionary *param = @{@"access_key"   : SECRET_STRING,
                            @"action"       : [SKCGIManager register_sendVerificationCode_Action],
                            @"action_token" : _register_create_token,
                            @"phone"        : mobile};
    
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userBaseRegisterCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)checkRegisterVerifyCodeWithPhone:(NSString *)mobile code:(NSString *)code completion:(SKResponseCallback)callback {
    if (mobile.length == 0) return;
    if (_register_create_token == nil || [_register_create_token isEqualToString:@""]) return;
    NSDictionary *param = @{@"access_key"       : SECRET_STRING,
                            @"action"           : [SKCGIManager register_checkVerificaitonCode_Action],
                            @"action_token"     : _register_create_token,
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
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            _register_newUser_token = package.data[@"token"];
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)registerWithUser:(SKLoginUser *)user completion:(SKResponseCallback)callback {
    if (user.user_name.length == 0)     return;
    if (user.user_password.length == 0) return;
    if (user.user_mobile.length == 0)   return;
    
    NSDictionary *data  =  @{@"name"       :   user.user_name,
                             @"phone"      :   user.user_mobile,
                             @"password"   :   user.user_password
                             };
    NSDictionary *param = @{@"access_key"   : SECRET_STRING,
                            @"action"       : [SKCGIManager register_create_Action],
                            @"action_token" : _register_newUser_token,
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
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            NSDictionary *dataDict = package.data;
            [[SKStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[SKStorageManager sharedInstance] updateUserToken:[NSString stringWithFormat:@"%@", dataDict[@"token"]]];
            [[SKStorageManager sharedInstance] updateLoginUser:user];
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
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            _resetPassword_create_token = package.data[@"token"];
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
    if (_resetPassword_create_token == nil || [_resetPassword_create_token isEqualToString:@""]) return;
    NSDictionary *param = @{@"access_key"   : SECRET_STRING,
                            @"action"       : [SKCGIManager resetPassword_sendVerificationCode_Action],
                            @"action_token" : _resetPassword_create_token,
                            @"phone"        : mobile};
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableURLRequest* request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[SKCGIManager userResetPasswordCGIKey] parameters:param error:NULL];
    
    // Add Headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch Request
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@", responseObject);
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)checkResetPasswordVerifyCodeWithPhone:(NSString *)mobile code:(NSString *)code completion:(SKResponseCallback)callback {
    if (mobile.length == 0) return;
    if (_resetPassword_create_token == nil || [_resetPassword_create_token isEqualToString:@""]) return;
    NSDictionary *param = @{@"access_key"       : SECRET_STRING,
                            @"action"           : [SKCGIManager register_checkVerificaitonCode_Action],
                            @"action_token"     : _resetPassword_create_token,
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
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
            _resetPassword_newPassword_token = package.data[@"token"];
            callback(true, package);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"HTTP Request failed: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

- (void)resetPasswordWithUser:(SKLoginUser *)user completion:(SKResponseCallback)callback {
    if (user.user_mobile.length == 0) return;
    if (user.user_password.length == 0) return;
    if (_resetPassword_newPassword_token == nil || [_resetPassword_newPassword_token isEqualToString:@""]) return;
    
    NSDictionary *data  =  @{@"phone"      :   user.user_mobile,
                             @"password"   :   user.user_password
                             };
    NSDictionary *param = @{@"access_key"   : SECRET_STRING,
                            @"action"       : [SKCGIManager resetPassword_update_Action],
                            @"action_token" : _resetPassword_newPassword_token,
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
        SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
        if (package.resultCode == 200) {
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
        [[SKStorageManager sharedInstance] updateQiniuToken:responseObject[@"data"]];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(nil);
    }];
}

- (void)getQiniuPublicTokenWithCompletion:(HTGetTokenCallback)callback {
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQiniuPublicUploadTokenCGIKey] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
        callback([NSString stringWithFormat:@"%@", responseObject[@"data"]]);
        [[SKStorageManager sharedInstance] setQiniuPublicToken:responseObject[@"data"]];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(nil);
    }];
}

- (SKLoginUser *)loginUser {
    return [[SKStorageManager sharedInstance] getLoginUser];
}

- (NSString *)qiniuToken {
    return [[SKStorageManager sharedInstance] getQiniuToken];
}

- (void)quitLogin {
    [[SKStorageManager sharedInstance] clearLoginUser];
    [[SKStorageManager sharedInstance] clearUserID];
    [[SKStorageManager sharedInstance] clearUserToken];
    [[SKStorageManager sharedInstance] setUserInfo:[[SKUserInfo alloc] init]];
    [[SKStorageManager sharedInstance] setProfileInfo:[[SKProfileInfo alloc] init]];
}

@end
