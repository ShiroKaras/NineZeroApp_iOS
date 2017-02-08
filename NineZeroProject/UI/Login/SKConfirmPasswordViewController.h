//
//  SKConfirmPasswordViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/22.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKLoginUser;

@interface SKConfirmPasswordViewController : UIViewController

- (instancetype)initWithUserLoginInfo:(SKLoginUser *)loginUser;

@end
