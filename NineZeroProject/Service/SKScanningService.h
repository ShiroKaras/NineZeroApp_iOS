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

- (void)getScanningRewardWithRewardID:(NSString *)rewardID callback:(SKResponseCallback)callback;

@end
