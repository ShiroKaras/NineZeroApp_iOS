//
//  HTPreviewItem.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/6.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HTPreviewItemButtonType) {
    HTPreviewItemButtonTypeCompose,
    HTPreviewItemButtonTypeContent,
    HTPreviewItemButtonTypeHint,
    HTPreviewItemButtonTypeReward,
    HTPreviewItemButtonTypeAnswer,
    HTPreviewItemButtonTypeSound,
    HTPreviewItemButtonTypePause
};

@class HTQuestion;
@class HTPreviewItem;

@protocol HTPreviewItemDelegate <NSObject>

/**
 *  @brief 根据type值来判断点击了哪种类型的button
 *  @param type        type
 */
- (void)previewItem:(HTPreviewItem *)previewItem didClickButtonWithType:(HTPreviewItemButtonType)type;

@optional
// 发布
- (void)previewItem:(HTPreviewItem *)previewItem didClickComposeButton:(UIButton *)composeButton;
// 内容
- (void)previewItem:(HTPreviewItem *)previewItem didClickContentButton:(UIButton *)contentButton;
// 提示
- (void)previewItem:(HTPreviewItem *)previewItem didClickHintButton:(UIButton *)hintButton;
// 奖品
- (void)previewItem:(HTPreviewItem *)previewItem didClickRewardButton:(UIButton *)rewardButton;

@end

@interface HTPreviewItem : UIView

@property (strong, nonatomic) HTQuestion *question;
@property (weak, nonatomic) id<HTPreviewItemDelegate> delegate;

/**
 *  @brief 设置结果，若设置了该值，自动隐藏掉所有倒计时相关逻辑
 */
@property (nonatomic, assign) BOOL breakSuccess;
// 倒计时
@property (nonatomic, assign) time_t endTime;

- (CGRect)hintRect;

- (void)play;
- (void)pause;
- (void)stop;

@end
