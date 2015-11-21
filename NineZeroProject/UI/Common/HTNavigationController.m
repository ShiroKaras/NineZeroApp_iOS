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

//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"btn_navi_anchor_left"]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"btn_navi_anchor_left"]];
}

@end
