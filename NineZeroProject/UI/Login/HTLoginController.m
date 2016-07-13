//
//  HTLoginController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/21.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTLoginController.h"
#import "HTForgetPasswordController.h"
#import "HTServiceManager.h"
#import <MBProgressHUD+BWMExtension.h>
#import "HTUIHeader.h"
#import "NSString+Utility.h"
#import "HTMainViewController.h"

@interface HTLoginController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation HTLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.userNameTextField.delegate = self;
//#ifdef DEBUG
//    HTLoginUser *user = [[[HTServiceManager sharedInstance] loginService] loginUser];
//    self.userNameTextField.text = user.user_mobile;
//    self.passwordTextField.text = user.user_password;
//    self.loginButton.enabled = YES;
//#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"loginpage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"loginpage"];
}

#pragma mark - Action

- (IBAction)didClickLoginButton:(UIButton *)sender {
    [MobClick event:@"login"];
    SKLoginUser *loginUser = [[SKLoginUser alloc] init];
    loginUser.user_mobile = self.userNameTextField.text;
    loginUser.user_password = self.passwordTextField.text;
//    loginUser.user_password = [NSString confusedPasswordWithLoginUser:loginUser];

    [self.view endEditing:YES];
    [HTProgressHUD show];
    [[[SKServiceManager sharedInstance] loginService] loginWithUser:loginUser completion:^(BOOL success, SKResponsePackage *response) {
        if (success) {
            if (response.resultCode == 200) {
                HTMainViewController *controller = [[HTMainViewController alloc] init];
                //                [UIApplication sharedApplication].keyWindow.rootViewController = controller;
                AppDelegateInstance.mainController = controller;
                HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:controller];
                AppDelegateInstance.window.rootViewController = navController;
                [AppDelegateInstance.window makeKeyAndVisible];
                //                [[[HTServiceManager sharedInstance] profileService] updateUserInfoFromSvr];
            } else {
                [self showTipsWithText:response.message];
            }
        } else {
            [self showTipsWithText:@"网络连接错误"];
        }

    }];
}

- (IBAction)didClickForgetPassword:(UIButton *)sender {
    [MobClick event:@"forgetpassword"];
    HTForgetPasswordController *forgetPwdController = [[HTForgetPasswordController alloc] init];
    [self.navigationController pushViewController:forgetPwdController animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.userNameTextField) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 11;
    }else
        return YES;
}

@end
