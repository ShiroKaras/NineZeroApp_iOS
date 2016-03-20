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
@property (nonatomic, strong) NSString *recordMobile;
@property (nonatomic, strong) NSString *recordAddress;
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
    self.mobileTextField.text = _userInfo.mobile;
    self.locationTextField.text = _userInfo.address;
    
    _userInfo = [[HTStorageManager sharedInstance] userInfo];
    
    _recordAddress = _userInfo.address;
    _recordMobile = _userInfo.mobile;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.completeButton.enabled = [self isCompleteValid];
}

- (IBAction)onClickCompleteButton:(HTLoginButton *)sender {
    _userInfo.mobile = self.mobileTextField.text;
    _userInfo.address = self.locationTextField.text;
    _userInfo.settingType = HTUpdateUserInfoTypeAddressAndMobile;
    
    [MBProgressHUD bwm_showHUDAddedTo:self.navigationController.view title:@"修改中"];
    [[[HTServiceManager sharedInstance] profileService] updateUserInfo:_userInfo completion:^(BOOL success, HTResponsePackage *response) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)textFieldTextDidChanged:(NSNotification *)notification {
    self.completeButton.enabled = [self isCompleteValid];
}

- (BOOL)isCompleteValid {
    if ([self.mobileTextField.text isEqualToString:_recordMobile] && [self.locationTextField.text isEqualToString:_recordAddress]) {
        return NO;
    }
    if (self.mobileTextField.text.length != 0 && self.locationTextField.text.length != 0) {
        return YES;
    }
    return NO;
}

@end
