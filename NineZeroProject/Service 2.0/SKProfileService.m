//
//  SKProfileService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKProfileService.h"

@implementation SKProfileService

- (void)profileBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];// (NSTimeInterval) time = 1427189152.313643
    long long int currentTime=(long long int)time;      //NSTimeInterval返回的是double类型
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setValue:[NSString stringWithFormat:@"%lld",currentTime] forKey:@"time"];
    [mDict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"edition"];
    [mDict setValue:@"iOS" forKey:@"client"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"data" : jsonString};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager profileBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"Response:%@",responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:[jsonString dictionaryWithJsonString]];
        callback(YES, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

//获取个人信息
- (void)getUserInfoDetailCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"detail",
                            // TODO
                            @"user_id"      :   @""
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//获取礼券列表
- (void)getUserTicketsCallbackCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getUserTickets",
                            // TODO
                            @"user_id"      :   @""
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//获取个人排名
- (void)getUserRankCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getRank",
                            // TODO
                            @"user_id"      :   @""
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//获取个人通知列表
- (void)getUserNotificationCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getNotice",
                            // TODO
                            @"user_id"      :   @""
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//获取基本信息
- (void)getUserBaseInfoCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getBaseInfo",
                            // TODO
                            @"user_id"      :   @""
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//获取所有排名
- (void)getAllRankListCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getAllRank",
                            // TODO
                            @"user_id"      :   @""
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//修改个人设置
- (void)updateSettingWith:(SKUserSetting*)userSetting callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"updateSetting",
                            // TODO
                            @"user_id"      :   @"",
                            @"address"      :   userSetting.address,
                            @"mobile"       :   userSetting.mobile,
                            @"push_setting" :   [NSString stringWithFormat:@"%d", userSetting.push_setting]
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//修改个人信息
- (void)updateUserInfoWith:(SKLoginUser*)userInfo callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"updateName",
                            // TODO
                            @"user_id"      :   @"",
                            @"user_name"    :   userInfo.user_name,
                            @"user_avatar"  :   userInfo.user_avatar
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//用户反馈
- (void)feedbackWithContent:(NSString *)content contact:(NSString *)contact completion:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"updateSetting",
                            // TODO
                            @"user_id"      :   @"",
                            @"content"      :   content,
                            @"contact"      :   contact
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

@end
