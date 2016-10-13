//
//  SKScanningResultView.H
//  NineZeroProject
//
//  Created by SinLemon on 16/10/10.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKScanningResultView;

@protocol SKScanningViewDelegate <NSObject>
- (void)didClickBackButtonInScanningResultView:(SKScanningResultView *)view;
@end

@interface SKScanningResultView : UIView
@property (nonatomic, weak) id<SKScanningViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withIndex:(NSUInteger)index swipeType:(int)type;

@end
