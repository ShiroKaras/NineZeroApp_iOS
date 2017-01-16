//
//  SKLoginRootViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/17.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKLoginRootViewController.h"
#import "HTUIHeader.h"

#import "SKRegisterViewController.h"
#import "SKLoginViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

@interface SKLoginRootViewController ()

@end

@implementation SKLoginRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    __weak __typeof(self)weakSelf = self;
    
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    for (int i = 0; i<174; i++) {
        UIImage *animatedImage = [UIImage imageNamed:[NSString stringWithFormat:@"logo_640_%04d.png", i]];
        [images addObject:animatedImage];
    }
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.animationImages = images;
    backImageView.animationDuration = 0.033 * images.count;
    backImageView.animationRepeatCount = 0;
    [backImageView startAnimating];
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((SCREEN_HEIGHT-49-54)/930*640);
        make.height.mas_equalTo(SCREEN_HEIGHT-49-54);
        make.top.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    UIView *bottomView1 = [UIView new];
    bottomView1.backgroundColor = COMMON_RED_COLOR;
    [self.view addSubview:bottomView1];
    [bottomView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
        make.height.equalTo(@49);
    }];
    
    UILabel *otherPlatformLabel = [UILabel new];
    otherPlatformLabel.text = @"其他账号登录";
    otherPlatformLabel.textColor = [UIColor whiteColor];
    otherPlatformLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [otherPlatformLabel sizeToFit];
    [self.view addSubview:otherPlatformLabel];
    [otherPlatformLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView1.mas_left).offset((SCREEN_WIDTH-215)/2);
        make.centerY.equalTo(bottomView1);
    }];
    
    UIButton *loginButton_QQ = [UIButton new];
    [loginButton_QQ addTarget:self action:@selector(loginButtonQQClicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton_QQ setBackgroundImage:[UIImage imageNamed:@"btn_logins_QQ"] forState:UIControlStateNormal];
    [loginButton_QQ setBackgroundImage:[UIImage imageNamed:@"btn_logins_QQ_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:loginButton_QQ];
    [loginButton_QQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@25);
        make.height.equalTo(@25);
        make.left.equalTo(otherPlatformLabel.mas_right).offset(20);
        make.centerY.equalTo(otherPlatformLabel);
    }];
    
    UIButton *loginButton_Weixin = [UIButton new];
    [loginButton_Weixin addTarget:self action:@selector(loginButtonWeixinClicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton_Weixin setBackgroundImage:[UIImage imageNamed:@"btn_logins_Wechat"] forState:UIControlStateNormal];
    [loginButton_Weixin setBackgroundImage:[UIImage imageNamed:@"btn_logins_Wechat_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:loginButton_Weixin];
    [loginButton_Weixin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@25);
        make.height.equalTo(@25);
        make.left.equalTo(loginButton_QQ.mas_right).offset(20);
        make.centerY.equalTo(otherPlatformLabel);
    }];
    
    UIButton *loginButton_Weibo = [UIButton new];
    [loginButton_Weibo addTarget:self action:@selector(loginButtonWeiboClicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton_Weibo setBackgroundImage:[UIImage imageNamed:@"btn_logins_Weibo"] forState:UIControlStateNormal];
    [loginButton_Weibo setBackgroundImage:[UIImage imageNamed:@"btn_logins_Weibo_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:loginButton_Weibo];
    [loginButton_Weibo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@25);
        make.height.equalTo(@25);
        make.left.equalTo(loginButton_Weixin.mas_right).offset(20);
        make.centerY.equalTo(otherPlatformLabel);
    }];
    
    UIView *bottomView2 = [UIView new];
    bottomView2.backgroundColor = COMMON_RED_COLOR;
    [self.view addSubview:bottomView2];
    [bottomView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(bottomView1.mas_top);
        make.height.equalTo(@54);
    }];
    
    UIButton *registerButton = [UIButton new];
    [registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:COMMON_GREEN_COLOR forState:UIControlStateHighlighted];
    [bottomView2 addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView2);
        make.top.equalTo(bottomView2);
        make.height.equalTo(@54);
        make.width.equalTo(@(SCREEN_WIDTH/2));
    }];
    
    UIButton *loginButton = [UIButton new];
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:COMMON_GREEN_COLOR forState:UIControlStateHighlighted];
    [bottomView2 addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView2);
        make.top.equalTo(bottomView2);
        make.height.equalTo(@54);
        make.width.equalTo(@(SCREEN_WIDTH/2));
    }];
    
}

#pragma mark - Actions

- (void)registerButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"register"];
    SKRegisterViewController *controller = [[SKRegisterViewController alloc] init];
    UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:root animated:YES completion:nil];
}

- (void)loginButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"login"];
    SKLoginViewController *controller = [[SKLoginViewController alloc] init];
    UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:root animated:YES completion:nil];
}

- (void)loginButtonWeixinClicked:(id)sender {
    [TalkingData trackEvent:@"fogetpassword"];
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

- (void)loginButtonQQClicked:(id)sender {
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

- (void)loginButtonWeiboClicked:(id)sender {
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
    SKLoginUser *loginUser = [SKLoginUser new];
    loginUser.user_area_id = AppDelegateInstance.cityCode;
    loginUser.third_id = user.uid;
    loginUser.user_name = user.nickname;
    loginUser.user_avatar = user.icon;
    [HTProgressHUD show];
    
    [[[SKServiceManager sharedInstance] loginService] loginWithThirdPlatform:loginUser callback:^(BOOL success, SKResponsePackage *response) {
        [HTProgressHUD dismiss];
        DLog(@"%@", response);
        if (success) {
            if (response.result == 0) {
                SKHomepageViewController *controller = [[SKHomepageViewController alloc] init];
                AppDelegateInstance.mainController = controller;
                HTNavigationController *navController = [[HTNavigationController alloc] initWithRootViewController:controller];
                AppDelegateInstance.window.rootViewController = navController;
                [AppDelegateInstance.window makeKeyAndVisible];
                [[[SKServiceManager sharedInstance] profileService] updateUserInfoFromServer];
            } else {
                NSLog(@"%ld", response.result);
            }
        } else {
            [self showTipsWithText:@"网络连接错误"];
        }
    }];

    
}
@end
