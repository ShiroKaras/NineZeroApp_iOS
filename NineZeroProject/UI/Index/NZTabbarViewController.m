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
    c1.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_task_highlight"];
    
    SKHomepageViewController *c2 = [[SKHomepageViewController alloc] init];
    c2.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_puzzle"];
    
    SKHomepageViewController *c3 = [[SKHomepageViewController alloc] init];
    c3.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_lingzai"];
    
    SKHomepageViewController *c4 = [[SKHomepageViewController alloc] init];
    c4.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_lab"];
    
    SKHomepageViewController *c5 = [[SKHomepageViewController alloc] init];
    c5.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_me"];
    
    self.viewControllers = @[c1, c2, c3, c4, c5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
