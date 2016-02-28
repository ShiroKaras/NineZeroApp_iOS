//
//  HTFeedbackController.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/28.
//  Copyright © 2016年 ronhu. All rights reserved.
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
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.submitButton.enabled = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.submitButton.enabled = [self isSubmitButtonValid];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.placeholderLabel.hidden = (textView.text.length != 0);
    self.submitButton.enabled = [self isSubmitButtonValid];
    return YES;
}

- (IBAction)onClickSubmit:(UIButton *)sender {
    self.submitButton.enabled = YES;
}

- (BOOL)isSubmitButtonValid {
    if (self.textView.text.length != 0 && self.textField.text.length != 0) {
        return YES;
    }
    return NO;
}

@end
