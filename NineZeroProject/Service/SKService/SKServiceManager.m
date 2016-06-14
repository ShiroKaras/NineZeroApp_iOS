//
//  SKServiceManager.m
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKServiceManager.h"

@implementation SKServiceManager {
    SKLoginService *_loginService;
    SKQuestionService *_questionService;
    SKMascotService *_mascotService;
    QNUploadManager *_qiniuService;
    SKProfileService *_profileService;
}

+ (instancetype)sharedInstance {
    static SKServiceManager *serviceManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[SKServiceManager alloc] init];
    });
    return serviceManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _loginService = [[SKLoginService alloc] init];
        _questionService = [[SKQuestionService alloc] init];
        _qiniuService = [[QNUploadManager alloc] init];
        _mascotService = [[SKMascotService alloc] init];
        _profileService = [[SKProfileService alloc] init];
    }
    return self;
}

#pragma mark - Publice Method

- (SKLoginService *)loginService {
    return _loginService;
}

- (SKQuestionService *)questionService {
    return _questionService;
}

- (SKMascotService *)mascotService {
    return _mascotService;
}

- (SKProfileService *)profileService {
    return _profileService;
}

- (QNUploadManager *)qiniuService {
    return _qiniuService;
}

- (HTStorageManager *)storageManager {
    return [HTStorageManager sharedInstance];
}
@end
