//
//  HTQuestionService.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTNetworkDefine.h"

/**
 *  该类只允许HTServiceManager创建一次，多次创建直接crash
 *  通过HTServiceManager拿到该类的唯一实例
 *  负责题目相关的逻辑
 */
@interface HTQuestionService : NSObject

/**
 *  获取题目总体信息
 */
- (void)getQuestionInfoWithCallback:(HTNetworkCallback)callback;

/**
 *  获取题目列表
 *  @param page     当前页码
 *  @param count    当前页码的数目
 */
- (void)getQuestionListWithPage:(NSUInteger)page count:(NSUInteger)count callback:(HTNetworkCallback)callback;

/**
 *  获取题目的具体信息
 *  @param questionID question_id
 */
- (void)getQuestionDetailWithQuestionID:(NSUInteger)questionID callback:(HTNetworkCallback)callback;

@end
