//
//  SKComposeView.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/16.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SKComposeView;
@class SKQuestion;
@class HTRanker;
@protocol SKComposeViewDelegate <NSObject>

@required
/**
 *  @brief 回答了问题
 *  @param answer 用户输入的回答
 */
- (void)composeView:(SKComposeView *)composeView didComposeWithAnswer:(NSString *)answer;
/**
 *  @brief 点击了背景
 */
- (void)didClickDimingViewInComposeView:(SKComposeView *)composeView;

@end

@interface SKComposeView : UIView

@property (nonatomic, strong, readonly) UITextField *textField; ///< 输入框
@property (nonatomic, weak) id<SKComposeViewDelegate> delegate; ///< 代理
@property (nonatomic, strong) SKQuestion *associatedQuestion;
@property (nonatomic, strong) UIButton *composeButton;           ///< 输入按钮
@property (nonatomic, strong) UIView *participatorView;             //  参与者

- (instancetype)initWithQustionID:(NSString *)questionID frame:(CGRect)frame;

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
