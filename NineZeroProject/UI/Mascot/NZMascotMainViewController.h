//
//  NZMascotMainViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/7.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SKMascotTypeDefault     = 0,
    SKMascotTypeSloth       = 1,
    SKMascotTypePride       = 2,
    SKMascotTypeWrath       = 3,
    SKMascotTypeGluttony    = 4,
    SKMascotTypeLust        = 5,
    SKMascotTypeEnvy        = 6
} SKMascotType;

@interface NZMascotMainViewController : UIViewController

@end
