//
//  HTPreviewView.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/6.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HTQuestion;
@class HTPreviewView;
@class HTPreviewItem;

@protocol HTPreviewViewDelegate <NSObject>
/**
 *  @brief 点击了答题按钮
 *  @param previewView 预览题目控件
 *  @param item        预览题目控件的子控件
 */
- (void)previewView:(HTPreviewView *)previewView didClickComposeWithItem:(HTPreviewItem *)item;

@end

/** 预览题目控件 */
@interface HTPreviewView : UIView

- (instancetype)initWithFrame:(CGRect)frame andQuestions:(NSArray<HTQuestion *>*)questions NS_DESIGNATED_INITIALIZER;

//@property (nonatomic, weak) 

@end
