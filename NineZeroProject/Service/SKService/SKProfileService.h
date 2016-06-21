//
//  SKProfileService.h
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"

@interface SKProfileService : NSObject

/**
 *  @brief 修改用户名
 */
- (void)updateUsername:(NSString *)username completion:(SKResponseCallback)callback;

#pragma mark 修改头像
/**
 *  @brief 申请修改头像服务
 */
- (void)createUpdateAvatarService:(SKResponseCallback)callback;



@end
