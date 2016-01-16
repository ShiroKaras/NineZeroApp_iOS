//
//  HTLoginController.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/21.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTLoginController.h"
#import "HTForgetPasswordController.h"
#import "HTServiceManager.h"
#import "HTPreviewQuestionController.h"
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
//#ifdef DEBUG
//    HTLoginUser *user = [[[HTServiceManager sharedInstance] loginService] loginUser];
//    self.userNameTextField.text = user.user_mobile;
//    self.passwordTextField.text = user.user_password;
//    self.loginButton.enabled = YES;
//#endif
}

#pragma mark - Action

- (IBAction)didClickLoginButton:(UIButton *)sender {
    HTLoginUser *loginUser = [[HTLoginUser alloc] init];
    loginUser.user_mobile = self.userNameTextField.text;
    loginUser.user_password = self.passwordTextField.text;
    loginUser.user_password = [NSString confusedPasswordWithLoginUser:loginUser];
    
    [[[HTServiceManager sharedInstance] loginService] loginWithUser:loginUser completion:^(BOOL success, HTResponsePackage *response) {
        if (success) {
            if (response.resultCode == 0) {
                HTMainViewController *controller = [[HTMainViewController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = controller;
            } else {
                [self showTipsWithText:response.resultMsg];
            }
        } else {
            [self showTipsWithText:@"网络连接错误"];
        }
    }];
}

- (IBAction)didClickForgetPassword:(UIButton *)sender {
    HTForgetPasswordController *forgetPwdController = [[HTForgetPasswordController alloc] init];
    [self.navigationController pushViewController:forgetPwdController animated:YES];
}

@end
