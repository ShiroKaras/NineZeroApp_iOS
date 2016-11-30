//
//  SKServiceManager.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLogicHeader.h"

#import "SKLoginService.h"
#import "SKQuestionService.h"

@interface SKServiceManager : NSObject

+ (instancetype)sharedInstance;

/** loginService，负责登录相关业务 */
- (SKLoginService *)loginService;

/** questionService, 负责题目相关业务 */
- (SKQuestionService *)questionService;

@end
