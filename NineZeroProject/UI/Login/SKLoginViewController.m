//
//  SKLoginViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/22.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKLoginViewController.h"
#import "HTUIHeader.h"

#import "SKRegisterTextField.h"
#import "SKResetPasswordViewController.h"

@interface SKLoginViewController () <UITextViewDelegate>

@property (nonatomic, strong) SKRegisterTextField *phoneTextField;
@property (nonatomic, strong) SKRegisterTextField *passwordTextField;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *resetPasswordButton;
@property (nonatomic, strong) UIButton *resetPasswordButton4s;
@property (nonatomic, strong) SKLoginUser *loginUser;
@property (nonatomic, strong) UIView *blackView;
@end

@implementation SKLoginViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone &&
	    SCREEN_HEIGHT > IPHONE4_SCREEN_HEIGHT) {
		[self createUI];
	} else {
		[self createUIiPhone4];
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[TalkingData trackPageBegin:@"loginpage"];
	//[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	[self.navigationController.navigationBar setHidden:YES];
	_blackView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[TalkingData trackPageEnd:@"loginpage"];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)createUI {
	self.view.backgroundColor = COMMON_PINK_COLOR;
	_blackView = [[UIView alloc] initWithFrame:self.view.bounds];
	_blackView.backgroundColor = [UIColor blackColor];
	[self.view addSubview:_blackView];

	__weak __typeof(self) weakSelf = self;

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

    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_loginpage_title"]];
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
	_passwordTextField.ly_placeholder = @"密码";
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
	[_nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xCA0E27]] forState:UIControlStateNormal];
	[_nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xFF546B]] forState:UIControlStateHighlighted];
    [_nextButton setImage:[UIImage imageNamed:@"btn_logins_next"] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"btn_logins_next_highlight"] forState:UIControlStateHighlighted];
	_nextButton.adjustsImageWhenHighlighted = NO;
	[self.view addSubview:_nextButton];

	_resetPasswordButton = [UIButton new];
	[_resetPasswordButton addTarget:self action:@selector(resetPasswordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	_resetPasswordButton.backgroundColor = [UIColor clearColor];
	[_resetPasswordButton setTitle:@"忘记密码了？" forState:UIControlStateNormal];
	[_resetPasswordButton setTitleColor:COMMON_GREEN_COLOR forState:UIControlStateHighlighted];
	_resetPasswordButton.titleLabel.font = PINGFANG_FONT_OF_SIZE(12);
	_resetPasswordButton.frame = CGRectMake(0, self.view.height - 100, self.view.width, 50);
	[self.view addSubview:_resetPasswordButton];
}

- (void)createUIiPhone4 {
	self.view.backgroundColor = COMMON_RED_COLOR;
	_blackView = [[UIView alloc] initWithFrame:self.view.bounds];
	_blackView.backgroundColor = [UIColor blackColor];
	[self.view addSubview:_blackView];

	__weak __typeof(self) weakSelf = self;

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
	titleLabel.text = @"请登录";
	titleLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:titleLabel];
	titleLabel.centerX = self.view.centerX;
	titleLabel.top = 22;

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
	_passwordTextField.ly_placeholder = @"密码";
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
	[_nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xCA0E27]] forState:UIControlStateNormal];
	[_nextButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xFF546B]] forState:UIControlStateHighlighted];
    [_nextButton setImage:[UIImage imageNamed:@"btn_logins_next"] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"btn_logins_next_highlight"] forState:UIControlStateHighlighted];
	_nextButton.adjustsImageWhenHighlighted = NO;
	[self.view addSubview:_nextButton];

	_resetPasswordButton4s = [UIButton new];
	[_resetPasswordButton4s addTarget:self action:@selector(resetPasswordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	_resetPasswordButton4s.backgroundColor = [UIColor clearColor];
	[_resetPasswordButton4s setTitle:@"忘记密码" forState:UIControlStateNormal];
	[_resetPasswordButton4s setTitleColor:COMMON_GREEN_COLOR forState:UIControlStateHighlighted];
	_resetPasswordButton4s.titleLabel.font = PINGFANG_FONT_OF_SIZE(12);
	_resetPasswordButton4s.frame = CGRectMake(self.view.width - 16 - 60, 21, 60, 30);
	_resetPasswordButton4s.centerY = titleLabel.centerY;
	[self.view addSubview:_resetPasswordButton4s];
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
	} else {
		self.loginUser = [SKLoginUser new];
		self.loginUser.user_mobile = _phoneTextField.textField.text;
		self.loginUser.user_password = _passwordTextField.textField.text;
		[[[SKServiceManager sharedInstance] loginService] checkMobileRegisterStatus:_phoneTextField.textField.text
										   callback:^(BOOL success, SKResponsePackage *response) {
										       if (response.result == 0) {
											       [self showTipsWithText:@"手机号码未注册"];
										       } else {
											       [[[SKServiceManager sharedInstance] loginService] loginWith:self.loginUser
																		  callback:^(BOOL success, SKResponsePackage *response) {
																		      if (response.result == 0) {
																			      //登录成功进入主页
																			      _blackView.hidden = NO;
																			      [self.view bringSubviewToFront:_blackView];
																			      [self.view endEditing:YES];
																			      [[NSNotificationCenter defaultCenter] removeObserver:self];
																			      SKHomepageViewController *controller = [[SKHomepageViewController alloc] init];
																			      AppDelegateInstance.mainController = controller;
																			      HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:controller];
																			      AppDelegateInstance.window.rootViewController = navController;
																			      [AppDelegateInstance.window makeKeyAndVisible];
																		      } else if (response.result == -2004) {
																			      [self showTipsWithText:@"请检查手机号或密码是否正确"];
																		      }
																		  }];
										       }
										   }];
	}
}

- (void)resetPasswordButtonClick:(UIButton *)sender {
	[TalkingData trackEvent:@"weixinregister"];
	SKResetPasswordViewController *controller = [[SKResetPasswordViewController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
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
	_resetPasswordButton.frame = CGRectMake(0, self.view.height - keyboardRect.size.height - 100, self.view.width, 50);
}

- (void)keyboardWillHide:(NSNotification *)notification {
	_nextButton.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
	_resetPasswordButton.frame = CGRectMake(0, self.view.height - 100, self.view.width, 50);
}

- (void)keyboardDidHide:(NSNotification *)notification {
}
@end
