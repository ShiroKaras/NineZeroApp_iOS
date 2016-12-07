//
//  SKMyThingsViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKMyThingsViewController.h"
#import "HTUIHeader.h"

@interface SKMyThingsViewController ()

@end

@implementation SKMyThingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"已收集的玩意儿";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [titleLabel sizeToFit];
    titleLabel.center = headerView.center;
    [headerView addSubview:titleLabel];
    [self.view addSubview:headerView];
}

@end
