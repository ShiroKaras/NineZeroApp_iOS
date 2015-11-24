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
#import "HTServiceManager.h"

@interface HTRegisterController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;

@end

@implementation HTRegisterController {
    HTLoginUser *_loginUser;
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
    [SMS_SDK getVerificationCodeBySMSWithPhone:_loginUser.user_mobile zone:@"86" result:^(SMS_SDKError *error) {
        DLog(@"%@", [error description]);
    }];
}

#pragma mark - Subclass

- (void)nextButtonNeedToBeClicked {
    [self nextButtonClicked:nil];
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
    // TODO:这些值不能临时填
    _loginUser.user_email = @"408895175@qq.com";
    _loginUser.user_avatar = @"test";
    _loginUser.user_area_id = @"1";
    // end
    [[[HTServiceManager sharedInstance] loginService] registerWithUser:_loginUser success:^(id responseObject) {
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

@end
