//
//  SKConfirmPasswordViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/22.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKConfirmPasswordViewController.h"
#import "HTUIHeader.h"

#import "SKRegisterTextField.h"

@interface SKConfirmPasswordViewController ()
@property (nonatomic, strong) SKRegisterTextField *passwordTextField;
@property (nonatomic, strong) SKRegisterTextField *passwordConfirmTextField;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) SKLoginUser *loginUser;
@end

@implementation SKConfirmPasswordViewController

- (instancetype)initWithUserLoginInfo:(SKLoginUser *)loginUser
{
    self = [super init];
    if (self) {
        self.loginUser = loginUser;
    }
    return self;
}

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
    
    _passwordTextField = [[SKRegisterTextField alloc] init];
    _passwordTextField.ly_placeholder = @"密码";
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ROUND_HEIGHT(106));
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(ROUND_WIDTH(252));
        make.height.equalTo(ROUND_WIDTH(44));
    }];
    
    _passwordConfirmTextField = [[SKRegisterTextField alloc] init];
    _passwordConfirmTextField.alpha = 0;
    _passwordConfirmTextField.textField.secureTextEntry = YES;
    _passwordConfirmTextField.ly_placeholder = @"密码";
    [self.view addSubview:_passwordConfirmTextField];
    [_passwordConfirmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).offset(26);
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(ROUND_WIDTH(252));
        make.height.equalTo(ROUND_WIDTH(44));
    }];
    
    _nextButton = [UIButton new];
    [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.frame = CGRectMake(0, self.view.height-50, self.view.width, 50);
    _nextButton.backgroundColor = [UIColor blackColor];
    _nextButton.alpha = 0.6;
    [_nextButton setImage:[UIImage imageNamed:@"btn_logins_next"] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"btn_logins_next_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:_nextButton];
}

#pragma mark - Actions

- (void)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextButtonClick:(UIButton *)sender {
    self.loginUser.user_password = _passwordTextField.textField.text;
    
    [self.view endEditing:YES];
    [[[SKServiceManager sharedInstance] loginService] resetPassword:self.loginUser callback:^(BOOL success, SKResponsePackage *response) {
        //登录成功进入主页
        SKHomepageViewController *controller = [[SKHomepageViewController alloc] init];
        AppDelegateInstance.mainController = controller;
        HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:controller];
        AppDelegateInstance.window.rootViewController = navController;
        [AppDelegateInstance.window makeKeyAndVisible];
    }];
}

@end
