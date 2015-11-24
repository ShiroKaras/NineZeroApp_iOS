//
//  HTStorageManager.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/25.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTStorageManager.h"
#import "HTStorageDefine.h"
#import <YTKKeyValueStore.h>

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

@end
