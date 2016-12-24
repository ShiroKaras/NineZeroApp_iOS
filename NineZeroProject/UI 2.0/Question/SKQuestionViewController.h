//
//  SKQuestionViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/7.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKTicket;

typedef enum : NSUInteger {
    SKQuestionTypeDefault,
    SKQuestionTypeTimeLimitLevel,
    SKQuestionTypeHistoryLevel,
    SKQuestionTypeUnknown,
} SKQuestionType;

@protocol SKQuestionViewControllerDelegate
- (void)answeredQuestionWithSerialNumber:(NSString *)serial season:(NSInteger)season;
@end

@interface SKQuestionViewController : UIViewController

@property (nonatomic, assign) NSUInteger season;
@property (nonatomic, assign) id<SKQuestionViewControllerDelegate> delegate;

- (instancetype)initWithType:(SKQuestionType)type questionID:(NSString *)questionID;
- (instancetype)initWithType:(SKQuestionType)type questionID:(NSString *)questionID endTime:(time_t)endTime;

@end
