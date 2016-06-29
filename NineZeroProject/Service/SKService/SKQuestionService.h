//
//  SKQuestionService.h
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLogicHeader.h"

typedef void (^SKQuestionCallback) (BOOL success, SKQuestion *question);
typedef void (^SKQuestionListCallback) (BOOL success, NSArray<SKQuestion *> *questionList);
typedef void (^SKQuestionInfoCallback) (BOOL success, SKQuestionInfo *questionInfo);
typedef void (^SKGetRewardCallback) (BOOL success, SKResponsePackage *rsp);

@interface SKQuestionService : NSObject

- (void)getQiniuDownloadURLsWithKeys:(NSArray<NSString *> *)keys callback:(SKResponseCallback)callback;

/**
 *  @brief 判断休息日
 */
- (void)getIsRelaxDay:(SKResponseCallback)callback;

/**
 *  @brief 获取休息日信息
 */
- (void)getRelaxDayInfo:(SKResponseCallback)callback;

/**
 *  @brief 主页问题列表
 */
- (void)getQuestionListWithPage:(NSUInteger)page count:(NSUInteger)count callback:(SKQuestionListCallback)callback;

/**
 *  @brief 答对问题列表
 */
- (void)getQuestionListSuccessfulWithPage:(NSUInteger)page count:(NSUInteger)count callback:(SKQuestionListCallback)callback;

/**
 *  @brief 获取奖励
 */
- (void)getRewardWithID:(uint64_t)rewardID questionID:(uint64_t)qid completion:(SKGetRewardCallback)callback;

@end
