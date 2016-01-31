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
    int count = 10;
    NSMutableArray<HTQuestion *> *questions = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i != count; i++) {
        HTQuestion *question = [[HTQuestion alloc] init];
        [questions addObject:question];
    }
    return questions;
}

@end
