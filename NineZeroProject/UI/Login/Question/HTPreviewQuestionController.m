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
#import "HTDescriptionView.h"
#import "HTShowDetailView.h"
#import "HTUIHeader.h"
#import "CommonUI.h"

static CGFloat kLeftMargin = 13; // 暂定为0

@interface HTPreviewQuestionController () <HTPreviewViewDelegate, HTComposeViewDelegate, HTPreviewItemDelegate>

@property (weak, nonatomic) IBOutlet UIButton *mainButton;                    // 左下角“九零”
@property (weak, nonatomic) IBOutlet UIButton *meButton;                      // 右下角“我”
@property (weak, nonatomic) IBOutlet UIButton *lingzaiButton;                 // 右下角"零仔"
@property (strong, nonatomic) HTPreviewView *previewView;                     // 预览题目控件
@property (strong, nonatomic) HTComposeView *composeView;                     // 答题界面
@property (strong, nonatomic) HTDescriptionView *descriptionView;             // 详情页面
@property (strong, nonatomic) HTShowDetailView *showDetailView;               // 提示详情

@end

@implementation HTPreviewQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"加载数据中..."];
    
    [[[HTServiceManager sharedInstance] questionService] getQuestionInfoWithCallback:^(BOOL success, HTQuestionInfo *questionInfo) {
        if (questionInfo.questionCount <= 0) return;
        [[[HTServiceManager sharedInstance] questionService] getQuestionListWithPage:1 count:questionInfo.questionCount callback:^(BOOL success, NSArray<HTQuestion *> *questionList) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            _previewView = [[HTPreviewView alloc] initWithFrame:CGRectMake(kLeftMargin, 0, self.view.width - kLeftMargin, self.view.height) andQuestions:questionList];
            _previewView.delegate = self;
            [_previewView setQuestionInfo:questionInfo];
            [self.view insertSubview:self.previewView atIndex:0];
            
            for (HTPreviewItem *item in _previewView.items) {
                item.delegate = self;
            }
        }];
    }];

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
    _composeView.frame = CGRectMake(0, 0, self.view.width, self.view.height - keyboardRect.size.height);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [_composeView removeFromSuperview];
}

#pragma mark - Action

- (IBAction)mainButtonClicked:(UIButton *)sender {
    if (sender.tag == 1000) {
        [_previewView goToToday];
    }
}

#pragma mark - HTPreviewView Delegate

- (void)previewView:(HTPreviewView *)previewView shouldShowGoBackItem:(BOOL)needShow {
    if (needShow) {
        [_mainButton setImage:[UIImage imageNamed:@"tab_back_today"] forState:UIControlStateNormal];
        _mainButton.tag = 1000;
    } else {
        [_mainButton setImage:[UIImage imageNamed:@"tab_home"] forState:UIControlStateNormal];
        _mainButton.tag = 0;
    }
}

#pragma mark - HTPreviewItem Delegate

- (void)previewItem:(HTPreviewItem *)previewItem didClickButtonWithType:(HTPreviewItemButtonType)type {
    switch (type) {
        case HTPreviewItemButtonTypeCompose: {
            _composeView = [[HTComposeView alloc] init];
            _composeView.delegate = self;
            _composeView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
            _composeView.alpha = 0.0;
            _composeView.associatedQuestion = previewItem.question;
            [UIView animateWithDuration:0.3 animations:^{
                _composeView.alpha = 1.0;
                [self.view addSubview:_composeView];
            } completion:^(BOOL finished) {
                [_composeView becomeFirstResponder];
            }];
            break;
        }
        case HTPreviewItemButtonTypeContent: {
            _descriptionView = [[HTDescriptionView alloc] initWithURLString:previewItem.question.questionDescription];
            _descriptionView.frame = self.view.bounds;
            _descriptionView.alpha = 0;
            _descriptionView.top = self.view.bottom;
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _descriptionView.top = 0;
                [self.view addSubview:_descriptionView];
                _descriptionView.alpha = 1.0;
            } completion:nil];
            break;
        }
        case HTPreviewItemButtonTypeHint: {
            [MBProgressHUD showWarningWithTitle:previewItem.question.hint];
            break;
        }
        case HTPreviewItemButtonTypeReward: {
            [MBProgressHUD showWarningWithTitle:@"星巴克一杯"];
            break;
        }
        case HTPreviewItemButtonTypeAnswer: {
            [MBProgressHUD showWarningWithTitle:[NSString stringWithFormat:@"%@", previewItem.question.answers]];
            break;
        }
    }
}

#pragma mark - HTComposeView Delegate

- (void)composeView:(HTComposeView *)composeView didComposeWithAnswer:(NSString *)answer {
    static int clickCount = 0;
    [[[HTServiceManager sharedInstance] questionService] verifyQuestion:composeView.associatedQuestion.questionID withAnswer:answer callback:^(BOOL success, HTResponsePackage *package) {
        if (success == YES && package.resultCode == 0) {
            [composeView showAnswerCorrect:YES];
            clickCount = 0;
        } else {
            [composeView showAnswerCorrect:NO];
            clickCount++;
        }
        if (clickCount >= 3) {
            [composeView showAnswerTips:composeView.associatedQuestion.hint];
        }
    }];
}

- (void)didClickDimingViewInComposeView:(HTComposeView *)composeView {
    [self.view endEditing:YES];
    [composeView removeFromSuperview];
}

@end
