//
//  HTMascotHelper.h
//  NineZeroProject
//
//  Created by ronhu on 16/1/31.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTMascot;

@interface HTMascotHelper : NSObject

+ (UIColor *)colorWithMascotIndex:(NSInteger)index;

+ (NSMutableArray<HTMascot *> *)mascotsFake;
+ (HTMascot *)defaultMascots;
@end
