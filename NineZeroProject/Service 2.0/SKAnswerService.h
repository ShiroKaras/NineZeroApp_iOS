//
//  SKAnswerService.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/8.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkDefine.h"
#import "SKLogicHeader.h"
#import "CommonDefine.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface SKAnswerService : NSObject

//限时关卡文字题答题接口
- (void)answerTimeLimitTextQuestionWithAnswerText:(NSString*)answerText callback:(SKResponseCallback)callback;

//往期关卡答题接口
- (void)answerExpiredTextQuestionWithQuestionID:(NSString*)questionID answerText:(NSString*)answerText callback:(SKResponseCallback)callback;

//使用道具答题
- (void)answerExpiredTextQuestionWithQuestionID:(NSString*)questionID answerPropsCount:(NSString*)answerPropsCount callback:(SKResponseCallback)callback;

//限时关卡LBS题答题接口
- (void)answerLBSQuestionWithLocation:(CLLocation*)location callback:(SKResponseCallback)callback;

//限时关卡扫描图片答题接口
- (void)answerScanningARWithQuestionID:(NSString*)questionID callback:(SKResponseCallback)callback;

//极难题答题接口
- (void)answerDifficultQuestionWithQuestionID:(NSString*)questionID answerText:(NSString*)answerText callback:(SKResponseCallback)callback;

@end
