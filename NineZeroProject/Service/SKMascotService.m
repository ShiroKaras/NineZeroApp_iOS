//
//  SKMascotService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKMascotService.h"
#import "NSString+DES.h"

@implementation SKMascotService

- (AFSecurityPolicy *)customSecurityPolicy {
	// /先导入证书
	NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"90appbundle" ofType:@"cer"]; //证书的路径
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

	securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];

	return securityPolicy;
}

- (void)mascotBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	[manager setSecurityPolicy:[self customSecurityPolicy]];
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];

	NSTimeInterval time = [[NSDate date] timeIntervalSince1970]; // (NSTimeInterval) time = 1427189152.313643
	long long int currentTime = (long long int)time;	     //NSTimeInterval返回的是double类型
	NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
	[mDict setValue:[NSString stringWithFormat:@"%lld", currentTime] forKey:@"time"];
	[mDict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"edition"];
	[mDict setValue:@"iOS" forKey:@"client"];
	[mDict setValue:[[SKStorageManager sharedInstance] getUserID] forKey:@"user_id"];

	NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	DLog(@"Param:%@", jsonString);
	NSDictionary *param = @{ @"data": [NSString encryptUseDES:jsonString key:nil] };

	[manager POST:[SKCGIManager mascotBaseCGIKey]
		parameters:param
		progress:nil
		success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
		    SKResponsePackage *package = [SKResponsePackage mj_objectWithKeyValues:responseObject];
		    callback(YES, package);
		}
		failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
		    DLog(@"%@", error);
		    callback(NO, nil);
		}];
}

//获取所有用户原始零仔
- (void)getMascotsCallback:(SKMascotListCallback)callback {
	NSDictionary *param = @{
		@"method": @"getPets"
	};
	[self mascotBaseRequestWithParam:param
				  callback:^(BOOL success, SKResponsePackage *response) {
				      NSMutableArray *mascotArray = [NSMutableArray array];
				      for (int i = 0; i < [response.data count]; i++) {
					      SKPet *mascot = [SKPet mj_objectWithKeyValues:response.data[i]];
					      [mascotArray addObject:mascot];
				      }
				      callback(success, mascotArray);
				  }];
}

//获取所有家族零仔
- (void)getFamilyMascotCallback:(SKResponseCallback)callback {
	NSDictionary *param = @{
		@"method": @"getFamilyPets"
	};
	[self mascotBaseRequestWithParam:param
				  callback:^(BOOL success, SKResponsePackage *response) {
				      callback(success, response);
				  }];
}

//获取默认零仔详情
- (void)getDefaultMascotDetailCallback:(SKDefaultMascotCallback)callback {
	NSDictionary *param = @{
		@"method": @"getPetDetail",
		@"pet_id": @"1"
	};
	[self mascotBaseRequestWithParam:param
				  callback:^(BOOL success, SKResponsePackage *response) {
				      SKDefaultMascotDetail *d = [SKDefaultMascotDetail mj_objectWithKeyValues:response.data];
				      callback(success, d);
				  }];
}

////获取零仔详情
//- (void)getMascotDetailWithMascotID:(NSString *)mascotID callback:(SKMascotListCallback)callback {
//	NSDictionary *param = @{
//		@"method": @"getPetDetail",
//		@"pet_id": mascotID
//	};
//	[self mascotBaseRequestWithParam:param
//				  callback:^(BOOL success, SKResponsePackage *response) {
//				      if ([response.data count] > 0) {
//					      NSMutableArray *mascotArray = [NSMutableArray array];
//					      for (int i = 0; i < [response.data count]; i++) {
//						      SKPet *mascot = [SKPet mj_objectWithKeyValues:response.data[i]];
//						      [mascotArray addObject:mascot];
//					      }
//					      callback(success, mascotArray);
//				      } else {
//					      callback(success, nil);
//				      }
//				  }];
//}

//使用零仔技能
- (void)useMascotSkillWithMascotID:(NSString *)mascotID callback:(SKResponseCallback)callback {
	NSDictionary *param = @{
		@"method": @"usePetSkill",
		@"pet_id": mascotID
	};
	[self mascotBaseRequestWithParam:param
				  callback:^(BOOL success, SKResponsePackage *response) {
				      callback(success, response);
				  }];
}

//零仔战斗随机字符串
- (void)getRandomStringWithMascotID:(NSString *)mascotID callback:(SKResponseCallback)callback {
	NSDictionary *param = @{
		@"method": @"getRandomString",
		@"pet_id": mascotID
	};
	[self mascotBaseRequestWithParam:param
				  callback:^(BOOL success, SKResponsePackage *response) {
				      callback(success, response);
				  }];
}

//零仔战斗获取奖励
- (void)mascotBattleWithMascotID:(NSString *)mascotID randomString:(NSString *)randomString callback:(SKResponseCallback)callback {
	NSDictionary *param = @{
		@"method": @"petBattle",
		@"pet_id": mascotID,
		@"randomString": randomString
	};
	[self mascotBaseRequestWithParam:param
				  callback:^(BOOL success, SKResponsePackage *response) {
				      callback(success, response);
				  }];
}

#pragma mark - 3.0

- (void)getAllPetsCoopTimeCallback:(NZMascotArrayCallback)callback {
    NSDictionary *param = @{
                            @"method": @"getAllPetsCoop",
                            };
    [self mascotBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKMascot*> *dataArray = [NSMutableArray array];
        for (int i=0; i<[response.data count]; i++) {
            SKMascot *mascot = [SKMascot mj_objectWithKeyValues:response.data[i]];
            [dataArray addObject:mascot];
        }
        callback(success, dataArray);
    }];
}

- (void)getMascotCoopTimeRankListCallback:(NZMascotCoopTimeRankListCallback)callback {
    NSDictionary *param = @{
                            @"method" : @"getPetCoopRank",
                            };
    [self mascotBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray *dataArray = [NSMutableArray array];
        for (int i=0; i<[response.data count]; i++) {
            SKRanker *ranker = [SKRanker mj_objectWithKeyValues:response.data[i]];
            [dataArray addObject:ranker];
        }
        callback(success, dataArray);
    }];
}

- (void)getMascotDetailWithMascotID:(NSString *)mascotID callback:(NZMascotArrayCallback)callback {
    NSDictionary *param = @{
                            @"method": @"getPetCoopDetail",
                            @"pet_id": mascotID
                            };
    [self mascotBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKMascot*> *dataArray = [NSMutableArray array];
        for (int i=0; i<[response.data count]; i++) {
            SKMascot *mascot = [SKMascot mj_objectWithKeyValues:response.data[i]];
            [dataArray addObject:mascot];
        }
        callback(success, dataArray);
    }];
}

- (void)getMascotEvidenceDetailWithID:(NSString *)eid callback:(void (^)(BOOL, SKMascotEvidence *))callback {
    NSDictionary *param = @{
                            @"method": @"getCrimeDetail",
                            @"id"    : eid
                            };
    [self mascotBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        SKMascotEvidence *evidence = [SKMascotEvidence mj_objectWithKeyValues:response.data];
        callback(success, evidence);
    }];
}

@end
