//
//  SKPropService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKPropService.h"

@implementation SKPropService

- (void)propBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
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
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager propBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"Response:%@",responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        callback(YES, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

//购买道具
- (void)purchasePropWithPurchaseType:(NSString*)purchaseType propType:(NSString*)propType callback:(SKQuestionBuyPropCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"buyProp",
                            @"buy_type"     :   purchaseType,
                            @"prop_type"    :   propType
                            };
    [self propBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSString *responseString;
        if (response.result == 0) {
            if ([propType isEqualToString:@"1"]) {
                responseString = @"获得线索道具";
            } else if ([propType isEqualToString:@"2"]) {
                responseString = @"获得答案道具";
            }
        } else if (response.result == -8001) {
            responseString = @"金币数不够";
        } else if (response.result == -8002) {
            responseString = @"宝石数不够";
        } else if (response.result == -8003) {
            responseString = @"冷却时间不能购买";
        }
        callback(success, responseString);
    }];
}

//使用道具
- (void)usePropWithQuestionID:(NSString*)questionID seasonType:(NSString*)type callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"useProp",
                            @"qid"          :   questionID,
                            @"level_type"   :   type
                            };
    [self propBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

@end
