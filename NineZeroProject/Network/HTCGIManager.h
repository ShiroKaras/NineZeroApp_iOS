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
 * @brief 注册
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
 *  @brief 验证手机号是否已经被注册
 *  "user_mobile" : "11111111111"
 */
+ (NSString *)userBaseVerifyMobileCGIKey;

/**
 * @brief 登录
 1. {
 2. "user_name":"90",
 3. "user_password":"*******"
 4. }
 */
+ (NSString *)userBaseLoginCGIKey;

/**
 * @brief 重置密码
1.  {
2.  "user_mobile":"13212345678",
3.  "code":"4578",
4.  "user_password":"*******"
5.  }
 */
+ (NSString *)userBaseResetPwdCGIKey;

/**
 *  @brief 获取题目相关的总体信息
 *  "area_id":"1"
 */
+ (NSString *)getQuestionInfoCGIKey;

/**
 *  @brief 获取题目列表
 *  "area_id":"1"
 *  "page":"1"
 *  "count":"10"
 */
+ (NSString *)getQuestionListCGIKey;

/**
 *  @brief 获取题目详情
 *  "question_id":"2015120423201902904"
 */
+ (NSString *)getQuestionDetailCGIKey;

/**
 *  @brief 获取额外的提示
 */
+ (NSString *)getExtraHintCGIKey;

/**
 *  @brief 获取奖励详情
 *  "reward_id" : 1
 */
+ (NSString *)getRewardCGIKey;

/**
 *  @brief 验证回答答案
 *  "question_id" : "2015120423201902904"
 *  "answer" : "testtest"
 */
+ (NSString *)verifyAnswerCGIKey;

/**
 *  @brief 获取七牛token
 *  "key" : "vedio.mp4"
 */
+ (NSString *)getQiniuTokenCGIKey;

/**
 *  @brief 获取七牛下载链接
 */
+ (NSString *)getQiniuDownloadUrlCGIKey;

@end
