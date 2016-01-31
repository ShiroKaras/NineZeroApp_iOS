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


