//
//  HTQuestionService.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  该类只允许HTServiceManager创建一次，多次创建直接crash
 *  通过HTServiceManager拿到该类的唯一实例
 *  负责题目相关的逻辑
 */
@interface HTQuestionService : NSObject

@end
