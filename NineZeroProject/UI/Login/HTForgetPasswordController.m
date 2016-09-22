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
    [self setTipsOffsetY:60];
    [self.view bringSubviewToFront:[self.view viewWithTag:1000]];
}

#pragma mark - Subclass

- (BOOL)needScheduleVerifyTimer {
    return NO;
}

- (void)needGetVerificationCode {
//    [[[HTServiceManager sharedInstance] loginService] getMobileCode:_loginUser.user_mobile];
    [[[HTServiceManager sharedInstance] loginService] getMobileCode:_firstTextField.text];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _firstTextField) {
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
