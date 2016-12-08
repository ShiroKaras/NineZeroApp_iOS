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

//极难题列表
- (void)getDifficultQuestionListCallback:(SKResponseCallback)callback;

//题目详情
- (void)getQuestionDetailWithQuestionID:(NSString*)questionID callback:(SKResponseCallback)callback;

//关卡线索列表
- (void)getQuestionDetailCluesWithQuestionID:(NSString*)questionID callback:(SKResponseCallback)callback;

//购买线索
- (void)purchaseQuestionClueWithQuestionID:(NSString*)questionID callback:(SKResponseCallback)callback;

@end
