//
//  HTMascotHelper.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTMascot;

@interface HTMascotHelper : NSObject

+ (UIColor *)colorWithMascotIndex:(NSInteger)index;

+ (NSMutableArray<HTMascot *> *)mascotsFake;
+ (HTMascot *)defaultMascots;
@end
