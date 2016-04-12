//
//  HTLoginRootController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/2.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTLoginRootController.h"
#import "CommonUI.h"
#import "HTRegisterController.h"
#import "HTLoginController.h"
#import <MBProgressHUD+BWMExtension.h>
#import "HTModel.h"
#import "HTUIHeader.h"
#import "NSString+Utility.h"
#import <ShareSDK/ShareSDK.h>

@interface HTLoginRootController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton_Weixin;
@property (weak, nonatomic) IBOutlet UIButton *loginButton_QQ;
@property (weak, nonatomic) IBOutlet UIButton *loginButton_Weibo;

@end

@implementation HTLoginRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主界面";
    [_loginButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self setTipsOffsetY:20];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//#ifdef HT_DEBUG
//    self.userNameTextField.text = [NSString stringWithFormat:@"%ld", (arc4random() % 1000000000) + 10000000000];
//    self.userPasswordTextField.text = @"1123123";
//    self.registerButton.enabled = YES;
//#endif
}

#pragma mark - Subclass

- (void)nextButtonNeedToBeClicked {
    [super nextButtonNeedToBeClicked];
    [self registerButtonClicked:nil];
}

#pragma mark - Action

- (IBAction)registerButtonClicked:(UIButton *)sender {
    if (self.userNameTextField.text.length != 11) {
        [self showTipsWithText:@"请检查手机号码是否正确"];
        return;
    }
    if (self.userPasswordTextField.text.length < 6) {
        [self showTipsWithText:@"密码过于简单，请输入不低于6位密码"];
        return;
    }
    if (self.userPasswordTextField.text.length > 20) {
        [self showTipsWithText:@"密码不能多于20个字，请重新输入"];
        return;
    }
    _loginButton.enabled = NO;
    [HTProgressHUD show];
    [[[HTServiceManager sharedInstance] loginService] verifyMobile:self.userNameTextField.text completion:^(BOOL success, HTResponsePackage *response) {
        _loginButton.enabled = YES;
        [HTProgressHUD dismiss];
        if (success) {
            if (response.resultCode == 0) {
                HTLoginUser *loginUser = [[HTLoginUser alloc] init];
                loginUser.user_mobile = self.userNameTextField.text;
                loginUser.user_password = self.userPasswordTextField.text;
                HTRegisterController *registerController = [[HTRegisterController alloc] initWithUser:loginUser];
                [self.navigationController pushViewController:registerController animated:YES];
            } else {
                [self showTipsWithText:response.resultMsg];
            }
        } else {
            [self showTipsWithText:@"网络连接错误"];
        }
    }];
}

- (IBAction)loginButtonClicked:(UIButton *)sender {
    HTLoginController *loginController = [[HTLoginController alloc] init];
    [self.navigationController pushViewController:loginController animated:YES];
}

- (IBAction)loginButtonWeixinClicked:(id)sender {
    
}

- (IBAction)loginButtonQQClicked:(id)sender {
    
}

- (IBAction)loginButtonWeiboClicked:(id)sender {
    //例如Weibo的登录
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             NSLog(@"avataer=%@",user.icon);
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}


#pragma mark - Tool Method

@end
