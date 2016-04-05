//
//  HTPreviewView.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/12/6.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HTQuestion;
@class HTPreviewView;
@class HTPreviewItem;
@class HTQuestionInfo;

@protocol HTPreviewViewDelegate <NSObject>

/**
 *  @brief 回到今天是否应该出现
 *  @param previewView 预览题目控件
 *  @param needShow    是否应该显示
 */
- (void)previewView:(HTPreviewView *)previewView shouldShowGoBackItem:(BOOL)needShow;

- (void)previewView:(HTPreviewView *)previewView didScrollToItem:(HTPreviewItem *)item;

@end

/** 预览题目控件 */
@interface HTPreviewView : UIView

- (instancetype)initWithFrame:(CGRect)frame andQuestions:(NSArray<HTQuestion *>*)questions NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak) id<HTPreviewViewDelegate> delegate;
@property (nonatomic, strong) NSArray<HTPreviewItem *> *items;

/**
 *  @brief 设置总体题目信息
 *  @param questionInfo 题目总体信息
 */
- (void)setQuestionInfo:(HTQuestionInfo *)questionInfo;

/**
 *  @brief 回到今日
 */
- (void)goToToday;

@end
