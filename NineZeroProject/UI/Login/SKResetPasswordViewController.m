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
@property (nonatomic, strong) SKRegisterTextField *passwordTextField;
@property (nonatomic, strong) SKRegisterTextField *passwordConfirmTextField;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) SKLoginUser *loginUser;

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
	[TalkingData trackPageBegin:@"cpassword"];
	//[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	[self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[TalkingData trackPageEnd:@"cpassword"];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)createUI {
	self.view.backgroundColor = COMMON_RED_COLOR;

	__weak __typeof(self) weakSelf = self;

//	UIButton *closeButton = [UIButton new];
//	[closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//	[closeButton setBackgroundImage:[UIImage imageNamed:@"btn_logins_back"] forState:UIControlStateNormal];
//	[closeButton setBackgroundImage:[UIImage imageNamed:@"btn_logins_back_highlight"] forState:UIControlStateHighlighted];
//	[self.view addSubview:closeButton];
//	[closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//	    make.width.equalTo(@40);
//	    make.height.equalTo(@40);
//	    make.top.equalTo(@12);
//	    make.left.equalTo(@4);
//	}];

    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_forgetpage_title"]];
    [self.view addSubview:titleImageView];
	[titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.centerX.equalTo(weakSelf.view);
	    make.top.equalTo(@46);
	}];

	_phoneTextField = [[SKRegisterTextField alloc] init];
	_phoneTextField.ly_placeholder = @"手机号码";
	_phoneTextField.textField.keyboardType = UIKeyboardTypePhonePad;
	[_phoneTextField.textField becomeFirstResponder];
	[self.view addSubview:_phoneTextField];
	[_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.top.equalTo(ROUND_HEIGHT(106));
	    make.centerX.equalTo(weakSelf.view);
	    make.width.equalTo(ROUND_WIDTH(252));
	    make.height.equalTo(ROUND_WIDTH(44));
	}];

	_passwordTextField = [[SKRegisterTextField alloc] init];
	_passwordTextField.textField.secureTextEntry = YES;
	_passwordTextField.ly_placeholder = @"新密码";
	[self.view addSubview:_passwordTextField];
	[_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.top.equalTo(_phoneTextField.mas_bottom).offset(26);
	    make.centerX.equalTo(weakSelf.view);
	    make.width.equalTo(ROUND_WIDTH(252));
	    make.height.equalTo(ROUND_WIDTH(44));
	}];

	_nextButton = [UIButton new];
	[_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	_nextButton.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
    [_nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x0e0e0e alpha:0.3]] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"btn_logins_next"] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"btn_logins_next_highlight"] forState:UIControlStateHighlighted];
	[self.view addSubview:_nextButton];
}

#pragma mark - Actions

- (void)closeButtonClick:(UIButton *)sender {
	[self.view endEditing:YES];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextButtonClick:(UIButton *)sender {
	if ([_phoneTextField.textField.text isEqualToString:@""]) {
		[self showTipsWithText:@"请填写手机号码"];
	} else if (_phoneTextField.textField.text.length < 11) {
		[self showTipsWithText:@"请检查手机号码是否正确"];
	} else if ([_passwordTextField.textField.text isEqualToString:@""]) {
		[self showTipsWithText:@"请填写密码"];
	} else if (_passwordTextField.textField.text.length < 6) {
		[self showTipsWithText:@"请输入不低于6位密码"];
	} else {
		self.loginUser = [SKLoginUser new];
		self.loginUser.user_mobile = _phoneTextField.textField.text;
		self.loginUser.user_password = _passwordTextField.textField.text;

		[[[SKServiceManager sharedInstance] loginService] checkMobileRegisterStatus:_phoneTextField.textField.text
										   callback:^(BOOL success, SKResponsePackage *response) {
										       DLog(@"%ld", response.result);
										       if (response.result == 0) {
											       [self showTipsWithText:@"手机号码未注册"];
										       } else {
											       SKVerifyViewController *controller = [[SKVerifyViewController alloc] initWithType:SKVerifyTypeResetPassword userLoginInfo:self.loginUser];
											       [self.navigationController pushViewController:controller animated:YES];

											       [[[SKServiceManager sharedInstance] loginService] sendVerifyCodeWithMobile:self.loginUser.user_mobile
																				 callback:^(BOOL success, SKResponsePackage *response){

																				 }];
										       }
										   }];
	}
}

#pragma mark - UITextFieldDelegate

- (void)textFieldTextDidChange:(NSNotification *)notification {
	if (_phoneTextField.textField.text.length == 11) {
		//判断手机号是否被注册
		[[[SKServiceManager sharedInstance] loginService] checkMobileRegisterStatus:_phoneTextField.textField.text
										   callback:^(BOOL success, SKResponsePackage *response) {
										       if (response.result == 0) {
											       [self showTipsWithText:@"手机号码未注册"];
										       }
										   }];
	}
	if (_phoneTextField.textField.text.length > 11) {
		_phoneTextField.textField.text = [_phoneTextField.textField.text substringToIndex:11];
	}
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
	NSDictionary *info = [notification userInfo];
	CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	_nextButton.frame = CGRectMake(0, self.view.height - keyboardRect.size.height - 50, self.view.width, 50);
}

- (void)keyboardWillHide:(NSNotification *)notification {
	_nextButton.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
}

- (void)keyboardDidHide:(NSNotification *)notification {
}

@end
