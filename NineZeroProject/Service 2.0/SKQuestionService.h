//
//  SKQuestionService.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"
#import "SKLogicHeader.h"

@interface SKQuestionService : NSObject

- (void)questionBaseRequestWithParam:(NSDictionary*)dict callback:(SKResponseCallback)callback;

//全部关卡（不含极难题）
- (void)getAllQuestionListCallback:(SKResponseCallback)callback;

//

@end
