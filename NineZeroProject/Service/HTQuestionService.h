//
//  HTQuestionService.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/12/9.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTNetworkDefine.h"

@class HTQuestionInfo;
@class HTQuestion;
@class HTResponsePackage;

typedef void (^HTQuestionCallback) (BOOL success, HTQuestion *question);
typedef void (^HTQuestionListCallback) (BOOL success, NSArray<HTQuestion *> *questionList);
typedef void (^HTQuestionInfoCallback) (BOOL success, HTQuestionInfo *questionInfo);

/**
 *  该类只允许HTServiceManager创建一次，多次创建直接crash
 *  通过HTServiceManager拿到该类的唯一实例
 *  负责题目相关的逻辑
 */
@interface HTQuestionService : NSObject

- (void)setLoginUser:(HTLoginUser *)loginUser;

/**
 *  @brief 获取题目总体信息
 */
- (void)getQuestionInfoWithCallback:(HTQuestionInfoCallback)callback;
- (HTQuestionInfo *)questionInfo;
/**
 *  @brief 获取题目列表
 *  @param page     当前页码, 从1开始
 *  @param count    当前页码的数目
 */
- (void)getQuestionListWithPage:(NSUInteger)page count:(NSUInteger)count callback:(HTQuestionListCallback)callback;
/**
 *  @brief 闯关成功的关卡
 */
- (NSArray<HTQuestion *> *)questionListSuccessful;
/**
 *  @brief 闯关关卡
 */
- (NSArray<HTQuestion *> *)questionList;
/**
 *  @brief 获取题目的具体信息
 *  @param questionID question_id
 */
- (void)getQuestionDetailWithQuestionID:(uint64_t)questionID callback:(HTQuestionCallback)callback;

/**
 *  @brief 验证答案
 *  @param questionID 问题id
 *  @param user_id    用户id
 *  @param answer     答案
 */
- (void)verifyQuestion:(uint64_t)questionID withAnswer:(NSString *)answer callback:(HTResponseCallback)callback;

/**
 *  @brief 验证AR答案
 */
- (void)verifyQuestion:(uint64_t)questionID withLocation:(CGPoint)location callback:(HTResponseCallback)callback;

/**
 *  @brief 获取七牛下载链接
 *  @param key      服务器给的key
 */
- (void)getQiniuDownloadURLsWithKeys:(NSArray<NSString *> *)keys callback:(HTResponseCallback)callback;

/**
 *  @brief 获取休息日信息
 *  0 : 文章
 *  1 : 零仔gif
 *  2 : 视频
 */
- (void)getRelaxDayInfo:(HTResponseCallback)callback;
/**
 *  @brief 判断是否为休息日
 */
- (void)getIsRelaxDay:(HTResponseCallback)callback;

/**
 *  @brief 获取封面图
 */
- (void)getCoverPicture:(HTResponseCallback)callback;

@end
