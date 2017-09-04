//
//  NZQuestionGiftView.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/10.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKReward;

@interface NZQuestionGiftView : UIView
@property (nonatomic, strong) UIScrollView *scrollView;
- (instancetype)initWithFrame:(CGRect)frame withReward:(SKReward *)reward;
@end


@protocol NZQuestionFullScreenGiftViewDelegate <NSObject>
- (void)didHideFullScreenGiftView;
@end

@interface NZQuestionFullScreenGiftView : UIView
@property (nonatomic, weak) id<NZQuestionFullScreenGiftViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withReward:(SKReward *)reward;
@end
