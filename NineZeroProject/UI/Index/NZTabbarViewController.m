//
//  NZTabbarViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/27.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZTabbarViewController.h"
#import "HTUIHeader.h"

#import "SKHomepageViewController.h"
#import "NZQuestionListViewController.h"
#import "NZMascotMainViewController.h"
#import "NZLabViewController.h"
#import "NZUserProfileViewController.h"

@interface NZTabbarViewController ()

@end

@implementation NZTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setBarTintColor:COMMON_BG_COLOR];
    [UITabBar appearance].translucent = NO;
    
    SKHomepageViewController *c1 = [[SKHomepageViewController alloc] init];
    c1.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c1.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_task"];
    c1.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_task_highlight"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NZQuestionListViewController *c2 = [[NZQuestionListViewController alloc] init];
    c2.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c2.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_puzzle"];
    c2.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_puzzle_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NZMascotMainViewController *c3 = [[NZMascotMainViewController alloc] init];
    c3.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c3.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_lingzai"];
    c3.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_lingzai_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NZLabViewController *c4 = [[NZLabViewController alloc] init];
    c4.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c4.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_lab"];
    c4.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_lab_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NZUserProfileViewController *c5 = [[NZUserProfileViewController alloc] init];
    c5.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    c5.tabBarItem.image = [UIImage imageNamed:@"btn_homepage_me"];
    c5.tabBarItem.selectedImage = [[UIImage imageNamed:@"btn_homepage_me_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[c1, c2, c3, c4, c5];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
    //    childVc.view.backgroundColor = RandomColor; // 这句代码会自动加载主页，消息，发现，我四个控制器的view，但是view要在我们用的时候去提前加载
    
    // 为子控制器包装导航控制器
    HTNavigationController *navigationVc = [[HTNavigationController alloc] initWithRootViewController:childVc];
    // 添加子控制器
    [self addChildViewController:navigationVc];
}

@end
