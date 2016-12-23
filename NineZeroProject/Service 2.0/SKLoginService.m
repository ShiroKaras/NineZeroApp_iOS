//
//  SKLoginService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKLoginService.h"
#import "SKStorageManager.h"
#import "SKModel.h"

#import "NSString+AES256.h"
#define AES_KEY @"a!dg#8ai@o43ht9s"

@implementation SKLoginService

- (void)loginBaseRequestWithParam:(NSDictionary*)dict callback:(SKResponseCallback)callback {
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];// (NSTimeInterval) time = 1427189152.313643
    long long int currentTime=(long long int)time;      //NSTimeInterval返回的是double类型
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setValue:[NSString stringWithFormat:@"%lld",currentTime] forKey:@"time"];
    [mDict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"edition"];
    [mDict setValue:@"iOS" forKey:@"client"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DLog(@"Json ParamString: %@", jsonString);
    NSDictionary *param = @{@"data" : jsonString};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager loginBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"Response:%@",responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        callback(YES, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)registerWith:(SKLoginUser *)user callback:(SKResponseCallback)callback {
    user.user_password = [NSString confusedPasswordWithLoginUser:user];
    
    NSDictionary *param = @{
                            @"method"       :   @"register",
                            @"user_name"    :   user.user_name,
                            @"user_password":   user.user_password,
                            @"user_mobile"  :   user.user_mobile,
                            @"vcode"        :   user.code
                            };
    [self loginBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSDictionary *dataDict = response.data;
        if (response.result == 0) {
            [[SKStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[SKStorageManager sharedInstance] updateLoginUser:user];
        }
        callback(success, response);
    }];
}

- (void)loginWith:(SKLoginUser *)user callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"login",
                            @"user_password":   user.user_password,
                            @"user_mobile"  :   user.user_mobile,
                            };
    [self loginBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSDictionary *dataDict = response.data;
        if (response.result == 0) {
            SKLoginUser *loginUser = [SKLoginUser objectWithKeyValues:dataDict];
            [[SKStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[SKStorageManager sharedInstance] updateLoginUser:loginUser];
        }
        callback(success, response);
    }];
}

- (void)loginWithThirdPlatform:(SKLoginUser *)user callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"third_login",
                            @"user_name"    :   user.user_name,
                            @"user_avatar"  :   user.user_avatar,
                            @"user_area_id" :   user.user_area_id,
                            @"third_id"      :   user.third_id
                            };
    [self loginBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSDictionary *dataDict = response.data;
        if (response.result == 0) {
            SKLoginUser *loginUser = [SKLoginUser objectWithKeyValues:dataDict];
            [[SKStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[SKStorageManager sharedInstance] updateLoginUser:loginUser];
        }
        callback(success, response);
    }];
}

- (void)resetPassword:(SKLoginUser *)user callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"reset",
                            @"user_password":   user.user_password,
                            @"user_mobile"  :   user.user_mobile,
                            @"vcode"        :   user.code
                            };
    [self loginBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSDictionary *dataDict = response.data;
        SKLoginUser *loginUser = [SKLoginUser objectWithKeyValues:dataDict];
        if (response.result == 0) {
            [[SKStorageManager sharedInstance] updateUserID:[NSString stringWithFormat:@"%@", dataDict[@"user_id"]]];
            [[SKStorageManager sharedInstance] updateLoginUser:loginUser];            
        }
        callback(success, response);
    }];
}

- (void)sendVerifyCodeWithMobile:(NSString *)mobile callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"sendCode",
                            @"user_mobile"  :   mobile
                            };
    [self loginBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (void)checkMobileRegisterStatus:(NSString *)mobile callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"check_mobile",
                            @"user_mobile"  :   mobile
                            };
    [self loginBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (SKLoginUser *)loginUser {
    return [[SKStorageManager sharedInstance] getLoginUser];
}

- (void)quitLogin {
    [[SKStorageManager sharedInstance] clearLoginUser];
    [[SKStorageManager sharedInstance] clearUserID];
    [[SKStorageManager sharedInstance] setUserInfo:[[SKUserInfo alloc] init]];
    [[SKStorageManager sharedInstance] setProfileInfo:[[SKProfileInfo alloc] init]];
}


@end
