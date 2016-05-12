//
//  HTMascotView.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/20.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTMascotView;
@class HTMascotItem;
@class HTMascotTipView;
@class HTMascot;
@protocol HTMascotViewDelegate <NSObject>
- (void)mascotView:(HTMascotView *)mascotView didClickMascotItem:(HTMascotItem *)mascotItem;
- (void)mascotView:(HTMascotView *)mascotView didClickMascotTipView:(HTMascotTipView *)mascotTipView;
@end

@interface HTMascotView : UIImageView
- (instancetype)initWithMascots:(NSArray<HTMascot *> *)mascots;
@property (nonatomic, strong) NSArray<HTMascot *> *mascots;
@property (nonatomic, weak) id<HTMascotViewDelegate> delegate;
/**
 *  @brief 重置零仔页面动画状态
 */
- (void)reloadDisplayMascots;

- (void)reloadDisplayMascotsWithIndex:(NSUInteger)index;
@end


