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
#import "HTLoginUser.h"
#import "HTLog.h"
#import "HTLoginButton.h"
#import "HTServiceManager.h"
#import "HTLoginController.h"
#import "NSString+Utility.h"

@interface HTRegisterController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
@property (weak, nonatomic) IBOutlet HTLoginButton *sendAgainButton;

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

#pragma mark - Action

- (IBAction)avatarButtonClicked:(UIButton *)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:@"取消"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"拍照", @"从相册选择", nil];
	[actionSheet showInView:self.view];
}

- (IBAction)nextButtonClicked:(UIButton *)sender {
    _loginUser.code = self.verifyTextField.text;
    _loginUser.user_name = self.nickTextField.text;
    // 登录前混淆加密
    _loginUser.user_password = [[_loginUser.user_password confusedWithSalt:_loginUser.user_mobile] sha256];
    // TODO:这些值不能临时填
    _loginUser.user_email = @"408895175@qq.com";
    _loginUser.user_avatar = @"test";
    _loginUser.user_area_id = @"1";
    // end
    [[[HTServiceManager sharedInstance] loginService] registerWithUser:_loginUser success:^(id responseObject) {
        HTLoginController *loginController = [[HTLoginController alloc] init];
        [self.navigationController pushViewController:loginController animated:YES];
    } error:^(NSString *errorMessage) {

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
	
}

#pragma mark - Tool Method



@end
