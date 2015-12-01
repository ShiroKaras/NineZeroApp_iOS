//
//  HTStorageManager.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/25.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTStorageManager.h"
#import "HTStorageDefine.h"
#import "HTLoginUser.h"
#import <YTKKeyValueStore.h>
#import <MJExtension.h>

@interface HTStorageManager ()
@end

@implementation HTStorageManager {
    YTKKeyValueStore *_storageService;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HTStorageManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[HTStorageManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createStorageServiceIfNeed];
    }
    return self;
}

- (void)createStorageServiceIfNeed {
    _storageService = [[YTKKeyValueStore alloc] initDBWithName:kStorageDBNameKey];
    [_storageService createTableWithName:kStorageTableLoginUserInfoKey];
}

#pragma mark - Public Method

- (void)updateLoginUser:(HTLoginUser *)loginUser {
    [_storageService putObject:[loginUser keyValues] withId:kStorageLoginUserKey intoTable:kStorageTableLoginUserInfoKey];
}

- (HTLoginUser *)getLoginUser {
    HTLoginUser *user = (HTLoginUser *)[HTLoginUser objectWithKeyValues:[_storageService getObjectById:kStorageLoginUserKey fromTable:kStorageTableLoginUserInfoKey]];
    return user;
}

- (void)updateUserID:(NSString *)userID {
    [_storageService putString:userID withId:kStorageUserIdKey intoTable:kStorageTableLoginUserInfoKey];
}

- (NSString *)getUserID {
    return [_storageService getStringById:kStorageUserIdKey fromTable:kStorageTableLoginUserInfoKey];
}

- (void)updatePwdSalt:(NSString *)salt {
    [_storageService putString:salt withId:kStorageSaltKey intoTable:kStorageTableLoginUserInfoKey];
}

- (NSString *)getPwdSalt {
    return [_storageService getStringById:kStorageSaltKey fromTable:kStorageTableLoginUserInfoKey];
}

- (void)updateQiniuToken:(NSString *)token {
    [_storageService putString:token withId:kQiniuTokenKey intoTable:kStorageTableLoginUserInfoKey];
}

- (NSString *)getQiniuToken {
    return [_storageService getStringById:kQiniuTokenKey fromTable:kStorageTableLoginUserInfoKey];
}

@end
