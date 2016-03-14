//
//  HTProfileService.h
//  NineZeroProject
//
//  Created by ronhu on 16/3/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTNotification;
@class HTReward;

typedef void (^HTGetNotificationsCallback) (BOOL success, NSArray<HTNotification *> *props);
typedef void (^HTGetRewardsNotificationCallback) (BOOL success, NSArray<HTReward *> *props);

/**
 *  @brief 负责个人中心相关逻辑
 */
@interface HTProfileService : NSObject
/**
 *  @brief 获取通知列表
 */
- (void)getNotifications:(HTGetNotificationsCallback)callback;
/**
 *  @brief 获取礼券列表
 */
- (void)getRewards:(HTGetRewardsNotificationCallback)callback;
@end
