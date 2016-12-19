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
    SKMascotTypePride       = 3,
    SKMascotTypeSloth       = 4,
    SKMascotTypeWrath       = 5,
    SKMascotTypeLust        = 6
} SKMascotType;

@interface SKMascotView : UIView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType;

@end


@interface SKMascotSkillView : UIView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType;

@end


@interface SKMascotInfoView : UIView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType;

@end
