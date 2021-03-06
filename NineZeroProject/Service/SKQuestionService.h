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
@class SKAnswerDetail;
@class SKUserInfo;

typedef void (^SKQuestionListCallback) (BOOL success, NSArray<SKQuestion *> *questionList);

typedef void (^SKQuestionDetialCallback) (BOOL success, SKQuestion *question);
typedef void (^SKQuestionHintListCallback) (BOOL success, NSInteger result, SKHintList *hintList);
typedef void (^SKQuestionAnswerDetialCallback) (BOOL success, SKAnswerDetail *questionAnswerDetail);
typedef void (^SKQuestionUserListCallback) (BOOL success, NSArray<SKUserInfo*> *userRankList);
typedef void (^SKQuestionAnswerDetail) (BOOL success, SKAnswerDetail *answerDetail);

@interface SKQuestionService : NSObject
//@property (nonatomic, assign) NSInteger answeredQuestion_season1;
//@property (nonatomic, assign) NSInteger answeredQuestion_season2;
//@property (nonatomic, strong) NSArray<SKQuestion*> *questionList_season1;
@property (nonatomic, strong) NSArray<SKQuestion*> *questionList_season2;

- (void)questionBaseRequestWithParam:(NSDictionary*)dict callback:(SKResponseCallback)callback;

//全部关卡（不含极难题）
- (void)getAllQuestionListCallback:(SKQuestionListCallback)callback;

//第二季全部关卡
- (void)getQuestionListCallback:(SKQuestionListCallback)callback;

//极难题列表
- (void)getDifficultQuestionListCallback:(SKResponseCallback)callback;

//题目详情
- (void)getQuestionDetailWithQuestionID:(NSString*)questionID callback:(SKQuestionDetialCallback)callback;

//关卡线索列表
- (void)getQuestionDetailCluesWithQuestionID:(NSString*)questionID callback:(SKQuestionHintListCallback)callback;

//购买线索
- (void)purchaseQuestionClueWithQuestionID:(NSString*)questionID callback:(SKResponseCallback)callback;

//查看答案详情
- (void)getQuestionAnswerDetailWithQuestionID:(NSString*)questionID callback:(SKQuestionAnswerDetail)callback;

//获取随机参加者
- (void)getRandomUserListWithQuestionID:(NSString *)questionID callback:(SKQuestionUserListCallback)callback;

//前十名
- (void)getQuestionTop10WithQuestionID:(NSString *)questionID callback:(SKQuestionUserListCallback)callback;

//分享题目
- (void)shareQuestionWithQuestionID:(NSString *)questionID callback:(SKResponseCallback)callback;

//获取提示（3.0）
- (void)getHintWithQuestionID:(NSString *)questionID number:(int)number callback:(SKResponseCallback)callback;

//获取提示列表 (3.0)
- (void)getHintListWithQuestionID:(NSString *)questionID callback:(SKQuestionHintListCallback)callback;

@end
