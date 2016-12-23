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

- (void)commonBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
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
    DLog(@"%@", param[@"data"]);
    
    [manager POST:[SKCGIManager commonBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
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
