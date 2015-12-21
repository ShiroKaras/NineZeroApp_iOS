//
//  HTRegisterController.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/21.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTRegisterController.h"
#import "UIViewController+ImagePicker.h"
#import <SMS_SDK/SMS_SDK.h>
#import "HTUIHeader.h"
#import "HTLoginButton.h"
#import "HTServiceManager.h"
#import "HTLoginController.h"
#import "NSString+Utility.h"
#import "HTPreviewQuestionController.h"

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
}

#pragma mark - Subclass

- (void)nextButtonNeedToBeClicked {
    [self nextButtonClicked:nil];
}

- (BOOL)needScheduleVerifyTimer {
    return YES;
}

- (void)needGetVerificationCode {
    [SMS_SDK getVerificationCodeBySMSWithPhone:_loginUser.user_mobile zone:@"86" customIdentifier:nil result:nil];
}

#pragma mark - Action

- (IBAction)avatarButtonClicked:(UIButton *)sender {
    [self presentSystemPhotoLibraryController];
}

- (IBAction)nextButtonClicked:(UIButton *)sender {
    _loginUser.code = self.verifyTextField.text;
    _loginUser.user_name = self.nickTextField.text;
    // 登录前混淆加密
    _loginUser.user_password = [NSString confusedPasswordWithLoginUser:_loginUser];
    // TODO:这些值不能临时填
    _loginUser.user_email = @"test";
    _loginUser.user_avatar = @"test";
    _loginUser.user_area_id = @"1";
    // end
    
    [[[HTServiceManager sharedInstance] loginService] registerWithUser:_loginUser completion:^(BOOL success, HTResponsePackage *response) {
        if (success) {
            if (response.resultCode == 0) {
                HTPreviewQuestionController *controller = [[HTPreviewQuestionController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = controller;
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
    UIImage *resizeImage = [UIImage imageWithImage:image scaledToSize:_avatarButton.size];
    [_avatarButton setImage:resizeImage forState:UIControlStateNormal];
    _avatarButton.layer.cornerRadius = _avatarButton.width / 2;
    _avatarButton.layer.masksToBounds = YES;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagePath = [path stringByAppendingPathComponent:@"avatar"];
    [imageData writeToFile:imagePath atomically:YES];
//    QNUploadOption *updateOption = [[QNUploadOption alloc] init];
//    updateOption.mimeType = @"image/jpeg";

    // iOSAvatar+手机号作为头像名
    [[[HTServiceManager sharedInstance] qiniuService] putData:imageData key:[NSString stringWithFormat:@"iOSAvatar_%@", _loginUser.user_mobile] token:[[[HTServiceManager sharedInstance] loginService] qiniuToken] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        DLog(@"data = %@, key = %@, resp = %@", info, key, resp);
    } option:nil];
}

@end
