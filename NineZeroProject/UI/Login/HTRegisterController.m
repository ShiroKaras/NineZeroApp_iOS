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
    
    _sendAgainButton.enabled = NO;
    _secondsToCountDown = 180;
    
    [self scheduleTimerCountDown];
    
//    [self getVerificationCode];
}

#pragma mark - Subclass

- (void)nextButtonNeedToBeClicked {
    [self nextButtonClicked:nil];
}

#pragma mark - Action

- (IBAction)didClickSendAgainButton:(UIButton *)sender {
    [self getVerificationCode];
    _secondsToCountDown = 180;
    [self scheduleTimerCountDown];
    _sendAgainButton.enabled = NO;
}

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

- (void)getVerificationCode {
    [SMS_SDK getVerificationCodeBySMSWithPhone:_loginUser.user_mobile zone:@"86" result:^(SMS_SDKError *error) {
//        DLog(@"%@", [error description]);
    }];
}

- (void)scheduleTimerCountDown {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleTimerCountDown) object:nil];
    [self performSelector:@selector(scheduleTimerCountDown) withObject:nil afterDelay:1.0];
    _secondsToCountDown--;
    if (_secondsToCountDown <= 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleTimerCountDown) object:nil];
        [_sendAgainButton setTitle:@"再发一次" forState:UIControlStateNormal];
        _sendAgainButton.enabled = YES;
    } else {
        [UIView setAnimationsEnabled:NO];
        [_sendAgainButton setTitle:[NSString stringWithFormat:@"再发一次(%ld)", _secondsToCountDown] forState:UIControlStateNormal];
        [_sendAgainButton layoutIfNeeded];
        [UIView setAnimationsEnabled:YES];
    }
}
@end
