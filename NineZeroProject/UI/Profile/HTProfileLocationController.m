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

@end

@implementation HTProfileLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.title = @"管理地址";
    self.completeButton.enabled = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.completeButton.enabled = [self isCompleteValid];
    return YES;
}

- (IBAction)onClickCompleteButton:(HTLoginButton *)sender {
    
}

- (BOOL)isCompleteValid {
    if (self.mobileTextField.text.length != 0 && self.locationTextField.text.length != 0) {
        return YES;
    }
    return NO;
}

@end
