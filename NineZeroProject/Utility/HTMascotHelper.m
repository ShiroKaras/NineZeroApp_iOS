//
//  HTMascotHelper.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/31.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTMascotHelper.h"
#import "CommonUI.h"

@implementation HTMascotHelper

+ (UIColor *)colorWithMascotIndex:(NSInteger)index {
    if (index < 1 || index > 8) return [UIColor whiteColor];
    NSArray *colors = @[[UIColor colorWithHex:0xed203b],
                        [UIColor colorWithHex:0x24ddb2],
                        [UIColor colorWithHex:0xd40e88],
                        [UIColor colorWithHex:0x5f3a1c],
                        [UIColor colorWithHex:0xfdd900],
                        [UIColor colorWithHex:0xffdb00],
                        [UIColor colorWithHex:0x323542],
                        [UIColor colorWithHex:0x770ae2],];
    return colors[index - 1];
}

@end
