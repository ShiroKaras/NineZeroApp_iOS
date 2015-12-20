//
//  HTResetPasswordController.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/22.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTResetPasswordController.h"
#import "HTUIHeader.h"
#import "HTLogicHeader.h"
#import "HTLoginController.h"

@interface HTResetPasswordController ()

@end

@implementation HTResetPasswordController {
    HTLoginUser *_loginUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"输入密码";
}

- (instancetype)initWithLoginUser:(HTLoginUser *)loginUser {
    if (self = [super init]) {
        _loginUser = loginUser;
    }
    return self;
}

- (IBAction)didClickCompletionButton:(UIButton *)sender {
    if (_secondTextField.text.length < 6) {
        [self showTipsWithText:@"密码过于简单，请输入不低于6位密码"];
        return;
    }
    if (_secondTextField.text.length > 20) {
        [self showTipsWithText:@"密码不能多于20个字，请重新输入"];
        return;
    }
    if ([_firstTextField.text isEqualToString:_secondTextField.text] == NO) {
        [self showTipsWithText:@"两次输入的密码不一致"];
        return;
    }
    _loginUser.user_password = _secondTextField.text;
    _loginUser.user_password = [NSString confusedPasswordWithLoginUser:_loginUser];
    [[[HTServiceManager sharedInstance] loginService] resetPasswordWithUser:_loginUser completion:^(BOOL success, HTResponsePackage *response) {
        if (success) {
            if (response.resultCode == 0) {
                NSArray *controllers = self.navigationController.viewControllers;
                UIViewController *loginController = nil;
                for (UIViewController *controller in controllers) {
                    if ([controller isKindOfClass:[HTLoginController class]]) {
                        loginController = controller;
                    }
                }
                if (loginController != nil) [self.navigationController popToViewController:loginController animated:YES];
            } else {
                [self showTipsWithText:response.resultMsg];
            }
        } else {
            [self showTipsWithText:@"网络连接错误"];
        }
    }];
}

@end
