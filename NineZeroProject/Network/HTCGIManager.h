//
//  HTCGIManager.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NETWORK_HOST @"http://115.159.115.215:8992/"

@interface HTCGIManager : NSObject

/**
 -1001	模块名未定义
 -2000	注册失败，请重试
 -2001	注册失败，手机号已注册
 -2002	注册失败，用户名已存在
 -2004	登陆失败，请重试
 -2005	重置密码失败
 */

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

/**
 *  获取七牛token
 */
+ (NSString *)getQiniuTokenCGIKey;

@end
