//
//  HTPreviewItem.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/6.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTQuestion;
@class HTPreviewItem;

@protocol HTPreviewItemDelegate <NSObject>

- (void)previewItem:(HTPreviewItem *)previewItem didClickComposeButton:(UIButton *)composeButton;
- (void)previewItem:(HTPreviewItem *)previewItem didClickContentButton:(UIButton *)contentButton;
    
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

@end
