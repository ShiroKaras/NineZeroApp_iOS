//
//  SKRegisterViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/17.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKRegisterViewController.h"
#import "HTUIHeader.h"

#import "SKRegisterTextField.h"
#import "SKVerifyViewController.h"
#import "SKUserAgreementViewController.h"

@interface SKRegisterViewController () <UITextFieldDelegate>

@property (nonatomic, strong) SKRegisterTextField *phoneTextField;
@property (nonatomic, strong) SKRegisterTextField *usernameTextField;
@property (nonatomic, strong) SKRegisterTextField *passwordTextField;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *agreementButton;
@property (nonatomic, strong) UIView *agreementView;
@property (nonatomic, strong) UILabel *agreementLabel_1;
@property (nonatomic, strong) UILabel *agreementLabel_2;
@property (nonatomic, assign) BOOL nextButtonIsShow;
@property (nonatomic, assign) CGRect keyboardRect;
@property (nonatomic, assign) BOOL mobileIsRegistered;

@property (nonatomic, strong) SKLoginUser *loginUser;

@end

@implementation SKRegisterViewController

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
    [TalkingData trackPageBegin:@"registerpage"];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"registerpage"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    titleLabel.text = @"开始吧！";
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(@22);
    }];
    
    _phoneTextField = [[SKRegisterTextField alloc] init];
    _phoneTextField.ly_placeholder = @"手机号码";
    _phoneTextField.textField.keyboardType = UIKeyboardTypePhonePad;
    [_phoneTextField.textField becomeFirstResponder];
    [self.view addSubview:_phoneTextField];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@84);
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(ROUND_WIDTH(252));
        make.height.equalTo(ROUND_WIDTH(44));
    }];
    
    _usernameTextField = [[SKRegisterTextField alloc] init];
    _usernameTextField.alpha = 0;
    _usernameTextField.ly_placeholder = @"用户名";
    [self.view addSubview:_usernameTextField];
    [_usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneTextField.mas_bottom).offset(21);
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(ROUND_WIDTH(252));
        make.height.equalTo(ROUND_WIDTH(44));
    }];
    
    _passwordTextField = [[SKRegisterTextField alloc] init];
    _passwordTextField.alpha = 0;
    _passwordTextField.textField.secureTextEntry = YES;
    _passwordTextField.ly_placeholder = @"密码";
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_usernameTextField.mas_bottom).offset(21);
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(ROUND_WIDTH(252));
        make.height.equalTo(ROUND_WIDTH(44));
    }];
    
    _nextButton = [UIButton new];
    [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.frame = CGRectMake(0, self.view.height, self.view.width, 50);
    _nextButton.backgroundColor = [UIColor blackColor];
    _nextButton.alpha = 0.6;
    [_nextButton setImage:[UIImage imageNamed:@"ico_btnanchor_right"] forState:UIControlStateNormal];
    [self.view addSubview:_nextButton];
    
    _agreementView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-50, self.view.width, 50)];
    _agreementView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_agreementView];
    
    float padding = 30;
    _agreementLabel_1 = [UILabel new];
    _agreementLabel_1.text = @"点击下一步表示你同意";
    _agreementLabel_1.textColor = [UIColor whiteColor];
    _agreementLabel_1.font = [UIFont fontWithName:@"Helvetica" size:12];
    _agreementLabel_1.textAlignment = NSTextAlignmentRight;
    _agreementLabel_1.frame = CGRectMake(0, 0, self.view.width/2+padding, 50);
    [_agreementView addSubview:_agreementLabel_1];
    
    _agreementLabel_2 = [UILabel new];
    _agreementLabel_2.text = @"《用户协议》";
    _agreementLabel_2.textColor = [UIColor whiteColor];
    _agreementLabel_2.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    _agreementLabel_2.textAlignment = NSTextAlignmentLeft;
    _agreementLabel_2.frame = CGRectMake(self.view.width/2+padding, 0, self.view.width/2-padding, 50);
    [_agreementView addSubview:_agreementLabel_2];
    
    _agreementButton = [UIButton new];
    [_agreementButton addTarget:self action:@selector(agreementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _agreementButton.backgroundColor = [UIColor clearColor];
//    [_agreementButton setTitle:@"点击下一步表示你同意《用户协议》" forState:UIControlStateNormal];
    
    _agreementButton.titleLabel.font = PINGFANG_FONT_OF_SIZE(12);
    _agreementButton.frame = CGRectMake(0, self.view.height-50, self.view.width, 50);
    [self.view addSubview:_agreementButton];
}

#pragma mark - Actions

- (void)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextButtonClick:(UIButton *)sender {
    self.loginUser = [SKLoginUser new];
    if ([_phoneTextField.textField.text isEqualToString:@""]) {
        [self showTipsWithText:@"请填写手机号码"];
    } else if (_phoneTextField.textField.text.length < 11) {
        [self showTipsWithText:@"请检查手机号码是否正确"];
    } else if ([_usernameTextField.textField.text isEqualToString:@""]) {
        [self showTipsWithText:@"请填写用户名"];
    } else if ([_passwordTextField.textField.text isEqualToString:@""]) {
        [self showTipsWithText:@"请填写密码"];
    } else if (_passwordTextField.textField.text.length<6) {
        [self showTipsWithText:@"请输入不低于6位密码"];
    } else if (_mobileIsRegistered == YES) {
        [self showTipsWithText:@"手机号码已注册"];
    } else {
        self.loginUser.user_mobile  = _phoneTextField.textField.text;
        self.loginUser.user_name    = _usernameTextField.textField.text;
        self.loginUser.user_password = _passwordTextField.textField.text;
        
        SKVerifyViewController *controller = [[SKVerifyViewController alloc] initWithType:SKVerifyTypeRegister userLoginInfo:self.loginUser];
        [self.navigationController pushViewController:controller animated:YES];
        
        [[[SKServiceManager sharedInstance] loginService] sendVerifyCodeWithMobile:self.loginUser.user_mobile callback:^(BOOL success, SKResponsePackage *response) { }];
    }
}

- (void)agreementButtonClick:(UIButton *)sender {
    SKUserAgreementViewController *controller = [[SKUserAgreementViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldTextDidChange:(UITextField *)textField {
    if (_phoneTextField.textField.text.length == 11) {
        //判断手机号是否被注册
        [[[SKServiceManager sharedInstance] loginService] checkMobileRegisterStatus:_phoneTextField.textField.text callback:^(BOOL success, SKResponsePackage *response) {
            if (response.result == 0) {
                _mobileIsRegistered = NO;
                [UIView animateWithDuration:0.3 animations:^{
                    _usernameTextField.alpha = 1;
                } completion:^(BOOL finished) {
                //  [_usernameTextField.textField becomeFirstResponder];
                }];
            } else if (response.result == -2001) {
                _mobileIsRegistered = YES;
                [self showTipsWithText:@"手机号码已被注册"];
            }
        }];
    }
    if (_phoneTextField.textField.text.length > 11) {
        _phoneTextField.textField.text = [_phoneTextField.textField.text substringToIndex:11];
    }
    if (_usernameTextField.textField.text.length >= 2) {
        [UIView animateWithDuration:0.3 animations:^{
            _passwordTextField.alpha = 1;
        }];
    }
    
    if (_phoneTextField.textField.text.length==11 && _usernameTextField.textField.text.length>=2 && _passwordTextField.textField.text.length>=6) {
        self.nextButtonIsShow = YES;
        _nextButton.frame = CGRectMake(0, self.view.height - self.keyboardRect.size.height-50, self.view.width, 50);
        _agreementButton.frame = CGRectMake(0, self.view.height - self.keyboardRect.size.height-100, self.view.width, 50);
        _agreementView.frame = _agreementButton.frame;
    } else {
        self.nextButtonIsShow = NO;
        _nextButton.frame = CGRectMake(0, self.view.height, self.view.width, 50);
        _agreementButton.frame = CGRectMake(0, self.view.height, self.view.width, 50);
        _agreementView.frame = _agreementButton.frame;
    }
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardRect = keyboardRect;
    if (self.nextButtonIsShow) {
        _nextButton.frame = CGRectMake(0, self.view.height - keyboardRect.size.height-50, self.view.width, 50);
        _agreementButton.frame = CGRectMake(0, self.view.height - keyboardRect.size.height-100, self.view.width, 50);
        _agreementView.frame = _agreementButton.frame;
    } else {
        _nextButton.frame = CGRectMake(0, self.view.height - keyboardRect.size.height, self.view.width, 50);
        _agreementButton.frame = CGRectMake(0, self.view.height - keyboardRect.size.height, self.view.width, 50);
        _agreementView.frame = _agreementButton.frame;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.nextButtonIsShow) {
        _nextButton.frame = CGRectMake(0, self.view.height-50, self.view.width, 50);
        _agreementButton.frame = CGRectMake(0, self.view.height-100, self.view.width, 50);
        _agreementView.frame = _agreementButton.frame;
    } else {
        _nextButton.frame = CGRectMake(0, self.view.height, self.view.width, 50);
        _agreementButton.frame = CGRectMake(0, self.view.height, self.view.width, 50);
        _agreementView.frame = _agreementButton.frame;
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
    
}

@end
