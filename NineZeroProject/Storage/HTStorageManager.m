//
//  HTStorageManager.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/25.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTStorageManager.h"
#import "HTStorageDefine.h"
#import "HTModel.h"
#import <YTKKeyValueStore.h>
#import <MJExtension.h>

@interface HTStorageManager ()
@end

@implementation HTStorageManager {
    YTKKeyValueStore *_storageService;
}

@synthesize userInfo = _userInfo;
@synthesize profileInfo = _profileInfo;
@synthesize mascotInfo = _mascotInfo;
@synthesize qiniuPublicToken = _qiniuPublicToken;

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
    [_storageService createTableWithName:kStorageTableKey];
}

#pragma mark - Public Method
#pragma mark 用户设置信息
- (void)setUserInfo:(HTUserInfo *)userInfo {
    _userInfo = userInfo;
    [_storageService putObject:[userInfo mj_keyValues] withId:kStorageUserInfoKey intoTable:kStorageTableKey];
}

- (HTUserInfo *)userInfo {
    if (_userInfo != nil) return _userInfo;
    _userInfo = [HTUserInfo mj_objectWithKeyValues:[_storageService getObjectById:kStorageUserInfoKey fromTable:kStorageTableKey]];
    return _userInfo;
}

#pragma mark 个人主页信息
- (void)setProfileInfo:(HTProfileInfo *)profileInfo {
    _profileInfo = profileInfo;
    [_storageService putObject:[profileInfo mj_keyValues] withId:kStorageProfileInfoKey intoTable:kStorageTableKey];
}

- (HTProfileInfo *)profileInfo {
    if (_profileInfo) return _profileInfo;
    _profileInfo = [HTProfileInfo mj_objectWithKeyValues:[_storageService getObjectById:kStorageProfileInfoKey fromTable:kStorageTableKey]];
    return _profileInfo;
}

#pragma mark 零仔信息
- (void)setMascotInfo:(HTMascot *)mascotInfo withIndex:(NSUInteger)index{
    _mascotInfo = mascotInfo;
    [_storageService putObject:[mascotInfo mj_keyValues] withId:[NSString stringWithFormat:@"%@_%lu",kStorageMascotInfoKey, (unsigned long)index] intoTable:kStorageTableKey];
}

- (HTMascot *)getMascotInfoWithIndex:(NSUInteger)index {
//    if (_mascotInfo)    return _mascotInfo;
    _mascotInfo = [HTMascot mj_objectWithKeyValues:[_storageService getObjectById:[NSString stringWithFormat:@"%@_%lu",kStorageMascotInfoKey, (unsigned long)index] fromTable:kStorageTableKey]];
    return _mascotInfo;
}

#pragma mark LoginUser
- (void)updateLoginUser:(HTLoginUser *)loginUser {
    [_storageService putObject:[loginUser mj_keyValues] withId:kStorageLoginUserKey intoTable:kStorageTableKey];
}

- (HTLoginUser *)getLoginUser {
    HTLoginUser *user = (HTLoginUser *)[HTLoginUser mj_objectWithKeyValues:[_storageService getObjectById:kStorageLoginUserKey fromTable:kStorageTableKey]];
    return user;
}

- (void)clearLoginUser {
    [_storageService deleteObjectById:kStorageLoginUserKey fromTable:kStorageTableKey];
}

#pragma mark 用户ID
- (void)updateUserID:(NSString *)userID {
    [_storageService putString:userID withId:kStorageUserIdKey intoTable:kStorageTableKey];
}

- (NSString *)getUserID {
    return [_storageService getStringById:kStorageUserIdKey fromTable:kStorageTableKey];
}

- (void)clearUserID {
    [_storageService deleteObjectById:kStorageUserIdKey fromTable:kStorageTableKey];
}

#pragma mark 用户LoginToken
- (void)updateUserToken:(NSString *)token {
    [_storageService putString:token withId:kStorageUserTokenKey intoTable:kStorageTableKey];
}

- (NSString *)getUserToken {
    return [_storageService getStringById:kStorageUserTokenKey fromTable:kStorageTableKey];
}

- (void)clearUserToken {
    [_storageService deleteObjectById:kStorageUserTokenKey fromTable:kStorageTableKey];
}

#pragma mark PwdSalt(无用)
- (void)updatePwdSalt:(NSString *)salt {
    [_storageService putString:salt withId:kStorageSaltKey intoTable:kStorageTableKey];
}

- (NSString *)getPwdSalt {
    return [_storageService getStringById:kStorageSaltKey fromTable:kStorageTableKey];
}

- (void)updateQiniuToken:(NSString *)token {
    [_storageService putString:token withId:kQiniuTokenKey intoTable:kStorageTableKey];
}

#pragma mark 七牛token
- (NSString *)getQiniuToken {
    return [_storageService getStringById:kQiniuTokenKey fromTable:kStorageTableKey];
}

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
