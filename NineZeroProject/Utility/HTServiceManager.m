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

@implementation HTServiceManager

+ (instancetype)sharedInstance {
    static HTServiceManager *serviceManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[HTServiceManager alloc] init];
    });
    return serviceManager;
}

- (void)createStorageServiceIfNeed {
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:kStorageDBNameKey];
    [store createTableWithName:kStorageTableLoginUserInfoKey];
}

@end
