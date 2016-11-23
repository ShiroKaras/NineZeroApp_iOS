//
//  HTNavigationController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/21.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTNavigationController.h"
#import "CommonUI.h"
#import "SKQuestionPageViewController.h"
#import "HTPreviewCardController.h"
#import "HTMascotDisplayController.h"
#import "HTArticleController.h"

@implementation HTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageFromColor:COMMON_TITLE_BG_COLOR] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    //设置成绿色
    statusBarView.backgroundColor=[UIColor greenColor];
    // 添加到 navigationBar 上
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    //自定义返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"btn_profile_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
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
        [button setImage:[UIImage imageNamed:@"btn_detailspage_return"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_detailspage_return_highlight"] forState:UIControlStateHighlighted];
        [button sizeToFit];
        button.top += 12;
        button.left += 4;
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        if ([viewController isKindOfClass:[SKQuestionPageViewController class]] ||
            [viewController isKindOfClass:[HTPreviewCardController class]] ||
            [viewController isKindOfClass:[HTMascotDisplayController class]] ||
            [viewController isKindOfClass:[HTArticleController class]]) {
            
        } else {
            [viewController.view addSubview:button];
        }
    }
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end
