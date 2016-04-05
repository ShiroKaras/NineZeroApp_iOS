//
//  HTRegisterController.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/21.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTCommonViewController.h"

@class HTLoginUser;

@interface HTRegisterController : HTCommonViewController

- (instancetype)initWithUser:(HTLoginUser *)user;

@end
