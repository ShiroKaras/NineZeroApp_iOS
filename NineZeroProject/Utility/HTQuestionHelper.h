//
//  HTQuestionHelper.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTQuestion;
@class HTQuestionInfo;

@interface HTQuestionHelper : NSObject

+ (NSArray<HTQuestion *> *)questionFake;
+ (HTQuestionInfo *)questionInfoFake;

@end
