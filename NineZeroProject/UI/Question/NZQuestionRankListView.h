//
//  NZQuestionRankListView.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/10.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKUserInfo;

@interface NZQuestionRankListView : UIView

@property (nonatomic, assign) float viewHeight;
@property (nonatomic, strong) UIScrollView *rankScrollView;

- (instancetype)initWithFrame:(CGRect)frame rankArray:(NSArray<SKUserInfo*>*)array;

@end
