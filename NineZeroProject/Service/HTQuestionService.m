//
//  HTQuestionService.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTQuestionService.h"

@implementation HTQuestionService

- (instancetype)init {
    static BOOL hasCreate = NO;
    if (hasCreate == YES) [NSException exceptionWithName:@"手动crash" reason:@"重复创建HTLoginService" userInfo:nil];
    if (self = [super init]) {
        hasCreate = YES;
    }
    return self;
}

@end
