//
//  HTCommonViewController.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/24.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTCommonViewController.h"

@implementation HTCommonViewController {
    UITextField *_firstTextField;
    UITextField *_secondTextField;
    UIButton *_nextButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstTextField = [self.view viewWithTag:100];
    _secondTextField = [self.view viewWithTag:200];
    _nextButton = [self.view viewWithTag:300];
    
    _firstTextField.delegate = self;
    _secondTextField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _nextButton.enabled = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Subclass

- (void)nextButtonNeedToBeClicked {
    ;
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

@end
