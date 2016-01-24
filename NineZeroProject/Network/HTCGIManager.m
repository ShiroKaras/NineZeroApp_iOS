//
//  HTCGIManager.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCGIManager.h"

#define CGI_EXTRA(e) [NSString stringWithFormat:@"%@e", NETWORK_HOST]

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

+ (NSString *)userBaseVerifyMobileCGIKey {
    return [NSString stringWithFormat:@"%@Login/check_mobile/", NETWORK_HOST];
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

+ (NSString *)getRewardCGIKey {
    return [NSString stringWithFormat:@"%@Question/getReward", NETWORK_HOST];
}

+ (NSString *)getMascotsCGIKey {
    return [NSString stringWithFormat:@"%@Pet/getPets", NETWORK_HOST];
}

+ (NSString *)getMascotPropsCGIKey {
    return CGI_EXTRA(Pet/getProps);
}

+ (NSString *)getMascotInfoCGIKey {
    return CGI_EXTRA(Pet/getPetDetail);
}

+ (NSString *)getMascotPropInfoCGIKey {
    return CGI_EXTRA(Pet/getPropDetail);
}

+ (NSString *)verifyAnswerCGIKey {
    return [NSString stringWithFormat:@"%@Answer/answerText", NETWORK_HOST];
}

@end