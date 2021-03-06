//
//  SKSecretaryService.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/2/27.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "SKLogicHeader.h"
#import "SKNetworkDefine.h"
#import <Foundation/Foundation.h>

@class SKChatObject;

typedef void (^SKChatFlowCallback) (BOOL success, NSArray<SKChatObject *> *chatFlowArray);

@interface SKSecretaryService : NSObject

- (void)showSecretaryWithPage:(NSInteger)page callback:(SKChatFlowCallback)callback;

- (void)sendFeedback:(NSString *)content callback:(SKResponseCallback)callback;

- (void)showSecretaryNoticeListWithCallback:(SKResponseCallback)callback;

@end
