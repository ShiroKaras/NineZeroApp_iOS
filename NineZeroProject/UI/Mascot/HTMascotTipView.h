//
//  HTMascotTipView.h
//  NineZeroProject
//
//  Created by ronhu on 16/1/31.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

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
@end