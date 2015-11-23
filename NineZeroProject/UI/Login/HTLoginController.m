//
//  HTLoginController.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/21.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTLoginController.h"
#import "HTForgetPasswordController.h"

@interface HTLoginController ()

@end

@implementation HTLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
}

#pragma mark - Action

- (IBAction)didClickForgetPassword:(UIButton *)sender {
    HTForgetPasswordController *forgetPwdController = [[HTForgetPasswordController alloc] init];
    [self.navigationController pushViewController:forgetPwdController animated:YES];
}


@end
