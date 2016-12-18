//
//  SKPropService.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"
#import "SKLogicHeader.h"

@interface SKPropService : NSObject

typedef void (^SKQuestionBuyPropCallback) (BOOL success, NSString *responseString);

//购买道具
- (void)purchasePropWithPurchaseType:(NSString*)purchaseType propType:(NSString*)propType callback:(SKQuestionBuyPropCallback)callback;

//使用道具
- (void)usePropWithQuestionID:(NSString*)questionID seasonType:(NSString*)type callback:(SKResponseCallback)callback;


@end
