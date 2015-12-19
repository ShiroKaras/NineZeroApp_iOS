//
//  Utility.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/19.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Utility)

+ (void)showErrorWithTitle:(NSString *)title;
+ (void)showWarningWithTitle:(NSString *)title;

/**
 *  @brief 网络错误
 */
+ (void)showNetworkError;

@end
