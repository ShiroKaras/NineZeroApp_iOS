//
//  SKVerifyViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/18.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SKVerifyTypeRegister,
    SKVerifyTypeResetPassword
} SKVerifyType;

@interface SKVerifyViewController : UIViewController

- (instancetype)initWithType:(SKVerifyType)type;

@end
