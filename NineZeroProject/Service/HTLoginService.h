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
 */
@interface HTLoginService : NSObject

- (void)registerWithUser:(HTLoginUser *)user
                 success:(HTLoginSuccessCallback)successCallback
                   error:(HTLoginErrorCallback)errorCallback;

- (void)loginWithUser:(HTLoginUser *)user
              success:(HTLoginSuccessCallback)successCallback
                error:(HTLoginErrorCallback)errorCallback;

- (void)resetPassword:(NSString *)password;

- (HTLoginUser *)loginUser;

@end
NS_ASSUME_NONNULL_END