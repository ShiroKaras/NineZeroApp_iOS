//
//  HTQuestionHelper.h
//  NineZeroProject
//
//  Created by ronhu on 16/1/31.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTQuestion;
@class HTQuestionInfo;

@interface HTQuestionHelper : NSObject

+ (NSArray<HTQuestion *> *)questionFake;
+ (HTQuestionInfo *)questionInfoFake;

@end
