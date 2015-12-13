//
//  HTPreviewQuestionController.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/6.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTPreviewQuestionController.h"
#import "HTPreviewItem.h"
#import "HTPreviewView.h"
#import "HTComposeView.h"
#import "CommonUI.h"

static CGFloat kLeftMargin = 13; // 暂定为0

@interface HTPreviewQuestionController () <HTPreviewViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *mainButton;                    // 左下角“九零”
@property (weak, nonatomic) IBOutlet UIButton *meButton;                      // 右下角“我”
@property (weak, nonatomic) IBOutlet UIButton *lingzaiButton;                 // 右下角"零仔"
@property (strong, nonatomic) HTPreviewView *previewView;                     // 预览题目控件
@property (strong, nonatomic) HTComposeView *composeView;                     // 答题界面

@end

@implementation HTPreviewQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    _previewView = [[HTPreviewView alloc] initWithFrame:CGRectMake(kLeftMargin, 0, self.view.width - kLeftMargin, self.view.height) andQuestions:nil];
    _previewView.delegate = self;
    [self.view insertSubview:self.previewView atIndex:0];
    
    _composeView = [[HTComposeView alloc] init];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.3 animations:^{
       _composeView.frame = CGRectMake(0, 0, self.view.width, self.view.height - keyboardRect.size.height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [_composeView removeFromSuperview];
}

#pragma mark - HTPreviewView Delegate

- (void)previewView:(HTPreviewView *)previewView didClickComposeWithItem:(HTPreviewItem *)item {
    _composeView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    _composeView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        _composeView.alpha = 1.0;
        [self.view addSubview:_composeView];
    } completion:^(BOOL finished) {
        [_composeView becomeFirstResponder];
    }];
}

@end
