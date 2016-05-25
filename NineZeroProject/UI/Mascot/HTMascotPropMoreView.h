//
//  HTMascotPropMoreView.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/22.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTMascotPropMoreView;
@class HTMascotPropItem;
@protocol HTMascotPropMoreViewDelegate <NSObject>
- (void)didClickTopArrowInPropMoreView:(HTMascotPropMoreView *)propMoreView;
- (void)didClickBottomArrowInPropMoreView:(HTMascotPropMoreView *)propMoreView;
//- (void)propMoreView:(HTMascotPropMoreView *)propMoreView didClickPropItem:(HTMascotPropItem *)item;
@end
@class HTMascotProp;
@interface HTMascotPropMoreView : UIView
- (instancetype)initWithProps:(NSArray<HTMascotProp *> *)props andPageCount:(NSInteger)pageCount;
@property (nonatomic, assign, readonly) NSInteger pageCount;
@property (nonatomic, weak) id<HTMascotPropMoreViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *decorateView;    // 玩意儿
@end
