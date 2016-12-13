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

@synthesize userInfo = _userInfo;
@synthesize qiniuPublicToken = _qiniuPublicToken;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SKStorageManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[SKStorageManager alloc] init];
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
    [_storageService createTableWithName:kStorageTableKey];
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

#pragma mark - User info

- (void)setUserInfo:(SKUserInfo *)userInfo {
    _userInfo = userInfo;
    [_storageService putObject:[userInfo keyValues] withId:kStorageUserInfoKey intoTable:kStorageTableKey];
}

- (SKUserInfo *)userInfo {
    if (_userInfo != nil) return _userInfo;
    _userInfo = [SKUserInfo objectWithKeyValues:[_storageService getObjectById:kStorageUserInfoKey fromTable:kStorageTableKey]];
    return _userInfo;
}

#pragma mark - Qiniu token

- (void)setQiniuPublicToken:(NSString *)qiniuPublicToken {
    _qiniuPublicToken = qiniuPublicToken;
    [_storageService putString:qiniuPublicToken withId:kQiniuPublicTokenKey intoTable:kStorageTableKey];
}

- (NSString *)qiniuPublicToken {
    if (!_qiniuPublicToken) {
        _qiniuPublicToken = [_storageService getStringById:_qiniuPublicToken fromTable:kStorageTableKey];
    }
    return _qiniuPublicToken;
}

@end
