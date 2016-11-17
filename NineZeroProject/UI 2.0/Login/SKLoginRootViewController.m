//
//  SKLoginRootViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/17.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKLoginRootViewController.h"
#import "HTUIHeader.h"

#import "SKRegisterViewController.h"

@interface SKLoginRootViewController ()

@end

@implementation SKLoginRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor colorWithHex:0x0E0E0E];
    
    __weak __typeof(self)weakSelf = self;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    backImageView.frame = self.view.frame;
    [self.view addSubview:backImageView];
    
    UIView *bottomView1 = [UIView new];
    bottomView1.backgroundColor = COMMON_RED_COLOR;
    [self.view addSubview:bottomView1];
    [bottomView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
        make.height.equalTo(@49);
    }];
    
    UILabel *otherPlatformLabel = [UILabel new];
    otherPlatformLabel.text = @"其他账号登录";
    otherPlatformLabel.textColor = [UIColor whiteColor];
    otherPlatformLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [otherPlatformLabel sizeToFit];
    [self.view addSubview:otherPlatformLabel];
    [otherPlatformLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView1.mas_left).offset((SCREEN_WIDTH-215)/2);
        make.centerY.equalTo(bottomView1);
    }];
    
    UIButton *loginButton_QQ = [UIButton new];
    [loginButton_QQ setBackgroundImage:[UIImage imageNamed:@"btn_ logins_QQ"] forState:UIControlStateNormal];
    [loginButton_QQ setBackgroundImage:[UIImage imageNamed:@"btn_ logins_QQ_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:loginButton_QQ];
    [loginButton_QQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@25);
        make.height.equalTo(@25);
        make.left.equalTo(otherPlatformLabel.mas_right).offset(20);
        make.centerY.equalTo(otherPlatformLabel);
    }];
    
    UIButton *loginButton_Weixin = [UIButton new];
    [loginButton_Weixin setBackgroundImage:[UIImage imageNamed:@"btn_ logins_Wechat"] forState:UIControlStateNormal];
    [loginButton_Weixin setBackgroundImage:[UIImage imageNamed:@"btn_ logins_Wechat_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:loginButton_Weixin];
    [loginButton_Weixin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@25);
        make.height.equalTo(@25);
        make.left.equalTo(loginButton_QQ.mas_right).offset(20);
        make.centerY.equalTo(otherPlatformLabel);
    }];
    
    UIButton *loginButton_Weibo = [UIButton new];
    [loginButton_Weibo setBackgroundImage:[UIImage imageNamed:@"btn_logins_Weibo"] forState:UIControlStateNormal];
    [loginButton_Weibo setBackgroundImage:[UIImage imageNamed:@"btn_logins_Weibo_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:loginButton_Weibo];
    [loginButton_Weibo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@25);
        make.height.equalTo(@25);
        make.left.equalTo(loginButton_Weixin.mas_right).offset(20);
        make.centerY.equalTo(otherPlatformLabel);
    }];
    
    UIView *bottomView2 = [UIView new];
    bottomView2.backgroundColor = COMMON_RED_COLOR;
    [self.view addSubview:bottomView2];
    [bottomView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(bottomView1.mas_top);
        make.height.equalTo(@54);
    }];
    
    UIButton *registerButton = [UIButton new];
    [registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [bottomView2 addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView2);
        make.top.equalTo(bottomView2);
        make.height.equalTo(@54);
        make.width.equalTo(@(SCREEN_WIDTH/2));
    }];
    
    UIButton *loginButton = [UIButton new];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [bottomView2 addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView2);
        make.top.equalTo(bottomView2);
        make.height.equalTo(@54);
        make.width.equalTo(@(SCREEN_WIDTH/2));
    }];
    
}

#pragma mark - Actions

- (void)registerButtonClick:(UIButton *)sender {
    SKRegisterViewController *controller = [[SKRegisterViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
