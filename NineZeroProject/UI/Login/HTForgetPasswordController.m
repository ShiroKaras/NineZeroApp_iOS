//
//  HTForgetPasswordController.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/22.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTForgetPasswordController.h"
#import "HTResetPasswordController.h"

@interface HTForgetPasswordController ()

@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeButton;

@end

@implementation HTForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
}

#pragma mark - Action

- (IBAction)didClickNextButton:(UIButton *)sender {
    HTResetPasswordController *resetPwdController = [[HTResetPasswordController alloc] init];
    [self.navigationController pushViewController:resetPwdController animated:YES]; 
}

- (IBAction)didClickGetVerifyCodeButton:(UIButton *)sender {
    
}

@end
