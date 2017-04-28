//
//  SKMascotService.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"
#import "SKLogicHeader.h"

typedef void (^SKMascotListCallback) (BOOL success, NSArray<SKPet*> *mascotArray);
typedef void (^SKDefaultMascotCallback) (BOOL success, SKDefaultMascotDetail *defaultMascot);
typedef void (^NZMascotArrayCallback) (BOOL success, NSArray<SKMascot*> *mascots);
typedef void (^NZMascotCoopTimeRankListCallback) (BOOL success, NSArray<SKRanker*> *rankerList);

@interface SKMascotService : NSObject

//获取所有用户原始零仔
- (void)getMascotsCallback:(SKMascotListCallback)callback;

//获取所有家族零仔
- (void)getFamilyMascotCallback:(SKResponseCallback)callback;

//获取默认零仔详情
- (void)getDefaultMascotDetailCallback:(SKDefaultMascotCallback)callback;

////获取其他零仔详情
//- (void)getMascotDetailWithMascotID:(NSString*)mascotID callback:(SKMascotListCallback)callback;

//使用零仔技能
- (void)useMascotSkillWithMascotID:(NSString*)mascotID callback:(SKResponseCallback)callback;

//零仔战斗随机字符串
- (void)getRandomStringWithMascotID:(NSString*)mascotID callback:(SKResponseCallback)callback;

//零仔战斗获取奖励
- (void)mascotBattleWithMascotID:(NSString*)mascotID randomString:(NSString*)randomString callback:(SKResponseCallback)callback;

#pragma mark - 3.0

//获取所有零仔关押时间
- (void)getAllPetsCoopTimeCallback:(NZMascotArrayCallback)callback;

//零仔关押时间排名
- (void)getMascotCoopTimeRankListCallback:(NZMascotCoopTimeRankListCallback)callback;

//获取其他零仔详情
- (void)getMascotDetailWithMascotID:(NSString*)mascotID callback:(void (^)(BOOL, SKMascot *))callback;

//获取零仔证据详情
- (void)getMascotEvidenceDetailWithID:(NSString *)eid callback:(void(^)(BOOL success, SKMascotEvidence *evidence))callback;

@end
