//
//  HTProfileLocationController.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/28.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfileLocationController.h"
#import "HTUIHeader.h"

@interface HTProfileLocationController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet HTLoginButton *completeButton;
@property (nonatomic, strong) HTUserInfo *userInfo;
@end

@implementation HTProfileLocationController

- (instancetype)initWithUserInfo:(HTUserInfo *)userInfo {
    if (self = [super init]) {
        _userInfo = userInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.title = @"管理地址";
    self.completeButton.enabled = NO;
    self.mobileTextField.text = _userInfo.mobile;
    self.locationTextField.text = _userInfo.address;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.completeButton.enabled = [self isCompleteValid];
    return YES;
}

- (IBAction)onClickCompleteButton:(HTLoginButton *)sender {
    _userInfo.mobile = self.mobileTextField.text;
    _userInfo.address = self.locationTextField.text;
    [MBProgressHUD bwm_showHUDAddedTo:self.navigationController.view title:@"修改中"];
    [[[HTServiceManager sharedInstance] profileService] updateUserInfo:_userInfo completion:^(BOOL success, HTResponsePackage *response) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

- (BOOL)isCompleteValid {
    if (self.mobileTextField.text.length != 0 && self.locationTextField.text.length != 0) {
        return YES;
    }
    return NO;
}

@end
