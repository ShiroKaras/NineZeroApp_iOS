//
//  SKConfirmPasswordViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/22.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKConfirmPasswordViewController.h"
#import "HTUIHeader.h"

@interface SKConfirmPasswordViewController ()

@end

@implementation SKConfirmPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = COMMON_GREEN_COLOR;
    
    __weak __typeof(self)weakSelf = self;
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(@12);
        make.left.equalTo(@4);
    }];
    
    UIView *point = [UIView new];
    point.backgroundColor = [UIColor whiteColor];
    point.layer.cornerRadius = 6;
    [self.view addSubview:point];
    [point mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@12);
        make.height.equalTo(@12);
        make.top.equalTo(@26);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UIView *point1 = [UIView new];
    point1.backgroundColor = [UIColor whiteColor];
    point1.layer.cornerRadius = 6;
    [self.view addSubview:point1];
    [point1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@12);
        make.height.equalTo(@12);
        make.right.equalTo(point.mas_left).offset(-10);
        make.centerY.equalTo(point.mas_centerY);
    }];
    
    UIImageView *stepImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_logins_set"]];
    [self.view addSubview:stepImageView];
    [stepImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@26);
        make.height.equalTo(@26);
        make.left.equalTo(point.mas_right).offset(10);
        make.centerY.equalTo(point.mas_centerY);
    }];
    
}

@end
