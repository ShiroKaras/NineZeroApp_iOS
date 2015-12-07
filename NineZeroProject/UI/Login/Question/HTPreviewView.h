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

/**
 *  预览题目控件
 */
@interface HTPreviewView : UIView

- (instancetype)initWithFrame:(CGRect)frame andQuestions:(NSArray<HTQuestion *>*)questions NS_DESIGNATED_INITIALIZER;

@end
