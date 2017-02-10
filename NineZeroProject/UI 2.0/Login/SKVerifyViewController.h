//
//  SKVerifyViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/18.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKLoginUser;

typedef enum : NSUInteger {
    SKVerifyTypeRegister,
    SKVerifyTypeResetPassword,
    SKVerifyTypeUnknow
} SKVerifyType;

@interface SKVerifyViewController : UIViewController

- (instancetype)initWithType:(SKVerifyType)type userLoginInfo:(SKLoginUser*)loginUser;

@end
