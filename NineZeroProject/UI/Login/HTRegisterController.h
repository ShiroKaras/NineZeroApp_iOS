//
//  HTRegisterController.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/21.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCommonViewController.h"

@class HTLoginUser;

@interface HTRegisterController : HTCommonViewController

- (instancetype)initWithUser:(HTLoginUser *)user;

@end
