//
//  NZQuestionContentView.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/6.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKQuestion;

@interface NZQuestionContentView : UIView

@property (nonatomic, assign) float viewHeight;

- (instancetype)initWithFrame:(CGRect)frame question:(SKQuestion*)question;

@end
