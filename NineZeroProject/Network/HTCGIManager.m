//
//  HTCGIManager.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCGIManager.h"

@implementation HTCGIManager

+ (NSString *)userBaseRegisterCGIKey {
    return [NSString stringWithFormat:@"%@Login/register/", NETWORK_HOST];
}

+ (NSString *)userBaseLoginCGIKey {
    return [NSString stringWithFormat:@"%@Login/login/", NETWORK_HOST];
}

+ (NSString *)userBaseResetPwdCGIKey {
    return [NSString stringWithFormat:@"%@Login/reset/", NETWORK_HOST];
}

+ (NSString *)getQiniuTokenCGIKey {
    return [NSString stringWithFormat:@"%@Common/getQiniuToken", NETWORK_HOST];
}

+ (NSString *)getQiniuDownloadUrlCGIKey {
    return [NSString stringWithFormat:@"%@Common/getDownloadUrl", NETWORK_HOST];
}

+ (NSString *)getQuestionInfoCGIKey {
    return [NSString stringWithFormat:@"%@Question/info", NETWORK_HOST];
}

+ (NSString *)getQuestionListCGIKey {
    return [NSString stringWithFormat:@"%@Question/getList", NETWORK_HOST];
}

+ (NSString *)getQuestionDetailCGIKey {
    return [NSString stringWithFormat:@"%@Question/detail", NETWORK_HOST];
}

+ (NSString *)getExtraHintCGIKey {
    return [NSString stringWithFormat:@"%@Question/getRestHint", NETWORK_HOST];
}

+ (NSString *)verifyAnswerCGIKey {
    return [NSString stringWithFormat:@"%@Answer/answerText", NETWORK_HOST];
}

@end