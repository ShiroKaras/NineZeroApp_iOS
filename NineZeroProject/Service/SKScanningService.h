//
//  SKScanningService.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/2/9.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "SKLogicHeader.h"
#import "SKNetworkDefine.h"
#import <Foundation/Foundation.h>

@interface SKScanningService : NSObject

typedef void (^SKScanningCallback)(BOOL success, SKResponsePackage *package);

- (void)getScanningWithCallBack:(SKScanningCallback)callback;

- (void)getScanningRewardWithRewardId:(NSString *)rewardId callback:(SKResponseCallback)callback;

- (void)getScanningRewardWithRewardId:(NSString *)rewardId sId:(NSString *)sId callback:(SKResponseCallback)callback;

- (void)getScanningPuzzleRewardWithRewardId:(NSString *)rewardId sId:(NSString *)sId callback:(SKResponseCallback)callback;

- (void)getScanningPuzzleWithMontageId:(NSString *)montageId sId:(NSString *)sId callback:(SKResponseCallback)callback;

- (void)getAllScanningWithCallBack:(SKScanningCallback)callback;

@end
