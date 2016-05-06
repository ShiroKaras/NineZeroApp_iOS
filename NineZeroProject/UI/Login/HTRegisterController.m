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

@interface HTRegisterController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
@property (weak, nonatomic) IBOutlet HTLoginButton *sendAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

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
    [self.view endEditing:YES];
    _loginUser.code = self.verifyTextField.text;
    _loginUser.user_name = self.nickTextField.text;
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
            [MBProgressHUD bwm_showTitle:@"上传头像失败" toView:KEY_WINDOW hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeError];
        }
    } option:nil];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nickTextField) {
        if (textField.text.length > 8) {
            textField.text = [textField.text substringToIndex:8];
        }
    }
}

@end
