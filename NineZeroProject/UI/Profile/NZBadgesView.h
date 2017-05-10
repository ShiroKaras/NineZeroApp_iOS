//
//  NZBadgesView.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/9.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKBadge;

@interface NZBadgesView : UIView
@property (nonatomic, assign) float viewHeight;

- (instancetype)initWithFrame:(CGRect)frame badges:(NSArray<SKBadge*>*)badges;

@end
