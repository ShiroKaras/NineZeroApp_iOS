//
//  SKCommonService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/13.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKCommonService.h"
#import "NSString+DES.h"

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
    DLog(@"%@", jsonString);
    NSDictionary *param = @{@"data" : [NSString encryptUseDES:jsonString key:nil]};
    
    [[AFHTTPRequestOperationManager manager] POST:[SKCGIManager commonBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *desString = [NSString decryptUseDES:responseObject[@"data"] key:nil];
        DLog(@"Response:%@",desString);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:desString];
        callback(YES, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@", error);
        callback(NO, nil);
    }];
}

- (void)getHomepageInfoCallBack:(SKIndexInfoCallback)callback {
    NSDictionary *param = @{
                            @"method"   :   @"homePage"
                            };
    [self commonBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSDictionary *dataDict = response.data;
        SKIndexInfo *indexInfo = [SKIndexInfo objectWithKeyValues:dataDict];
        callback(indexInfo);
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

- (void)getQiniuDownloadURLsWithKeys:(NSArray<NSString *> *)keys callback:(SKResponseCallback)callback {
    if (keys.count == 0) return;
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!dataDict[obj]) {
            [dataDict setObject:obj forKey:obj];
        }
    }];
    NSString *string = [self dictionaryToJson:dataDict];
    NSDictionary *param = @{
                            @"method"       :   @"getDownloadUrl",
                            @"url_array"    :   string
                            };
    
    [self commonBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
