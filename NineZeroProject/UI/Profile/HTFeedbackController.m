//
//  HTFeedbackController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/28.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTFeedbackController.h"
#import "HTUIHeader.h"

@interface HTFeedbackController () <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet HTLoginButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@end

@implementation HTFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈意见";
    self.view.backgroundColor = [UIColor blackColor];
    self.submitButton.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldTextDidChanged:(NSNotification *)notication {
    self.submitButton.enabled = [self isSubmitButtonValid];
}

- (void)textViewTextDidChanged:(NSNotification *)notification {
    self.placeholderLabel.hidden = (self.textView.text.length != 0);
    self.submitButton.enabled = [self isSubmitButtonValid];
}

- (IBAction)onClickSubmit:(UIButton *)sender {
    self.submitButton.enabled = NO;
    [self.view endEditing:YES];
    [MBProgressHUD bwm_showHUDAddedTo:KEY_WINDOW title:@"反馈中"];
    [[[HTServiceManager sharedInstance] profileService] feedbackWithContent:self.textView.text mobile:self.textField.text completion:^(BOOL success, HTResponsePackage *response) {
        [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
        [MBProgressHUD bwm_showTitle:@"感谢反馈" toView:KEY_WINDOW hideAfter:1.0 msgType:BWMMBProgressHUDMsgTypeSuccessful];
        if (success && response.resultCode == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (BOOL)isSubmitButtonValid {
    if (self.textView.text.length != 0 && self.textField.text.length != 0) {
        return YES;
    }
    return NO;
}

@end
