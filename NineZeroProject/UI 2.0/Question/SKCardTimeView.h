//
//  SKCardTimeView.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/16.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKQuestionViewController.h"

@class SKQuestion;
@interface SKCardTimeView : UIView

@property (nonatomic, strong, readonly) SKQuestion *question;
- (void)setQuestion:(SKQuestion *)question type:(SKQuestionType)type endTime:(time_t)endTime;
@end
