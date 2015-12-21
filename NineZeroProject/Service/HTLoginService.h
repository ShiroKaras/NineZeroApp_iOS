//
//  HTLoginService.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/15.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTNetworkDefine.h"

@class HTLoginUser;

NS_ASSUME_NONNULL_BEGIN

/**
 *  该类只允许HTServiceManager创建一次，多次创建直接crash
 *  通过HTServiceManager拿到该类的唯一实例
 *  负责登录注册相关逻辑
 */
@interface HTLoginService : NSObject

//*************************
// 业务相关

/**
 *  @brief 注册
 */
- (void)registerWithUser:(HTLoginUser *)user
              completion:(HTResponseCallback)callback;

/**
 *  @brief 登录
 */
- (void)loginWithUser:(HTLoginUser *)user
           completion:(HTResponseCallback)callback;

/**
 *  @brief 重置密码
 */
- (void)resetPasswordWithUser:(HTLoginUser *)user
                   completion:(HTResponseCallback)callback;

/**
 *  @brief 验证手机号
 */
- (void)verifyMobile:(NSString *)mobile
          completion:(HTResponseCallback)callback;

/**
 *  @brief 获取七牛token
 */
- (void)getQiniuTokenWithCompletion:(HTGetTokenCallback)callback;

//***************************
// Get相关
- (HTLoginUser *)loginUser;
- (NSString *)qiniuToken;

@end
NS_ASSUME_NONNULL_END