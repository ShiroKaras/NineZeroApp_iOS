//
//  NZBadgeDetailView.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/22.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKBadge;

@interface NZBadgeDetailView : UIView

- (instancetype)initWithFrame:(CGRect)frame withBadge:(SKBadge*)badge;

@end
