//
//  HTLoginRootController.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/2.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTLoginRootController.h"
#import "CommonUI.h"
#import "HTRegisterController.h"
#import "HTLoginController.h"

@interface HTLoginRootController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;

@end

@implementation HTLoginRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主界面";
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;    
}

#pragma mark - Action

- (void)viewDidTap {
    [self.view endEditing:YES];
}

- (IBAction)registerButtonClicked:(UIButton *)sender {
    HTRegisterController *registerController = [[HTRegisterController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES]; 
}

- (IBAction)loginButtonClicked:(UIButton *)sender {
<<<<<<< HEAD
    
=======
    HTLoginController *loginController = [[HTLoginController alloc] init];
    [self.navigationController pushViewController:loginController animated:YES];
>>>>>>> d3e028f7843c6c124d4b3426cc9506ce8c460d42
}

@end
