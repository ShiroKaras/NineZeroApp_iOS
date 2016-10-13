//
//  SKSwipeViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 16/10/9.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"

@class HTScanning;

@interface SKSwipeViewController : UIViewController

@property(nonatomic, strong) OpenGLView *glView;

- (instancetype)initWithScanningList:(NSArray<HTScanning*>*)scanningList;

@end
