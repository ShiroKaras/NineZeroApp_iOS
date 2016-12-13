//
//  SKServiceManager.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKServiceManager.h"

@implementation SKServiceManager {
    SKLoginService      *_loginService;
    SKQuestionService   *_questionService;
    SKProfileService    *_profileService;
    SKPropService       *_propService;
    SKMascotService     *_mascotService;
    SKAnswerService     *_answerService;
    SKCommonService     *_commonService;
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
        _loginService       = [[SKLoginService alloc] init];
        _questionService    = [[SKQuestionService alloc] init];
        _profileService     = [[SKProfileService alloc] init];
        _propService        = [[SKPropService alloc] init];
        _mascotService      = [[SKMascotService alloc] init];
        _answerService      = [[SKAnswerService alloc] init];
        _commonService      = [[SKCommonService alloc] init];
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

- (SKProfileService *)profileService {
    return _profileService;
}

- (SKPropService *)propService {
    return _propService;
}

- (SKMascotService *)mascotService {
    return _mascotService;
}

- (SKAnswerService *)answerService {
    return _answerService;
}

- (SKCommonService *)commonService {
    return _commonService;
}

@end
