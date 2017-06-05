//
//  NZMascotView.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKMascot ;

@interface NZMascotView : UIView

@property (nonatomic, assign) time_t deltaTime;
@property (nonatomic, strong) SKMascot *mascot;

- (instancetype)initWithFrame:(CGRect)frame withMascot:(SKMascot*)mascot;
- (void)tapMascot;
@end
