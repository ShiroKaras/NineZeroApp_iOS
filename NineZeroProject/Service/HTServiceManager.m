//
//  HTServiceManager.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTServiceManager.h"
#import "HTStorageDefine.h"
#import <YTKKeyValueStore.h>
#import "HTLoginUser.h"

@implementation HTServiceManager {
    HTLoginService *_loginService;
    YTKKeyValueStore *_storageService;
}

+ (instancetype)sharedInstance {
    static HTServiceManager *serviceManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[HTServiceManager alloc] init];
    });
    return serviceManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _loginService = [[HTLoginService alloc] init];
        [self createStorageServiceIfNeed];
    }
    return self;
}

#pragma mark - Publice Method

- (void)createStorageServiceIfNeed {
    _storageService = [[YTKKeyValueStore alloc] initDBWithName:kStorageDBNameKey];
    [_storageService createTableWithName:kStorageTableLoginUserInfoKey];
}

- (YTKKeyValueStore *)storageService {
    return _storageService;
}

- (HTLoginService *)loginService {
    return _loginService;
}

@end
