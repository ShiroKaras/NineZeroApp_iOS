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
    _loginUser.user_password = _secondTextField.text;
    _loginUser.user_password = [NSString confusedPasswordWithLoginUser:_loginUser];
    [[[HTServiceManager sharedInstance] loginService] resetPasswordWithUser:_loginUser completion:^(BOOL success, HTResponsePackage *response) {
        if (success) {
            if (response.resultCode == 0) {
                [MBProgressHUD showSuccessWithTitle:@"修改成功"];
                NSArray *controllers = self.navigationController.viewControllers;
                UIViewController *loginController = nil;
                for (UIViewController *controller in controllers) {
                    if ([controller isKindOfClass:[HTLoginController class]]) {
                        loginController = controller;
                    }
                }
                if (loginController != nil) [self.navigationController popToViewController:loginController animated:YES];
            } else {
                [MBProgressHUD showWarningWithTitle:response.resultMsg];
            }
        } else {
            [MBProgressHUD showNetworkError];
        }
    }];
}

@end
