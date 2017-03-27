//
//  NZTabbarViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/27.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZTabbarViewController.h"
#import "SKHomepageViewController.h"

@interface NZTabbarViewController ()

@end

@implementation NZTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SKHomepageViewController *c1 = [[SKHomepageViewController alloc] init];
    c1.tabBarItem.image = [UIImage imageNamed:@"img_profile_notification_mascot1"];
    
    SKHomepageViewController *c2 = [[SKHomepageViewController alloc] init];
    c2.tabBarItem.image = [UIImage imageNamed:@"img_profile_photo_default"];
    
    SKHomepageViewController *c3 = [[SKHomepageViewController alloc] init];
    c3.tabBarItem.image = [UIImage imageNamed:@"img_profile_notification_mascot1"];
    
    self.viewControllers = @[c1, c2, c3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
