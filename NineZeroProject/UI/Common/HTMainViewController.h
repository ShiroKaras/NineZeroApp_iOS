//
//  HTMainViewController.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/17.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTMainViewController : UIViewController

- (void)changedToViewController:(UIViewController *)viewController;

- (void)loadResource;

- (void)showBottomButton:(BOOL)show;

- (void)showBackToToday:(BOOL)show;

- (void)reloadMascotViewData;

@end
