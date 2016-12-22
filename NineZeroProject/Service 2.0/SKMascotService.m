//
//  SKMascotService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKMascotService.h"

@implementation SKMascotService

- (void)mascotBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];// (NSTimeInterval) time = 1427189152.313643
    long long int currentTime=(long long int)time;      //NSTimeInterval返回的是double类型
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setValue:[NSString stringWithFormat:@"%lld",currentTime] forKey:@"time"];
    [mDict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"edition"];
    [mDict setValue:@"iOS" forKey:@"client"];
    [mDict setValue:[[SKStorageManager sharedInstance] getUserID] forKey:@"user_id"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DLog(@"Param:%@", jsonString);
    NSDictionary *param = @{@"data" : jsonString};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager mascotBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"Response:%@",responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        callback(YES, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

//获取所有用户原始零仔
- (void)getMascotsCallback:(SKMascotListCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getPets"
                            };
    [self mascotBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray *mascotArray = [NSMutableArray array];
        for (int i=0; i<[response.data count]; i++) {
            SKPet *mascot = [SKPet objectWithKeyValues:response.data[i]];
            [mascotArray addObject:mascot];
        }
        callback(success, mascotArray);
    }];
}

//获取所有家族零仔
- (void)getFamilyMascotCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getFamilyPets"
                            };
    [self mascotBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//获取默认零仔详情
- (void)getDefaultMascotDetailCallback:(SKDefaultMascotCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getPetDetail",
                            @"pet_id"       :   @"1"
                            };
    [self mascotBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        SKDefaultMascotDetail *d = [SKDefaultMascotDetail objectWithKeyValues:response.data];
        callback(success, d);
    }];
}

//获取零仔详情
- (void)getMascotDetailWithMascotID:(NSString*)mascotID callback:(SKMascotListCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getPetDetail",
                            @"pet_id"       :   mascotID
                            };
    [self mascotBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        if ([response.data count]>0) {
            NSMutableArray *mascotArray = [NSMutableArray array];
            for (int i=0; i<[response.data count]; i++) {
                SKPet *mascot = [SKPet objectWithKeyValues:response.data[i]];
                [mascotArray addObject:mascot];
            }
            callback(success, mascotArray);
        } else {
            callback(success, nil);
        }
    }];
}

//使用零仔技能
- (void)useMascotSkillWithMascotID:(NSString*)mascotID callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"usePetSkill",
                            @"pet_id"       :   mascotID
                            };
    [self mascotBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//零仔战斗随机字符串
- (void)getRandomStringWithMascotID:(NSString*)mascotID callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getRandomString",
                            @"pet_id"       :   mascotID
                            };
    [self mascotBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//零仔战斗获取奖励
- (void)mascotBattleWithMascotID:(NSString*)mascotID randomString:(NSString*)randomString callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"petBattle",
                            @"pet_id"       :   mascotID,
                            @"randomString" :   randomString
                            };
    [self mascotBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

@end
