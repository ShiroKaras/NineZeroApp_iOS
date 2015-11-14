//
//  HTCGIManager.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NETWORK_HOST @"http://115.159.115.215:8021/"


extern NSString *const kCGIUserBaseRegisterKey;

// 登录
/**
 1. {
 2. "user_name":"90",
 3. "user_password":"*******"
 4. }
 */
extern NSString *const kCGIUserBaseLoginKey;

// 重置密码
/**
 1. {
 2. "user_name":"90",
 3. "user_password":"*******"
 4. }
 */
extern NSString *const kCGIUserBaseResetPwdKey;

@interface HTCGIManager : NSObject

/**
 * 注册
 ￼1. {
 2. "user_name":"90",
 3. "user_password":"*******"
 4. "user_mobile":"13212345678"
 5. "user_email":"test@qq.com"
 6. "user_avatar":"http://www.baidu.com/"
 7. "user_area_id":1,
 8. "code":"4578"
 9. }
 */
+ (NSString *)userBaseRegisterCGIKey;

/**
 * 登录
 1. {
 2. "user_name":"90",
 3. "user_password":"*******"
 4. }
 */
+ (NSString *)userBaseLoginCGIKey;

/**
 * 重置密码
 1. {
 2. "user_name":"90",
 3. "user_password":"*******"
 4. }
 */
+ (NSString *)userBaseResetPwdCGIKey;

@end
