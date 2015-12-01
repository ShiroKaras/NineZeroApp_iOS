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

@end