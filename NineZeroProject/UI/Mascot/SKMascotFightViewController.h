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
@class SKMascotFightViewController;

@protocol SKMascotFightViewDelegate <NSObject>
- (void)didDismissMascotFightViewController:(SKMascotFightViewController*)controller;
@end

@interface SKMascotFightViewController : UIViewController
@property (nonatomic, weak) id<SKMascotFightViewDelegate> delegate;
- (instancetype)initWithMascot:(SKPet *)mascot;
@end
