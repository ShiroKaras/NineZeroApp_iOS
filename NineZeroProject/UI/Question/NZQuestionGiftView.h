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

- (instancetype)initWithFrame:(CGRect)frame withReward:(SKReward *)reward;

@end


@interface NZQuestionFullScreenGiftView : UIView

- (instancetype)initWithFrame:(CGRect)frame withReward:(SKReward *)reward;

@end
