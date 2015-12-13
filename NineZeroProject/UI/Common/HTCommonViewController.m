//
//  HTCommonViewController.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/24.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTCommonViewController.h"
#import <SMS_SDK/SMS_SDK.h>

@implementation HTCommonViewController {
    UITextField *_firstTextField;
    UITextField *_secondTextField;
    UIButton *_nextButton;
    UIButton *_verifyButton;
    NSInteger _secondsToCountDown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // tag值在xib里面设置
    _firstTextField = (UITextField *)[self.view viewWithTag:100];
    _secondTextField = (UITextField *)[self.view viewWithTag:200];
    _nextButton = (UIButton *)[self.view viewWithTag:300];
    _verifyButton = (UIButton *)[self.view viewWithTag:400];
    
    
    [_verifyButton addTarget:self action:@selector(didClickVerifyButton) forControlEvents:UIControlEventTouchUpInside];
    
    _firstTextField.delegate = self;
    _secondTextField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _nextButton.enabled = NO;
    _verifyButton.enabled = NO;
    if ([self needScheduleVerifyTimer]) {
        [self needGetVerificationCode];
        _secondsToCountDown = 180;
        [self scheduleTimerCountDown];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Subclass

- (void)nextButtonNeedToBeClicked {
    ;
}

- (BOOL)needScheduleVerifyTimer {
    return NO;
}

- (void)needGetVerificationCode {
    ;
}

#pragma mark - Action

- (void)didClickVerifyButton {
    [self needGetVerificationCode];
    _secondsToCountDown = 180;
    _verifyButton.enabled = NO;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _firstTextField) {
        [_secondTextField becomeFirstResponder];
        return YES;
    }
    if (textField == _secondTextField) {
        if ([self isNextButtonValid]) {
            [self nextButtonNeedToBeClicked];
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    if ([self isNextButtonValid]) {
        _nextButton.enabled = YES;
    } else {
        _nextButton.enabled = NO;
    }
}

#pragma mark - Public Method

- (BOOL)isNextButtonValid {
    if (_firstTextField.text.length != 0 &&
        _secondTextField.text.length != 0) {
        return YES;
    }
    return NO;
}

- (void)scheduleTimerCountDown {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleTimerCountDown) object:nil];
    [self performSelector:@selector(scheduleTimerCountDown) withObject:nil afterDelay:1.0];
    _secondsToCountDown--;
    if (_secondsToCountDown <= 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleTimerCountDown) object:nil];
        [_verifyButton setTitle:@"再发一次" forState:UIControlStateNormal];
        _verifyButton.enabled = YES;
    } else {
        [UIView setAnimationsEnabled:NO];
        [_verifyButton setTitle:[NSString stringWithFormat:@"再发一次(%ld)", (long)_secondsToCountDown] forState:UIControlStateNormal];
        [_verifyButton layoutIfNeeded];
        [UIView setAnimationsEnabled:YES];
    }
}

@end
