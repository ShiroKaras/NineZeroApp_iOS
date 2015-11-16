//
//  HTLoginService.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/15.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTLoginService.h"
#import "HTLoginUser.h"
#import <AFNetworking.h>
#import "HTCGIManager.h"
#import "MJExtension.h"
#import "HTLog.h"

@implementation HTLoginService

- (instancetype)init {
    static BOOL hasCreate = NO;
    if (hasCreate == YES) [NSException exceptionWithName:@"手动crash" reason:@"重复创建HTLoginService" userInfo:nil];
    if (self = [super init]) {
        hasCreate = YES;
    }
    return self;
}

#pragma mark - Public Method

- (void)registerWithUser:(HTLoginUser *)user {
    NSDictionary *parameters = [user keyValues];
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager userBaseRegisterCGIKey] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        DLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
    }];
}

- (void)loginWithUser:(HTLoginUser *)user {
	NSDictionary *para = @{
						   @"user_name" : user.user_name,
						   @"user_password" : user.user_password
						   };
    [[AFHTTPRequestOperationManager manager] POST:[HTCGIManager userBaseLoginCGIKey] parameters:para success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
		DLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
		DLog(@"%@", error);
    }];
}

- (void)loginWithName:(NSString *)name password:(NSString *)password {
	NSDictionary *para = @{
						   @"user_name" : name,
						   @"user_password" : password
						   };
	[[AFHTTPRequestOperationManager manager] POST:[HTCGIManager userBaseLoginCGIKey] parameters:para success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
		DLog(@"%@", responseObject);
	} failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
		DLog(@"%@", error);
	}];
}

- (void)resetPassword:(NSString *)password {
    
}

@end
