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
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

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
    self.userNameTextField.delegate = self;
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.userNameTextField) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 11;
    }else
        return YES;
}

#pragma mark - Subclass

- (void)nextButtonNeedToBeClicked {
    [super nextButtonNeedToBeClicked];
    [self registerButtonClicked:nil];
}

#pragma mark - Action

- (IBAction)registerButtonClicked:(UIButton *)sender {
    [MobClick event:@"register"];
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
    [MobClick event:@"weixinregister"];
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             DLog(@"uid=%@",user.uid);
             DLog(@"%@",user.credential);
             DLog(@"token=%@",user.credential.token);
             DLog(@"nickname=%@",user.nickname);
             
             [self loginWithUser:user];
         }

         else
         {
             DLog(@"%@",error);
         }
         
     }];
}

- (IBAction)loginButtonQQClicked:(id)sender {
    [MobClick event:@"weiboregister"];
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             DLog(@"uid=%@",user.uid);
             DLog(@"credential=%@",user.credential);
             DLog(@"token=%@",user.credential.token);
             DLog(@"nickname=%@",user.nickname);
             
             [self loginWithUser:user];
         }
         
         else
         {
             DLog(@"%@",error);
         }
         
     }];
}

- (IBAction)loginButtonWeiboClicked:(id)sender {
    [MobClick event:@"QQregister"];
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
    {
        if (state == SSDKResponseStateSuccess)
        {
            
            DLog(@"uid=%@",user.uid);
            DLog(@"%@",user.credential);
            DLog(@"token=%@",user.credential.token);
            DLog(@"nickname=%@",user.nickname);
            DLog(@"icon=%@",user.icon);
            
            [self loginWithUser:user];
        }
        else
        {
            DLog(@"%@",error);
        }
        
    }];
}

-(void)loginWithUser:(SSDKUser*)user {
    HTLoginUser *loginUser = [HTLoginUser new];
    loginUser.user_area_id = AppDelegateInstance.cityCode;
    loginUser.third_id = user.uid;
    loginUser.user_name = user.nickname;
    loginUser.user_avatar = user.icon;
    [HTProgressHUD show];
    [[[HTServiceManager sharedInstance] loginService] bindUserWithThirdPlatform:loginUser completion:^(BOOL success, HTResponsePackage *response) {
        [HTProgressHUD dismiss];
        DLog(@"%@", response);
        if (success) {
            if (response.resultCode == 0) {
                HTMainViewController *controller = [[HTMainViewController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = controller;
                [[[HTServiceManager sharedInstance] profileService] updateUserInfoFromSvr];
            } else {
                [self showTipsWithText:response.resultMsg];
            }
        } else {
            [self showTipsWithText:@"网络连接错误"];
        }
    }];

}

#pragma mark - Tool Method

@end
