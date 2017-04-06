//
//  NZQuestionDetailViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/30.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SKQuestionTypeDefault,
    SKQuestionTypeTimeLimitLevel,
    SKQuestionTypeHistoryLevel,
    SKQuestionTypeUnknown,
} SKQuestionType;

@interface NZQuestionDetailViewController : UIViewController

- (instancetype)initWithType:(SKQuestionType)type questionID:(NSString *)questionID;

@end
