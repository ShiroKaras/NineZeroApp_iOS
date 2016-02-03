//
//  HTQuestionHelper.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/31.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTQuestionHelper.h"
#import "HTModel.h"

@implementation HTQuestionHelper

+ (NSArray<HTQuestion *> *)questionFake {
    int count = 4;
    NSMutableArray<HTQuestion *> *questions = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i != count; i++) {
        HTQuestion *question = [[HTQuestion alloc] init];
        if (i == 0) {
            question.type = 1;
            question.vedioName = @"demo1";
            question.isPassed = NO;
        } else if (i == 1) {
            question.type = 2;
            question.vedioName = @"demo2";
            question.isPassed = YES;
        } else if (i == 2) {
            question.type = 1;
            question.isPassed = NO;
            question.vedioName = @"demo3";
        } else if (i == 3) {
            question.type = 1;
            question.isPassed = NO;
            question.vedioName = @"demo1";
        }
        question.hint = @"90后都是神经病";
        question.content = @"上帝之眼，用心感受";
        question.serial = count - i + 1;
        question.answers = @[@"90后", @"神经病"];
        [questions addObject:question];
    }
    return questions;
}

+ (HTQuestionInfo *)questionInfoFake {
    HTQuestionInfo *info = [[HTQuestionInfo alloc] init];
    info.questionCount = 4;
    info.endTime = time(NULL) + 100000;
    return info;
}

@end
