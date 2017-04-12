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

@interface NZQuestionDetailViewController : UIViewController

- (instancetype)initWithType:(NZQuestionType)type questionID:(NSString *)questionID;

@end
