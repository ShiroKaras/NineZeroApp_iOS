//
//  HTResetPasswordController.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/22.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCommonViewController.h"

@class HTLoginUser;

@interface HTResetPasswordController : HTCommonViewController

- (instancetype)initWithLoginUser:(HTLoginUser *)loginUser;

@end
