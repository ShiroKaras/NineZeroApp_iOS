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
#import "HTModel.h"

@implementation HTServiceManager {
    HTLoginService *_loginService;
    HTQuestionService *_questionService;
    HTMascotService *_mascotService;
    QNUploadManager *_qiniuService;
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

- (QNUploadManager *)qiniuService {
    return _qiniuService;
}

@end
