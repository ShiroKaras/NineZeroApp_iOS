//
//  HTMascotService.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/25.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLogicHeader.h"

@class HTMascotProp;
@class HTMascot;
@class HTArticle;

typedef void (^HTGetMascotsCallback) (BOOL success, NSArray<HTMascot *> *mascots);
typedef void (^HTGetMascotCallback) (BOOL success, HTMascot *mascot);
typedef void (^HTGetPropsCallback) (BOOL success, NSArray<HTMascotProp *> *props);
typedef void (^HTGetPropCallback) (BOOL success, HTMascotProp *prop);
typedef void (^HTGetRewardCallback) (BOOL success, HTResponsePackage *rsp);

/**
 *  @brief 负责零仔和道具相关逻辑
 */
@interface HTMascotService : NSObject
/**
 *  @brief 获取当前用户的所有的零仔
 */
- (void)getUserMascots:(HTGetMascotsCallback)callback;
/**
 *  @brief 获取零仔的详情
 */
- (void)getUserMascotDetail:(uint64_t)mascotID completion:(HTGetMascotCallback)callback;
/**
 *  @brief 获取当前用户的所有的道具
 */
- (void)getUserProps:(HTGetPropsCallback)callback;
/**
 *  @brief 兑换道具
 */
- (void)exchangeProps:(HTMascotProp *)prop completion:(HTResponseCallback)callback;
/**
 *  @brief 获取奖励详情
 */
- (void)getRewardWithID:(uint64_t)rewardID questionID:(uint64_t)qid completion:(HTGetRewardCallback)callback;
@end
