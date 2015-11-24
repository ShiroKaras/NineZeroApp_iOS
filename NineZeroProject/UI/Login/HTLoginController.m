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

@interface HTLoginController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation HTLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
}

#pragma mark - Action

- (IBAction)didClickLoginButton:(UIButton *)sender {
    HTLoginUser *loginUser = [[HTLoginUser alloc] init];
    loginUser.user_mobile = self.userNameTextField.text;
    loginUser.user_password = self.passwordTextField.text;
    [[[HTServiceManager sharedInstance] loginService] loginWithUser:loginUser success:^(id responseObject) {
        
    } error:^(NSString *errorMessage) {
        
    }];
}

- (IBAction)didClickForgetPassword:(UIButton *)sender {
    HTForgetPasswordController *forgetPwdController = [[HTForgetPasswordController alloc] init];
    [self.navigationController pushViewController:forgetPwdController animated:YES];
}


@end
