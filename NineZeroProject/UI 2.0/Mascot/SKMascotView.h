//
//  SKMascotView.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/14.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SKMascotTypeDefault     = 0,
    SKMascotTypeEnvy        = 1,
    SKMascotTypeGluttony    = 2,
    SKMascotTypeGreed       = 3,
    SKMascotTypePride       = 4,
    SKMascotTypeSloth       = 5,
    SKMascotTypeWrath       = 6,
    SKMascotTypeLust        = 7
} SKMascotType;

@interface SKMascotView : UIView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType;

@end


@interface SKMascotSkillView : UIView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType;

@end
