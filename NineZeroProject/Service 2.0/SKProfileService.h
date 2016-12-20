//
//  SKProfileService.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"
#import "SKLogicHeader.h"

typedef void (^SKProfileInfoCallback) (BOOL success, SKProfileInfo *response);
typedef void (^SKUserInfoCallback) (BOOL success, SKUserInfo *response);
typedef void (^SKGetBadgesCallback) (BOOL success, NSInteger exp, NSArray<SKBadge *> *badges) ;

@interface SKProfileService : NSObject

//获取个人信息
- (void)getUserInfoDetailCallback:(SKProfileInfoCallback)callback;

//获取礼券列表
- (void)getUserTicketsCallbackCallback:(SKResponseCallback)callback;

//获取个人排名
- (void)getUserRankCallback:(SKResponseCallback)callback;

//获取个人通知列表
- (void)getUserNotificationCallback:(SKResponseCallback)callback;

//获取基本信息
- (void)getUserBaseInfoCallback:(SKUserInfoCallback)callback;

//获取所有排名
- (void)getAllRankListCallback:(SKResponseCallback)callback;

//修改个人设置
- (void)updateSettingWith:(SKUserSetting*)userSetting callback:(SKResponseCallback)callback;

//修改个人信息
- (void)updateUserInfoWith:(SKLoginUser*)userInfo callback:(SKResponseCallback)callback;

//用户反馈
- (void)feedbackWithContent:(NSString *)content contact:(NSString *)contact completion:(SKResponseCallback)callback;

//重新获取用户信息
- (void)updateUserInfoFromServer;

//获取勋章
- (void)getBadges:(SKGetBadgesCallback)callback;

@end
