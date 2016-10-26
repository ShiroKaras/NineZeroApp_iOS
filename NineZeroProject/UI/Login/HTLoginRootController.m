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
@property (weak, nonatomic) IBOutlet HTLoginButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) UIButton *loginButton_Weixin;
@property (strong, nonatomic) UIButton *loginButton_QQ;
@property (strong, nonatomic) UIButton *loginButton_Weibo;

@end

@implementation HTLoginRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主界面";
    self.userNameTextField.delegate = self;
    [_loginButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self setTipsOffsetY:0];
    
    _loginButton_QQ = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton_QQ setImage:[UIImage imageNamed:@"btn_signup_qq"] forState:UIControlStateNormal];
    [_loginButton_QQ setImage:[UIImage imageNamed:@"btn_signup_qq_highlight"] forState:UIControlStateHighlighted];
    [_loginButton_QQ addTarget:self action:@selector(loginButtonQQClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton_QQ];
    
    _loginButton_Weixin = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton_Weixin setImage:[UIImage imageNamed:@"btn_signup_wechat"] forState:UIControlStateNormal];
    [_loginButton_Weixin setImage:[UIImage imageNamed:@"btn_signup_wechat_highlight"] forState:UIControlStateHighlighted];
    [_loginButton_Weixin addTarget:self action:@selector(loginButtonWeixinClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton_Weixin];
    
    _loginButton_Weibo = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton_Weibo setImage:[UIImage imageNamed:@"btn_signup_weibo"] forState:UIControlStateNormal];
    [_loginButton_Weibo setImage:[UIImage imageNamed:@"btn_signup_weibo_highlight"] forState:UIControlStateHighlighted];
    [_loginButton_Weibo addTarget:self action:@selector(loginButtonWeiboClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton_Weibo];
    
    UILabel *_label = [UILabel new];
    _label.text = @"使用其他账号";
    _label.textColor = COMMON_GREEN_COLOR;
    _label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [_label sizeToFit];
    [self.view addSubview:_label];
    
    UIView *_lSepLine = [UIView new];
    _lSepLine.backgroundColor = [UIColor colorWithHex:0x1A1A1A];
    [self.view addSubview:_lSepLine];
    
    UIView *_rSepLine = [UIView new];
    _rSepLine.backgroundColor = [UIColor colorWithHex:0x1A1A1A];
    [self.view addSubview:_rSepLine];
    
    __weak __typeof(self)weakSelf = self;
    
    if (SCREEN_HEIGHT != IPHONE4_SCREEN_HEIGHT) {
        [_loginButton_QQ mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@38);
            make.height.equalTo(@38);
            make.centerX.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-52);
        }];
        
        [_loginButton_Weixin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(_loginButton_QQ);
            make.centerY.equalTo(_loginButton_QQ);
            make.right.equalTo(_loginButton_QQ.mas_left).offset(-51);
        }];
        
        [_loginButton_Weibo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(_loginButton_QQ);
            make.centerY.equalTo(_loginButton_QQ);
            make.left.equalTo(_loginButton_QQ.mas_right).offset(51);
        }];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.bottom.equalTo(_loginButton_QQ.mas_top).offset(-45);
        }];
        
        [_lSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.centerY.equalTo(_label);
            make.left.equalTo(weakSelf.view).offset(16);
            make.right.equalTo(_label.mas_left).offset(-14);
        }];
        
        [_rSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.centerY.equalTo(_label);
            make.left.equalTo(_label.mas_right).offset(14);
            make.right.equalTo(weakSelf.view.mas_right).offset(-16);
        }];
    } else {
        [_loginButton_QQ mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@38);
            make.height.equalTo(@38);
            make.centerX.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-20);
        }];
        
        [_loginButton_Weixin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(_loginButton_QQ);
            make.centerY.equalTo(_loginButton_QQ);
            make.right.equalTo(_loginButton_QQ.mas_left).offset(-51);
        }];
        
        [_loginButton_Weibo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(_loginButton_QQ);
            make.centerY.equalTo(_loginButton_QQ);
            make.left.equalTo(_loginButton_QQ.mas_right).offset(51);
        }];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.bottom.equalTo(_loginButton_QQ.mas_top).offset(-20);
        }];
        
        [_lSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.centerY.equalTo(_label);
            make.left.equalTo(weakSelf.view).offset(16);
            make.right.equalTo(_label.mas_left).offset(-14);
        }];
        
        [_rSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.centerY.equalTo(_label);
            make.left.equalTo(_label.mas_right).offset(14);
            make.right.equalTo(weakSelf.view.mas_right).offset(-16);
        }];
    }
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
//    self.navigationController.navigationBarHidden = NO;    
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


//- (IBAction)registerButtonClickedTouchDown:(id)sender {
//    _registerButton.backgroundColor = COMMON_PINK_COLOR;
//}

- (IBAction)registerButtonClicked:(UIButton *)sender {
//    _registerButton.backgroundColor = COMMON_GREEN_COLOR;
    //[MobClick event:@"register"];
     [TalkingData trackEvent:@"register"];
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
    //[MobClick event:@"weixinregister"];
    [TalkingData trackEvent:@"weixinregister"];
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
    //[MobClick event:@"weiboregister"];
    [TalkingData trackEvent:@"qqregister"];
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
    //[MobClick event:@"QQregister"];
    [TalkingData trackEvent:@"weiboregister"];
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
                SKIndexViewController *controller = [[SKIndexViewController alloc] init];
//                [UIApplication sharedApplication].keyWindow.rootViewController = controller;
                AppDelegateInstance.mainController = controller;
                HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:controller];
                AppDelegateInstance.window.rootViewController = navController;
                [AppDelegateInstance.window makeKeyAndVisible];
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
