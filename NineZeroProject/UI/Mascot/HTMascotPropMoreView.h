//
//  HTMascotPropMoreView.h
//  NineZeroProject
//
//  Created by ronhu on 16/1/22.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTMascotPropMoreView;
@protocol HTMascotPropMoreViewDelegate <NSObject>
- (void)didClickTopArrawInPropMoreView:(HTMascotPropMoreView *)propMoreView;
- (void)didClickBottomArrawInPropMoreView:(HTMascotPropMoreView *)propMoreView;
@end
@class HTMascotProp;
@interface HTMascotPropMoreView : UIView
- (instancetype)initWithProps:(NSArray<HTMascotProp *> *)props andPageCount:(NSInteger)pageCount;
@property (nonatomic, assign, readonly) NSInteger pageCount;
@property (nonatomic, weak) id<HTMascotPropMoreViewDelegate> delegate;
@end
