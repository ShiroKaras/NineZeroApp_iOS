//
//  SKQuestionViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/7.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SKQuestionTypeDefault,
    SKQuestionTypeTimeLimitLevel,
    SKQuestionTypeHistoryLevel,
    SKQuestionTypeUnknown,
} SKQuestionType;

@interface SKQuestionViewController : UIViewController

@property (nonatomic, assign) NSUInteger season;

- (instancetype)initWithType:(SKQuestionType)type questionID:(NSString *)questionID;
- (instancetype)initWithType:(SKQuestionType)type questionID:(NSString *)questionID endTime:(time_t)endTime;

@end
