//
//  SKSwipeViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 16/10/9.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"

@class SKScanning;
@class SKQuestion;

@class SKSwipeViewController;

@protocol SKScanningViewDelegate <NSObject>
- (void)didClickBackButtonInScanningResultView:(SKSwipeViewController *)view;
@end

@interface SKSwipeViewController : UIViewController

@property(nonatomic, strong) OpenGLView *glView;
@property(nonatomic, weak)  id<SKScanningViewDelegate> delegate;

- (instancetype)initWithScanningList:(NSArray<SKScanning*>*)scanningList;
- (instancetype)initWithQuestion:(SKQuestion *)question;
@end
