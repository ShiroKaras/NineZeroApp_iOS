    //
//  HTComposeView.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/12/13.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HTComposeView;
@class SKQuestion;
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
@property (nonatomic, strong) SKQuestion *associatedQuestion;
@property (nonatomic, strong) UIButton *composeButton;           ///< 输入按钮

/**
 *  @biref 响应键盘
 */
 - (BOOL)becomeFirstResponder;
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