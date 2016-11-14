//
//  SKMascotView.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SKMascotTypeDefault,
    SKMascotTypeEnvy,
    SKMascotTypeGluttony,
    SKMascotTypeGreed,
    SKMascotTypePride,
    SKMascotTypeSloth,
    SKMascotTypeWrath,
    SKMascotTypeLust
} SKMascotType;

@interface SKMascotView : UIView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType;

@end
