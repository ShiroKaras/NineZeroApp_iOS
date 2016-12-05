//
//  SKLoginService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKLoginService.h"

#import "NSString+AES256.h"
#define AES_KEY @"a!dg#8ai@o43ht9s"

@implementation SKLoginService

- (void)loginBaseRequestWithParam:(NSDictionary*)dict callback:(SKResponseCallback)callback {
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];// (NSTimeInterval) time = 1427189152.313643
    long long int currentTime=(long long int)time;      //NSTimeInterval返回的是double类型
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setValue:[NSString stringWithFormat:@"%lld",currentTime] forKey:@"time"];
    [mDict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"edition"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *aes256String = [jsonString aes256_encrypt:AES_KEY];
    DLog(@"Json ParamString: %@", jsonString);
    DLog(@"AES Param String: %@", aes256String);
    DLog(@"DES Param String: %@", [aes256String aes256_decrypt:AES_KEY]);
    NSDictionary *param = @{@"data" : aes256String};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager loginBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *jsonString = [responseObject[@"data"] aes256_decrypt:AES_KEY];
        DLog(@"AESString:%@",responseObject[@"data"]);
        DLog(@"Method:%@\n%@",[jsonString dictionaryWithJsonString][@"method"], [jsonString dictionaryWithJsonString]);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:[jsonString dictionaryWithJsonString]];
        callback(YES, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)registerWithUsername:(NSString *)username password:(NSString *)password mobile:(NSString *)mobile vCode:(NSString *)vCode callback:(SKResponseCallback)callback{
    NSDictionary *param = @{
                            @"method"       :   @"register",
                            @"user_name"    :   username,
                            @"user_password":   password,
                            @"user_mobile"  :   mobile,
                            @"vcode"        :   vCode
                            };
    [self loginBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (void)loginWithMobile:(NSString *)mobile password:(NSString *)password callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"login",
                            @"user_password":   password,
                            @"user_mobile"  :   mobile,
                            };
    [self loginBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (void)loginWithThirdPlatform:(NSString *)third_id username:(NSString *)username avatarURL:(NSString *)avatarURL areaID:(NSString *)areaID callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"third_login",
                            @"user_name"    :   username,
                            @"user_avatar"  :   avatarURL,
                            @"user_area_id" :   areaID,
                            @"thid_id"      :   third_id
                            };
    [self loginBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (void)resetPasswordWithMobile:(NSString *)mobile password:(NSString *)password verifyCode:(NSString *)vCode callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"reset",
                            @"user_password":   password,
                            @"user_mobile"  :   mobile,
                            @"vcode"        :   vCode
                            };
    [self loginBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
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

@end
