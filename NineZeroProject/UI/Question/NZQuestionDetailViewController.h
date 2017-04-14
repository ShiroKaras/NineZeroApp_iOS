//
//  NZQuestionDetailViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/30.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NZQuestionTypeDefault,
    NZQuestionTypeTimeLimitLevel,
    NZQuestionTypeHistoryLevel,
    NZQuestionTypeUnknown,
} NZQuestionType;

@protocol NZQuestionViewControllerDelegate
- (void)answeredQuestionWithSerialNumber:(NSString *)serial season:(NSInteger)season;
@end

@interface NZQuestionDetailViewController : UIViewController
@property (nonatomic, assign) id<NZQuestionViewControllerDelegate> delegate;
@property (nonatomic, assign) uint64_t endTime;

- (instancetype)initWithType:(NZQuestionType)type questionID:(NSString *)questionID;

@end
