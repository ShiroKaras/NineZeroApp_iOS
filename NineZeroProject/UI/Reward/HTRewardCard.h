//
//  HTRewardCard.h
//  NineZeroProject
//
//  Created by ronhu on 16/2/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTReward;

@interface HTRewardCard : UIView
- (void)showExchangedCode:(BOOL)show;
- (void)setReward:(HTReward *)reward;
@end
