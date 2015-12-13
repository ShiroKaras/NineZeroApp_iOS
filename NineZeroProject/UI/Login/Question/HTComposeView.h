    //
//  HTComposeView.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/13.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HTComposeView;
@protocol HTComposeViewDelegate <NSObject>

@required
/**
 *  @brief 回答了问题
 *  @param answer 用户输入的回答
 */
- (void)composeView:(HTComposeView *)composeView didComposeWithAnswer:(NSString *)answer;
/**
 *  @brief 点击了背景
 */
- (void)didClickDimingViewInComposeView:(HTComposeView *)composeView;

@end

@interface HTComposeView : UIView

@property (nonatomic, strong, readonly) UITextField *textField; ///< 输入框
@property (nonatomic, weak) id<HTComposeViewDelegate> delegate; ///< 代理

/**
 *  @biref 响应键盘
 */
/**
 *  @brief 展现回答正确或者错误
 *  @param correct 错误或者正确
 */
- (void)showAnswerCorrect:(BOOL)correct;
/**
 *  @brief 弹出提示
 *  @param tips 提示
 */
- (void)showAnswerTips:(NSString *)tips;

@end
NS_ASSUME_NONNULL_END