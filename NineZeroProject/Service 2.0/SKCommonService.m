//
//  SKCommonService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/13.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKCommonService.h"

@implementation SKCommonService

- (void)commonBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];  // (NSTimeInterval) time = 1427189152.313643
    long long int currentTime=(long long int)time;              //NSTimeInterval返回的是double类型
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setValue:[NSString stringWithFormat:@"%lld",currentTime] forKey:@"time"];
    [mDict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"edition"];
    [mDict setValue:@"iOS" forKey:@"client"];
    [mDict setValue:[[SKStorageManager sharedInstance] getUserID] forKey:@"user_id"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *param = @{@"data" : jsonString};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager commonBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"Response:%@",responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        callback(YES, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(NO, nil);
        DLog(@"%@", error);
    }];
}

- (void)getHomepageInfoCallBack:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"   :   @"homePage"
                            };
    [self commonBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (void)getQiniuPublicTokenWithCompletion:(SKGetTokenCallback)callback {
    NSDictionary *param = @{
                            @"method"   :   @"getQiniuPublicToken"
                            };
    [self commonBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(response.data);
        [[SKStorageManager sharedInstance] setQiniuPublicToken:response.data];
    }];
}

- (void)getDownloadURLWithURLArray:(NSArray*)urlArray callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getDownloadUrl",
                            @"url_array"    :   urlArray
                            };
    [self commonBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

@end
