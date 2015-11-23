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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _registerButton.enabled = NO;
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

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameTextField) {
        [self.userPasswordTextField becomeFirstResponder];
        return YES;
    }
    if (textField == self.userNameTextField) {
        if ([self isRegisterButtonValid]) {
            [self registerButtonClicked:nil];
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    if ([self isRegisterButtonValid]) {
        self.registerButton.enabled = YES;
    } else {
        self.registerButton.enabled = NO;
    }
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
    HTRegisterController *registerController = [[HTRegisterController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES]; 
}

- (IBAction)loginButtonClicked:(UIButton *)sender {
    HTLoginController *loginController = [[HTLoginController alloc] init];
    [self.navigationController pushViewController:loginController animated:YES];
}

#pragma mark - Tool Method

- (BOOL)isRegisterButtonValid {
    if (self.userNameTextField.text.length != 0 &&
        self.userPasswordTextField.text.length != 0) {
        return YES;
    }
    return NO;
}

@end
