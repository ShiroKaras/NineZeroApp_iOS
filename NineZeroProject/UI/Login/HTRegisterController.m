//
//  HTRegisterController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/21.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTRegisterController.h"
#import "UIViewController+ImagePicker.h"
#import "HTUIHeader.h"
#import "HTLoginButton.h"
#import "HTServiceManager.h"
#import "HTLoginController.h"
#import "NSString+Utility.h"
#import "HTMainViewController.h"
#import "SKIndexViewController.h"
#import "HTWebController.h"
#import "SKUserAgreementViewController.h"

@interface HTRegisterController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
@property (weak, nonatomic) IBOutlet HTLoginButton *sendAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *userAgreementButton;
//@property (weak, nonatomic) IBOutlet HTLoginButton *nextButton;

@end

@implementation HTRegisterController {
    HTLoginUser *_loginUser;
    NSInteger _secondsToCountDown;
}

- (instancetype)initWithUser:(HTLoginUser *)user {
    if (self = [super init]) {
        _loginUser = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    _avatarButton.layer.cornerRadius = _avatarButton.width / 2;
    _avatarButton.layer.masksToBounds = YES;
    
    [self.nickTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [TalkingData trackPageBegin:@"registerpage"];
//    [MobClick beginLogPageView:@"registerpage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"registerpage"];
//    [MobClick endLogPageView:@"registerpage"];
}

#pragma mark - Subclass

- (void)nextButtonNeedToBeClicked {
    [self nextButtonClicked:nil];
}

- (BOOL)needScheduleVerifyTimer {
    return YES;
}

- (void)needGetVerificationCode {
    [[[HTServiceManager sharedInstance] loginService] getMobileCode:_loginUser.user_mobile];
}

#pragma mark - Action

- (IBAction)avatarButtonClicked:(UIButton *)sender {
    [self presentSystemPhotoLibraryController];
}

- (IBAction)nextButtonClicked:(UIButton *)sender {
    _nextButton.backgroundColor = COMMON_GREEN_COLOR;
    [self.view endEditing:YES];
    _loginUser.code = self.verifyTextField.text;
    _loginUser.user_name = [self.nickTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // 登录前混淆加密
    _loginUser.user_password = [NSString confusedPasswordWithLoginUser:_loginUser];
    // TODO:这些值不能临时填
    _loginUser.user_email = @"null";
    if (_loginUser.user_avatar.length == 0) _loginUser.user_avatar = @"";
    _loginUser.user_area_id = AppDelegateInstance.cityCode;
    // end
    
    [HTProgressHUD show];
    [[[HTServiceManager sharedInstance] loginService] registerWithUser:_loginUser completion:^(BOOL success, HTResponsePackage *response) {
        [HTProgressHUD dismiss];
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

- (IBAction)userAgreementButtonClicked:(id)sender {
//    HTWebController *webController = [[HTWebController alloc] initWithURLString:[NSURL URLWithString:@""]];
//    webController.title = @"用户协议";
//    [self.navigationController pushViewController:webController animated:YES];
    SKUserAgreementViewController *userAgreementViewController = [[SKUserAgreementViewController alloc] init];
    [self.navigationController pushViewController:userAgreementViewController animated:YES];
}
#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self presentSystemCameraController];
	}
	if (buttonIndex == 1) {
		[self presentSystemPhotoLibraryController];
	}
}

#pragma mark - UIImagePickerViewController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagePath = [path stringByAppendingPathComponent:@"avatar"];
    [imageData writeToFile:imagePath atomically:YES];

    [MBProgressHUD bwm_showHUDAddedTo:KEY_WINDOW title:@"处理中" animated:YES];
    NSString *avatarKey = [NSString avatarName];
    [[[HTServiceManager sharedInstance] qiniuService] putData:imageData key:avatarKey token:[[HTStorageManager sharedInstance] qiniuPublicToken] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        DLog(@"data = %@, key = %@, resp = %@", info, key, resp);
        [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
        if (info.statusCode == 200) {
            _loginUser.user_avatar = [NSString qiniuDownloadURLWithFileName:key];
            [_avatarButton setImage:image forState:UIControlStateNormal];
        } else {
            [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
            [MBProgressHUD bwm_showTitle:@"上传头像失败" toView:KEY_WINDOW hideAfter:1.0];
        }
    } option:nil];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nickTextField) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
}

@end
