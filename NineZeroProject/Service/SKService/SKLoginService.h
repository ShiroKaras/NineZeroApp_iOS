//
//  SKLoginService.h
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"

@class HTLoginUser;

NS_ASSUME_NONNULL_BEGIN

@interface SKLoginService : NSObject

//*************************
// 业务相关
#pragma mark 登录
/**
 *  @brief 手机号登录
 */
- (void)loginWithUser:(HTLoginUser *)user
           completion:(SKResponseCallback)callback;

/**
 *  @brief 第三方平台登录
 */
- (void)bindUserWithThirdPlatform:(HTLoginUser *)user completion:(SKResponseCallback)callback;

#pragma mark 注册
/**
 *  @brief 创建注册服务
 */
- (void)createRegisterService:(SKResponseCallback)callback;

/**
 *  @brief 获取验证码
 */
- (void)getRegisterVerifyCodeWithMobile:(NSString *)mobile completion:(SKResponseCallback)callback;

/**
 *  @brief 验证验证码
 */
- (void)checkRegisterVerifyCodeWithPhone:(NSString *)mobile code:(NSString *)code completion:(SKResponseCallback)callback;

/**
 *  @brief 注册
 */
- (void)registerWithUser:(HTLoginUser *)user completion:(SKResponseCallback)callback;

#pragma mark 七牛
/**
 *  @brief 获取七牛token
 */
- (void)getQiniuPrivateTokenWithCompletion:(SKGetTokenCallback)callback;
- (void)getQiniuPublicTokenWithCompletion:(SKGetTokenCallback)callback;

//***************************
// Get相关
- (HTLoginUser *)loginUser;
- (NSString *)qiniuToken;

- (void)quitLogin;

@end

NS_ASSUME_NONNULL_END
