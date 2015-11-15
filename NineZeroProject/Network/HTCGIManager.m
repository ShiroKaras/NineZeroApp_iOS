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
    return [NSString stringWithFormat:@"%@UserBase/register/", NETWORK_HOST];
}

+ (NSString *)userBaseLoginCGIKey {
    return [NSString stringWithFormat:@"%@UserBase/login/", NETWORK_HOST];
}

+ (NSString *)userBaseResetPwdCGIKey {
    return [NSString stringWithFormat:@"%@UserBase/reset/", NETWORK_HOST];
}

@end