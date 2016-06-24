//
//  SKMascotService.h
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLogicHeader.h"

typedef void (^SKGetMascotsCallback) (BOOL success, NSArray<SKMascot *> *mascots);
typedef void (^SKGetMascotCallback) (BOOL success, SKMascot *mascot);
typedef void (^SKGetPropsCallback) (BOOL success, NSArray<SKMascotProp *> *props);
typedef void (^SKGetPropCallback) (BOOL success, SKMascotProp *prop);
typedef void (^SKGetRewardCallback) (BOOL success, SKResponsePackage *rsp);

@interface SKMascotService : NSObject

/**
 *  @brief 零仔收藏
 */
- (void)getUserMascots:(SKGetMascotsCallback)callback;

@end
