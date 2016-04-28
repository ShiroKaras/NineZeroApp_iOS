//
//  HTProfileService.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/14.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLogicHeader.h"

typedef void (^HTGetProfileInfoCallback) (BOOL success, HTProfileInfo *profileInfo);
typedef void (^HTGetNotificationsCallback) (BOOL success, NSArray<HTNotification *> *notifications);
typedef void (^HTGetRewardsCallback) (BOOL success, NSArray<HTTicket *> *rewards);
typedef void (^HTGetUserInfoCallback) (BOOL success, HTUserInfo *userInfo);
typedef void (^HTGetArticlesCallback) (BOOL success, NSArray<HTArticle *> *articles);
typedef void (^HTGetArticleCallback) (BOOL success, HTArticle *articles);
typedef void (^HTGetMyRankCallback) (BOOL success, HTRanker *ranker);
typedef void (^HTGetRankListCallback) (BOOL success, NSArray<HTRanker *> *ranker);
typedef void (^HTGetBadgesCallback) (BOOL success, NSArray<HTBadge *> *badges) ;

typedef NS_ENUM(NSUInteger, HTUpdateUserInfoType) {
    HTUpdateUserInfoTypeAvatar,
    HTUpdateUserInfoTypeName,
    HTUpdateUserInfoTypePushSetting,
    HTUpdateUserInfoTypeAddressAndMobile,
};

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
 *  @param userInfo  待更新的个人信息，注意填上对应的设置HTUpdateUserInfoType
 */
- (void)updateUserInfo:(HTUserInfo *)userInfo completion:(HTResponseCallback)callback;
/**
 *  @brief 从svr上更新userinfo
 */
- (void)updateUserInfoFromSvr;
/**
 *  @brief 获取通知列表
 */
- (void)getNotifications:(HTGetNotificationsCallback)callback;
/**
 *  @brief 意见反馈
 */
- (void)feedbackWithContent:(NSString *)content mobile:(NSString *)mobile completion:(HTResponseCallback)callback;
/**
 *  @brief 获取礼券列表
 */
- (void)getRewards:(HTGetRewardsCallback)callback;
/**
 *  @brief 获取文章
 */
- (void)getArticle:(uint64_t)articleID completion:(HTGetArticleCallback)callback;
/**
 *  @brief 获取往期文章
 */
- (void)getArticlesInPastWithPage:(NSUInteger)page count:(NSUInteger)count callback:(HTGetArticlesCallback)callback;
/**
 *  @brief 获取收藏文章列表
 */
- (void)getCollectArticlesWithPage:(NSUInteger)page count:(NSUInteger)count callback:(HTGetArticlesCallback)callback;
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
/**
 *  @brief 收藏文章
 */
- (void)collectArticleWithArticleID:(NSUInteger)articleID completion:(HTResponseCallback)callback;
@end
