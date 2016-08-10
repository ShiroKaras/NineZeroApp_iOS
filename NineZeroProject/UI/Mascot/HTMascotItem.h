//
//  HTMascotItem.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/24.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYAnimatedImageView.h"

/**
 *  @brief 小零仔
 */
@class HTMascot;
@interface HTMascotItem : YYAnimatedImageView
@property (nonatomic, assign) long index;
@property (nonatomic, strong) HTMascot *mascot;
/**
 *  @brief 播放几号动画，支持2，3，4号三种动画
 *  @param number 动画编号，支持2，3，4
 */
- (void)playAnimatedNumber:(NSInteger)number;

/**
 *  @brief 停止播放动画
 */
- (void)stopAnyAnimation;

@end
