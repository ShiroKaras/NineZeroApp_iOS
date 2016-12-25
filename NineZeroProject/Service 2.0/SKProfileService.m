//
//  SKProfileService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKProfileService.h"

@implementation SKProfileService

- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"90appbundle" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}

- (void)profileBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];// (NSTimeInterval) time = 1427189152.313643
    long long int currentTime=(long long int)time;      //NSTimeInterval返回的是double类型
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setValue:[NSString stringWithFormat:@"%lld",currentTime] forKey:@"time"];
    [mDict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"edition"];
    [mDict setValue:@"iOS" forKey:@"client"];
    [mDict setValue:[[SKStorageManager sharedInstance] getUserID]  forKey:@"user_id"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *param = @{@"data" : [NSString encryptUseDES:jsonString key:nil]};
    
    [manager POST:[SKCGIManager profileBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSString *desString = [NSString decryptUseDES:responseObject[@"data"] key:nil];
//        NSDictionary *desDict = [desString dictionaryWithJsonString];
        DLog(@"Response:%@",responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        if (package.result == 0) {
            callback(YES, package);
        } else {
            callback(YES, package);
            DLog(@"%ld",(long)package.result);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@", error);
        callback(NO, nil);
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
- (void)getUserNotificationCallback:(SKGetNotificationsCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getNotice"
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray *notificationArray = [NSMutableArray array];
        if ([response.data count]>0) {
            for (int i=0; i<[response.data count]; i++) {
                SKNotification *notification = [SKNotification objectWithKeyValues:response.data[i]];
                [notificationArray insertObject:notification atIndex:0];
            }
        }
        callback(success, notificationArray);
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

//获取第一季排名
- (void)getSeason1RankListCallback:(SKGetRankerListCallbakc)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getOneRank"
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray *rankerArray = [NSMutableArray array];
        if ([response.data count]>0) {
            for (int i=0; i<[response.data count]; i++) {
                SKRanker *ranker = [SKRanker objectWithKeyValues:response.data[i]];
                [rankerArray addObject:ranker];
            }
            callback(success, rankerArray);
        }
    }];
}

//获取第二季排名
- (void)getSeason2RankListCallback:(SKGetRankerListCallbakc)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getAllRank"
                            };
    [self profileBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray *rankerArray = [NSMutableArray array];
        if ([response.data count]>0) {
            for (int i=0; i<[response.data count]; i++) {
                SKRanker *ranker = [SKRanker objectWithKeyValues:response.data[i]];
                [rankerArray addObject:ranker];
            }
            callback(success, rankerArray);
        }
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
            callback(success, response);
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