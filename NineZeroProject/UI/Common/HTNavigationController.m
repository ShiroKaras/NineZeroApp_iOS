//
//  HTNavigationController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/21.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTNavigationController.h"
#import "CommonUI.h"

@implementation HTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:0x1a1a1a]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];


    //自定义返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"btn_navi_anchor_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
//    UIImage *backImage = [UIImage imageNamed:@"btn_navi_anchor_left"];
//    [[UINavigationBar appearance] setBackIndicatorImage:backImage];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backImage];
//    UIBarButtonItem *backItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
//    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, 0) forBarMetrics:UIBarMetricsDefault];
    
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"btn_navi_anchor_left"]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"btn_navi_anchor_left"]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"btn_navi_anchor_left"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_navi_anchor_left_highlight"] forState:UIControlStateHighlighted];
        [button sizeToFit];
        button.width += 10;
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end
