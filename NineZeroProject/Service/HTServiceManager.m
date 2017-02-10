//
//  HTServiceManager.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/9.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTServiceManager.h"
#import "HTStorageDefine.h"
#import <YTKKeyValueStore.h>
#import "HTModel.h"

@implementation HTServiceManager {
    HTLoginService *_loginService;
    HTQuestionService *_questionService;
    HTMascotService *_mascotService;
    QNUploadManager *_qiniuService;
    HTProfileService *_profileService;
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
        _questionService = [[HTQuestionService alloc] init];
        _qiniuService = [[QNUploadManager alloc] init];
        _mascotService = [[HTMascotService alloc] init];
        _profileService = [[HTProfileService alloc] init];
    }
    return self;
}

#pragma mark - Publice Method

- (HTLoginService *)loginService {
    return _loginService;
}

- (HTQuestionService *)questionService {
    return _questionService;
}

- (HTMascotService *)mascotService {
    return _mascotService;
}

- (HTProfileService *)profileService {
    return _profileService;
}

- (QNUploadManager *)qiniuService {
    return _qiniuService;
}

- (HTStorageManager *)storageManager {
    return [HTStorageManager sharedInstance];
}

@end