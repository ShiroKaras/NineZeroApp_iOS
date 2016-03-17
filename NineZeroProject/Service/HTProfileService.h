//
//  HTProfileService.h
//  NineZeroProject
//
//  Created by ronhu on 16/3/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLogicHeader.h"

typedef void (^HTGetProfileInfoCallback) (BOOL success, HTProfileInfo *profileInfo);
typedef void (^HTGetNotificationsCallback) (BOOL success, NSArray<HTNotification *> *notifications);
typedef void (^HTGetRewardsCallback) (BOOL success, NSArray<HTReward *> *rewards);
typedef void (^HTGetUserInfoCallback) (BOOL success, HTUserInfo *userInfo);
typedef void (^HTGetMyRankCallback) (BOOL success, HTRanker *ranker);
typedef void (^HTGetRankListCallback) (BOOL success, NSArray<HTRanker *> *ranker);
typedef void (^HTGetBadgesCallback) (BOOL success, NSArray<HTBadge *> *badges) ;

/**
 *  @brief 负责个人中心相关逻辑
 */
@interface HTProfileService : NSObject
/**
 *  @brief 获取个人主页信息
 */
- (void)getProfileInfo:(HTGetProfileInfoCallback)callback;
/**
 *  @brief 获取个人信息
 */
- (void)getUserInfo:(HTGetUserInfoCallback)callback;
/**
 *  @brief 更新个人信息
 *  @param userInfo  待更新的个人信息
 */
- (void)updateUserInfo:(HTUserInfo *)userInfo completion:(HTResponseCallback)callback;
/**
 *  @brief 获取通知列表
 */
- (void)getNotifications:(HTGetNotificationsCallback)callback;
/**
 *  @brief 获取礼券列表
 */
- (void)getRewards:(HTGetRewardsCallback)callback;
/**
 *  @brief 获取勋章
 */
- (void)getBadges:(HTGetBadgesCallback)callback;
/**
 *  @brief 获取自己的排名
 */
- (void)getMyRank:(HTGetMyRankCallback)callback;
/**
 *  @brief 获取排名列表
 */
- (void)getRankList:(HTGetRankListCallback)callback;
@end
