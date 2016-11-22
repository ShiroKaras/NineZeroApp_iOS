//
//  SKResetPasswordViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/22.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKResetPasswordViewController.h"
#import "HTUIHeader.h"

#import "SKRegisterTextField.h"
#import "SKVerifyViewController.h"

@interface SKResetPasswordViewController ()

@property (nonatomic, strong) SKRegisterTextField *phoneTextField;
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation SKResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
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
    self.view.backgroundColor = COMMON_RED_COLOR;
    
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
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"忘记密码";
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(@22);
    }];
    
    _phoneTextField = [[SKRegisterTextField alloc] init];
    _phoneTextField.ly_placeholder = @"手机号码";
    [self.view addSubview:_phoneTextField];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ROUND_HEIGHT(161));
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(ROUND_WIDTH(252));
        make.height.equalTo(ROUND_WIDTH(44));
    }];
    
    _nextButton = [UIButton new];
    [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.frame = CGRectMake(0, self.view.height-50, self.view.width, 50);
    _nextButton.backgroundColor = [UIColor blackColor];
    _nextButton.alpha = 0.6;
    [_nextButton setImage:[UIImage imageNamed:@"ico_btnanchor_right"] forState:UIControlStateNormal];
    [self.view addSubview:_nextButton];
}

#pragma mark - Actions

- (void)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextButtonClick:(UIButton *)sender {
    SKVerifyViewController *controller = [[SKVerifyViewController alloc] initWithType:SKVerifyTypeResetPassword];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldTextDidChange:(NSNotification *)notification {
    if (_phoneTextField.textField.text.length > 11) {
        _phoneTextField.textField.text = [_phoneTextField.textField.text substringToIndex:11];
    }
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _nextButton.frame = CGRectMake(0, self.view.height - keyboardRect.size.height-50, self.view.width, 50);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _nextButton.frame = CGRectMake(0, self.view.height-50, self.view.width, 50);
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
}

@end
