//
//  HTCGIManager.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#define RETURN_CGI(KEY) return [NSString stringWithFormat:@"%@KEY", NETWORK_HOST]

#import <Foundation/Foundation.h>
#import "HTCGIManager.h"

@implementation HTCGIManager

+ (NSString *)userBaseRegisterCGIKey {
    RETURN_CGI(@"Login/register/");
}

+ (NSString *)userBaseLoginCGIKey {
    RETURN_CGI(@"Login/login/");
}

+ (NSString *)userBaseResetPwdCGIKey {
    RETURN_CGI(@"Login/reset/");
}

+ (NSString *)getQiniuTokenCGIKey {
    RETURN_CGI(@"Common/getQiniuToken/");
}

+ (NSString *)getQiniuDownloadUrlCGIKey {
    RETURN_CGI(@"Common/getDownloadUrl/");
}

+ (NSString *)getQuestionInfoCGIKey {
    RETURN_CGI(@"Question/info/");
}

+ (NSString *)getQuestionListCGIKey {
    RETURN_CGI(@"Question/getList/");
}

+ (NSString *)getQuestionDetailCGIKey {
    RETURN_CGI(@"Question/detail/");
}

+ (NSString *)getExtraHintCGIKey {
    RETURN_CGI(@"Question/getRestHint/");
}

+ (NSString *)verifyAnswerCGIKey {
    RETURN_CGI(@"Answer/answerText/");
}

@end