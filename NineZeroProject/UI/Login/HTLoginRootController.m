//
//  HTLoginRootController.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/2.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTLoginRootController.h"
#import "CommonUI.h"
#import "HTRegisterController.h"
#import "HTLoginController.h"
#import <MBProgressHUD+BWMExtension.h>
#import "HTModel.h"
#import "NSString+Utility.h"

@interface HTLoginRootController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation HTLoginRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主界面";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#ifdef DEBUG
    self.userNameTextField.text = [NSString stringWithFormat:@"%ld", (arc4random() % 1000000000) + 10000000000];
    self.userPasswordTextField.text = @"123";
    self.registerButton.enabled = YES;
#endif
}

#pragma mark - Subclass

- (void)nextButtonNeedToBeClicked {
    [super nextButtonNeedToBeClicked];
    [self registerButtonClicked:nil];
}

#pragma mark - Action

- (void)viewDidTap {
    [self.view endEditing:YES];
}

- (IBAction)registerButtonClicked:(UIButton *)sender {
    if (self.userNameTextField.text.length != 11) {
        [MBProgressHUD bwm_showTitle:@"手机号码位数不正确" toView:self.view hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeWarning];
        return;
    }
    HTLoginUser *loginUser = [[HTLoginUser alloc] init];
    loginUser.user_mobile = self.userNameTextField.text;
    loginUser.user_password = self.userPasswordTextField.text;
    HTRegisterController *registerController = [[HTRegisterController alloc] initWithUser:loginUser];
    [self.navigationController pushViewController:registerController animated:YES]; 
}

- (IBAction)loginButtonClicked:(UIButton *)sender {
    HTLoginController *loginController = [[HTLoginController alloc] init];
    [self.navigationController pushViewController:loginController animated:YES];
}

#pragma mark - Tool Method

@end
