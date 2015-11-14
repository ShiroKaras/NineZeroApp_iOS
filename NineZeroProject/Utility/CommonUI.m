//
//  CommonUI.c
//  NineZeroProject
//
//  Created by ronhu on 15/11/2.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "CommonUI.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(int)hex {
    return [self colorWithHex:hex alpha:1.0f];
}

+ (UIColor *)colorWithHex:(int)hex alpha:(CGFloat)alpha {
    CGFloat r = ((hex & 0xFF0000) >> 16) / 255.0;
    CGFloat g = ((hex & 0x00FF00) >> 8 ) / 255.0;
    CGFloat b = ((hex & 0x0000FF)      ) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}
@end