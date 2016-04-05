//
//  HTForgetPasswordController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/22.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTForgetPasswordController.h"
#import "HTResetPasswordController.h"
#import "HTUIHeader.h"

@interface HTForgetPasswordController ()

@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeButton;

@end

@implementation HTForgetPasswordController {
    HTLoginUser *_loginUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    _firstTextField.placeholder = @"手机号";
    _secondTextField.placeholder = @"输入验证码";
    _loginUser = [[HTLoginUser alloc] init];
    _verifyButton.enabled = YES;
}

#pragma mark - Subclass

- (BOOL)needScheduleVerifyTimer {
    return NO;
}

- (void)needGetVerificationCode {
    [[[HTServiceManager sharedInstance] loginService] getMobileCode:_loginUser.user_mobile];
}

#pragma mark - Action

- (IBAction)didClickNextButton:(UIButton *)sender {
    _loginUser.user_mobile = _firstTextField.text;
    _loginUser.code = _secondTextField.text;
    HTResetPasswordController *resetPwdController = [[HTResetPasswordController alloc] initWithLoginUser:_loginUser];
    [self.navigationController pushViewController:resetPwdController animated:YES];
}

- (IBAction)didClickGetVerifyCodeButton:(UIButton *)sender {
//    if (_firstTextField.text.length == 11) {
//        [self didClickVerifyButton];
//    } else {
//        [MBProgressHUD showWarningWithTitle:@"请检查手机号码是否正确"];
//    }
}

- (void)didClickVerifyButton {
    if (_firstTextField.text.length == 11) {
        [super didClickVerifyButton];
    } else {
        [self showTipsWithText:@"请检查手机号码是否正确"];
    }
}

@end
