//
//  HTNavigationController.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/21.
//  Copyright © 2015年 ronhu. All rights reserved.
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
//
//    UIImage *backImage = [UIImage imageNamed:@"btn_navi_anchor_left"];
//    [[UINavigationBar appearance] setBackIndicatorImage:backImage];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backImage];
//    UIBarButtonItem *backItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
//    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, 0) forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count != 0) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_navi_anchor_left"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end
