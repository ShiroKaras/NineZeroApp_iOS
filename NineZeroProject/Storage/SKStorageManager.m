//
//  SKStorageManager.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/1.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKStorageManager.h"
#import "HTStorageDefine.h"
#import "SKModel.h"
#import <YTKKeyValueStore.h>
#import <MJExtension.h>

@implementation SKStorageManager {
    YTKKeyValueStore *_storageService;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SKStorageManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[SKStorageManager alloc] init];
    });
    return manager;
}

#pragma mark - LoginUser

- (void)updateLoginUser:(SKLoginUser *)loginUser {
    [_storageService putObject:[loginUser keyValues] withId:kStorageLoginUserKey intoTable:kStorageTableKey];
}

- (SKLoginUser *)getLoginUser {
    SKLoginUser *user = (SKLoginUser *)[SKLoginUser objectWithKeyValues:[_storageService getObjectById:kStorageLoginUserKey fromTable:kStorageTableKey]];
    return user;
}

- (void)clearLoginUser {
    [_storageService deleteObjectById:kStorageLoginUserKey fromTable:kStorageTableKey];
}

#pragma mark - User ID

- (void)updateUserID:(NSString *)userID {
    [_storageService putString:userID withId:kStorageUserIdKey intoTable:kStorageTableKey];
}

- (NSString *)getUserID {
    return [_storageService getStringById:kStorageUserIdKey fromTable:kStorageTableKey];
}

- (void)clearUserID {
    [_storageService deleteObjectById:kStorageUserIdKey fromTable:kStorageTableKey];
}

@end
