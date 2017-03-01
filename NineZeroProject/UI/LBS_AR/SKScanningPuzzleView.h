//
//  SKScanningPuzzleView.h
//  NineZeroProject
//
//  Created by songziqiang on 2017/2/27.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKScanningPuzzleView;
@protocol SKScanningPuzzleViewDelegate <NSObject>
@optional

- (void)scanningPuzzleView:(SKScanningPuzzleView *)view didTapBoxButton:(UIButton *)button;
- (void)scanningPuzzleView:(SKScanningPuzzleView *)view didTapExchangeButton:(UIButton *)button;
- (void)scanningPuzzleView:(SKScanningPuzzleView *)view isShowPuzzles:(BOOL)isShowPuzzles;

@end

@interface SKScanningPuzzleView : UIView

@property (nonatomic, weak) id delegate;

- (instancetype)initWithLinkClarity:(NSArray *)clarity rewardAction:(NSArray *)rewardAction defaultPic:(NSString *)defaultPic;

- (void)showAnimationView;
- (void)hideAnimationView;
- (void)showBoxView;
- (void)hideBoxView;
- (void)showPuzzleButton;
- (void)hidePuzzleButton;

@end
