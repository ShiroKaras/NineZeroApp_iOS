//
//  SKMascotFightViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/1/4.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SKMascotView.h"

@class SKPet;

@interface SKMascotFightViewController : UIViewController
- (instancetype)initWithMascot:(SKPet *)mascot;
@end
