//
//  SKProfileService.h
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  CopyrigSK © 2016年 ronhu. All rigSKs reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"

typedef void (^SKBackupUserInfoCallBack) (BOOL success, NSDictionary *backupDict);
typedef void (^SKGetProfileInfoCallback) (BOOL success, SKProfileInfo *profileInfo);
typedef void (^SKGetNotificationsCallback) (BOOL success, NSArray<SKNotification *> *notifications);
typedef void (^SKGetRewardsCallback) (BOOL success, NSArray<SKTicket *> *rewards);
typedef void (^SKGetUserInfoCallback) (BOOL success, SKUserInfo *userInfo);
typedef void (^SKGetArticlesCallback) (BOOL success, NSArray<SKArticle *> *articles);
typedef void (^SKGetArticleCallback) (BOOL success, SKArticle *articles);
typedef void (^SKGetMyRankCallback) (BOOL success, SKRanker *ranker);
typedef void (^SKGetRankListCallback) (BOOL success, NSArray<SKRanker *> *rankList);
typedef void (^SKGetBadgesCallback) (BOOL success, NSArray<SKBadge *> *badges) ;
typedef void (^SKGetGoldRecordCallback) (BOOL success, NSArray<SKGoldRecord *> *goldrecordList);

@interface SKProfileService : NSObject

/**
 *  @brief 修改用户名
 */
- (void)updateUsername:(SKUserInfo *)username completion:(SKResponseCallback)callback;

#pragma mark 修改头像
/**
 *  @brief 申请修改头像服务
 */
- (void)createUpdateAvatarService:(SKResponseCallback)callback;

//- (void)updateUserAvatar:()

#pragma mark 主页信息
/**
 *  @brief 个人主页整合数据
 */
- (void)getProfileInfo:(SKGetProfileInfoCallback)callback;

/**
 *  @brief 排行榜
 */
- (void)getRankList:(SKGetRankListCallback)callback;

/**
 *  @brief 金币记录
 */
- (void)getGoldRecord:(SKGetGoldRecordCallback)callback;

/**
 *  @brief 文章收藏列表
 */
- (void)getArticleCollectionList:(SKGetArticlesCallback)callback;

/**
 *  @brief 消息列表
 */
- (void)getNotificationList:(SKGetNotificationsCallback)callback;

#pragma mark 文章

- (void)getArticle:(NSString *)articleID completion:(SKGetArticleCallback)callback;

@end
