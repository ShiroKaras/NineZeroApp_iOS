//
//  SKCGIManager.h
//  NineZeroProject
//
//  Created by SinLemon on 16/6/16.
//  Copyright © 2016年 ;. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NETWORK_HOST @"http://90server.daoapp.io/"

@interface SKCGIManager : NSObject

#pragma mark - CGIKeys

+ (NSString *)userBaseLoginCGIKey;

+ (NSString *)userBaseRegisterCGIKey;

+ (NSString *)userResetPasswordCGIKey;


+ (NSString *)userBaseInfoCGIKey;

+ (NSString *)userProfileCGIKey;

+ (NSString *)userRankCGIKey;


+ (NSString *)questionCGIKey;

+ (NSString *)messageCGIKey;

+ (NSString *)restdayCGIKey;

+ (NSString *)rewardCGIKey;

+ (NSString *)answerCGIKey;


+ (NSString *)resourceCGIKey;

#pragma mark - Actions

#pragma mark 登录
/**
 *  @brief 手机号登录
 */
+ (NSString *)login_Phonenumber_Action;

/**
 *  @brief 第三方平台登录
 */
+ (NSString *)login_ThirdPlatform_Action;

#pragma mark 注册
/**
 *  @brief 申请注册服务
 */
+ (NSString *)register_newService_Action;

/**
 *  @brief 请求验证消息
 */
+ (NSString *)register_sendVerificationCode_Action;

/**
 *  @brief 检查验证码
 */
+ (NSString *)register_checkVerificaitonCode_Action;

/**
 *  @brief 创建新用户
 */
+ (NSString *)register_create_Action;

#pragma mark 修改密码
/**
 *  @brief 申请修改密码服务
 */
+ (NSString *)resetPassword_newService_Action;

/**
 *  @brief 请求发送验证消息
 */
+ (NSString *)resetPassword_sendVerificationCode_Action;

/**
 *  @brief 检查验证码
 */
+ (NSString *)resetPassword_checkVerificationCode_Action;

/**
 *  @brief 修改密码
 */
+ (NSString *)resetPassword_update_Action;

#pragma mark 修改用户名
/**
 *  @brief 修改用户名
 */
+ (NSString *)resetUserName_Action;

#pragma mark 修改头像
/**
 *  @brief 申请修改头像服务
 */
+ (NSString *)updateAvatar_newService_Action;

/**
 *  @brief 提交修改
 */
+ (NSString *)updateAvatar_update_Action;

#pragma mark 个人主页
/**
 *  @brief 个人主页信息
 */
+ (NSString *)profile_getProfile_Action;

/**
 *  @brief 获取排行榜信息
 */
+ (NSString *)profile_getRankList_Action;

/**
 *  @brief 金币记录
 */
+ (NSString *)profile_getGoldRecords_Action;

/**
 *  @brief 文章收藏列表
 */
+ (NSString *)profile_getCollectionAticles_Action;

/**
 *  @brief 零仔列表
 */
+ (NSString *)profile_getMascot_Action;

/**
 *  @brief 答题记录
 */
+ (NSString *)profile_getAnswerRecords_Action;

/**
 *  @brief 消息列表
 */
+ (NSString *)profile_getMessageList_Action;

#pragma mark 停赛日
/**
 *  @brief 停赛日判断
 */
+ (NSString *)restday_isRestday_Action;

/**
 *  @brief 停赛日信息
 */
+ (NSString *)restday_getRestday_Action;

#pragma mark 题目
/**
 *  @brief 当前题目
 */
+ (NSString *)question_getCurrentQuestion_Action;

/**
 *  @brief 获取题目列表
 */
+ (NSString *)question_getQuestionList_Action;

/**
 *  @brief 答题
 */
+ (NSString *)question_checkAnswer_Action;

#pragma mark 题目奖励
/**
 *  @brief 获取题目奖励
 */
+ (NSString *)reward_getReward_Action;

#pragma mark - 以下API不需要登录
/**
 *  @brief 获取所有零仔信息
 */
+ (NSString *)resource_getMascot_Action;

/**
 *  @brief 获取所有勋章信息
 */
+ (NSString *)resource_getMedals_Action;

@end
