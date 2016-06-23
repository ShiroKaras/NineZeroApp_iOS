//
//  SKQuestionService.m
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKQuestionService.h"
#import "HTLogicHeader.h"

@implementation SKQuestionService

- (void)getQiniuDownloadURLsWithKeys:(NSArray<NSString *> *)keys callback:(SKResponseCallback)callback {
    if (keys.count == 0) return;
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!dataDict[obj]) {
            [dataDict setObject:obj forKey:obj];
        }
    }];
    NSString *string = [self dictionaryToJson:dataDict];
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager getQiniuDownloadUrlCGIKey] parameters:@{@"url_array" : string} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@",responseObject);
        callback(true, [SKResponsePackage mj_objectWithKeyValues:responseObject]);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(false, nil);
    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
