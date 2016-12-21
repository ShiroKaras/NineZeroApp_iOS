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
    [mDict setValue:[[SKStorageManager sharedInstance] getUserID]  forKey:@"user_id"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"data" : jsonString};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager profileBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"Response:%@",responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if (package.result == 0) {
            callback(YES, package);
        } else {
            DLog(@"%ld",(long)package.result);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

//获取个人信息
- (void)getUserInfoDetailCallback:(SKProfileInfoCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getUserInfo"
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        SKProfileInfo *profileInfo = [SKProfileInfo objectWithKeyValues:[response keyValues][@"data"]];
        [SKStorageManager sharedInstance].profileInfo = profileInfo;
        callback(success, profileInfo);
    }];
}

//获取礼券列表
- (void)getUserTicketsCallbackCallback:(SKGetTicketsCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getUserTickets"
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray *ticketArray = [NSMutableArray array];
        if ([response.data count]>0) {
            for (int i=0; i<[response.data count]; i++) {
                SKTicket *piece = [SKTicket objectWithKeyValues:response.data[i]];
                [ticketArray addObject:piece];
            }
        }
        callback(success, ticketArray);
    }];
}

//获取个人排名
- (void)getUserRankCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getRank"
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//获取个人通知列表
- (void)getUserNotificationCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getNotice"
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//获取基本信息
- (void)getUserBaseInfoCallback:(SKUserInfoCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getBaseInfo"
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        SKUserInfo *userInfo = [SKUserInfo objectWithKeyValues:[response keyValues][@"data"]];
        [SKStorageManager sharedInstance].userInfo = userInfo;
        callback(success, userInfo);
    }];
}

//获取所有排名
- (void)getAllRankListCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getAllRank"
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//修改个人信息
- (void)updateUserInfoWith:(SKUserInfo*)userInfo withType:(int)type callback:(SKResponseCallback)callback {
    NSDictionary *param;
    if (type == 0) {
        param = @{
                    @"method"       :   @"updateName",
                    @"user_avatar"  :   userInfo.user_avatar
                };
    } else if (type == 1) {
        param = @{
                    @"method"       :   @"updateName",
                    @"user_name"    :   userInfo.user_name
                };
    }
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        if (response.result == 0) {
            [self getUserBaseInfoCallback:^(BOOL success, SKUserInfo *response2) { }];
            callback(success, response);
        } else {
            callback(success, nil);
        }
    }];
}

//用户反馈
- (void)feedbackWithContent:(NSString *)content contact:(NSString *)contact completion:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"updateSetting",
                            @"content"      :   content,
                            @"contact"      :   contact
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//重新获取用户信息
- (void)updateUserInfoFromServer {
    [self getUserBaseInfoCallback:^(BOOL success, SKUserInfo *response) {
        [[SKStorageManager sharedInstance] setUserInfo:response];
    }];
}

//获取勋章
- (void)getBadges:(SKGetBadgesCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getMedal"
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray *badgeArray = [NSMutableArray array];
        if ([response.data[@"list"] count]>0) {
            for (int i=0; i<[response.data[@"list"] count]; i++) {
                SKBadge *badge = [SKBadge objectWithKeyValues:response.data[@"list"][i]];
                [badgeArray addObject:badge];
            }
        }
        callback(success, [response.data[@"user_experience_value"] integerValue], badgeArray);
    }];
}

//获取碎片
- (void)getPieces:(SKGetPiecesCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getPiece"
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray *pieceArray = [NSMutableArray array];
        if ([response.data count]>0) {
            for (int i=0; i<[response.data count]; i++) {
                SKPiece *piece = [SKPiece objectWithKeyValues:response.data[i]];
                [pieceArray addObject:piece];
            }
        }
        callback(success, pieceArray);
    }];
}
@end
