//
//  HTMascotView.h
//  NineZeroProject
//
//  Created by ronhu on 16/1/20.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTMascotView;
@class HTMascotItem;
@class HTMascotTipView;
@protocol HTMascotViewDelegate <NSObject>
- (void)mascotView:(HTMascotView *)mascotView didClickMascotItem:(HTMascotItem *)mascotItem;
- (void)mascotView:(HTMascotView *)mascotView didClickMascotTipView:(HTMascotTipView *)mascotTipView;
@end

@interface HTMascotView : UIImageView
- (instancetype)initWithShowMascotIndexs:(NSArray<NSNumber *> *)indexs;
@property (nonatomic, weak) id<HTMascotViewDelegate> delegate;
@property (nonatomic, strong) NSArray<NSNumber *> *currentDisplayIndexs;
@end

@interface HTMascotItem : UIImageView
@property (nonatomic, assign) NSInteger index;
@end

@interface HTMascotTipView : UIButton
/**
 *  @brief 默认构造函数
 */
- (instancetype)initWithIndex:(NSInteger)index;
@property (nonatomic, assign) NSInteger index;
/**
 *  @brief 展现零仔对应的道具个数
 */
@property (nonatomic, assign) NSInteger tipNumber;
/**
 *  @brief 点击了tip对应的响应方法
 */
@property (nonatomic, copy) void(^didClickMascotTipBlock)(HTMascotTipView *tipView);
@end
