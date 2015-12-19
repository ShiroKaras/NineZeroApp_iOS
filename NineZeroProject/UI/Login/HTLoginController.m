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
#import <MBProgressHUD+BWMExtension.h>

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
    // TODO:加密
    [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"正在登录..."];
    [[[HTServiceManager sharedInstance] loginService] loginWithUser:loginUser success:^(id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } error:^(NSString *errorMessage) {
        [MBProgressHUD bwm_showTitle:@"登录失败" toView:self.view hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeError];
    }];
}

- (IBAction)didClickForgetPassword:(UIButton *)sender {
    HTForgetPasswordController *forgetPwdController = [[HTForgetPasswordController alloc] init];
    [self.navigationController pushViewController:forgetPwdController animated:YES];
}

@end
