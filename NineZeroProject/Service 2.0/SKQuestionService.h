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

@class SKQuestion;

typedef void (^SKQuestionListCallback) (BOOL success,NSInteger answeredQuestion_season1, NSInteger answeredQuestion_season2, NSArray<SKQuestion *> *questionList_season1, NSArray<SKQuestion *> *questionList_season2);
typedef void (^SKQuestionDetialCallback) (BOOL success, SKQuestion *question);

@interface SKQuestionService : NSObject

- (void)questionBaseRequestWithParam:(NSDictionary*)dict callback:(SKResponseCallback)callback;

//全部关卡（不含极难题）
- (void)getAllQuestionListCallback:(SKQuestionListCallback)callback;

//极难题列表
- (void)getDifficultQuestionListCallback:(SKResponseCallback)callback;

//题目详情
- (void)getQuestionDetailWithQuestionID:(NSString*)questionID callback:(SKQuestionDetialCallback)callback;

//关卡线索列表
- (void)getQuestionDetailCluesWithQuestionID:(NSString*)questionID callback:(SKResponseCallback)callback;

//购买线索
- (void)purchaseQuestionClueWithQuestionID:(NSString*)questionID callback:(SKResponseCallback)callback;

@end
