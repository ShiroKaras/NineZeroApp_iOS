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
#import "HTShowAnswerView.h"
#import "HTUIHeader.h"
#import "CommonUI.h"
#import "HTARCaptureController.h"

static CGFloat kLeftMargin = 13; // 暂定为0

@interface HTPreviewQuestionController () <HTPreviewViewDelegate, HTComposeViewDelegate, HTPreviewItemDelegate>

@property (weak, nonatomic) IBOutlet UIButton *mainButton;                    // 左下角“九零”
@property (weak, nonatomic) IBOutlet UIButton *meButton;                      // 右下角“我”
@property (weak, nonatomic) IBOutlet UIButton *lingzaiButton;                 // 右下角"零仔"
@property (strong, nonatomic) HTPreviewView *previewView;                     // 预览题目控件
@property (strong, nonatomic) HTComposeView *composeView;                     // 答题界面
@property (strong, nonatomic) HTDescriptionView *descriptionView;             // 详情页面
@property (strong, nonatomic) HTShowDetailView *showDetailView;               // 提示详情
@property (strong, nonatomic) HTShowAnswerView *showAnswerView;               // 查看答案

@property (strong, nonatomic) UIImageView *bgImageView;

@end

@implementation HTPreviewQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorMake(14, 14, 14);
    
    UIImage *bgImage;
    if (SCREEN_WIDTH <= IPHONE5_SCREEN_WIDTH) {
        bgImage = [UIImage imageNamed:@"bg_success_640×1136"];
    } else if (SCREEN_WIDTH >= IPHONE6_PLUS_SCREEN_WIDTH) {
        bgImage = [UIImage imageNamed:@"bg_success_1242x2208"];
    } else {
        bgImage = [UIImage imageNamed:@"bg_success_750x1334"];
    }
    _bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    _bgImageView.hidden = YES;
    [self.view addSubview:_bgImageView];
    
    [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"加载数据中..."];
    [[[HTServiceManager sharedInstance] questionService] setLoginUser:[[[HTServiceManager sharedInstance] loginService] loginUser]];
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
    _bgImageView.frame = self.view.bounds;
    [self.view sendSubviewToBack:_bgImageView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public 

- (void)goToToday {
    [_previewView goToToday];
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
    [self.delegate previewController:self shouldShowGoBackItem:needShow];
    if (needShow) {
        [_mainButton setImage:[UIImage imageNamed:@"tab_back_today"] forState:UIControlStateNormal];
        _mainButton.tag = 1000;
    } else {
        [_mainButton setImage:[UIImage imageNamed:@"tab_home"] forState:UIControlStateNormal];
        _mainButton.tag = 0;
    }
}

- (void)previewView:(HTPreviewView *)previewView didScrollToItem:(HTPreviewItem *)item {
    if (item.breakSuccess) {
        _bgImageView.hidden = NO;
    } else {
        _bgImageView.hidden = YES;
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
            [_composeView becomeFirstResponder];
            [UIView animateWithDuration:0.3 animations:^{
                _composeView.alpha = 1.0;
                [self.view addSubview:_composeView];
            } completion:^(BOOL finished) {
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
            _showDetailView = [[HTShowDetailView alloc] initWithDetailText:previewItem.question.hint andShowInRect:[previewItem convertRect:[previewItem hintRect] toView:self.view]];
            _showDetailView.frame = self.view.bounds;
            _showDetailView.alpha = 0.0;
            [self.view addSubview:_showDetailView];
            [UIView animateWithDuration:0.3 animations:^{
                _showDetailView.alpha = 1.0;
            }];
            break;
        }
        case HTPreviewItemButtonTypeReward: {
            _showDetailView = [[HTShowDetailView alloc] initWithDetailText:@"一杯星巴克" andShowInRect:[previewItem convertRect:[previewItem hintRect] toView:self.view]];
            _showDetailView.frame = self.view.bounds;
            _showDetailView.alpha = 0.0;
            [self.view addSubview:_showDetailView];
            [UIView animateWithDuration:0.3 animations:^{
                _showDetailView.alpha = 1.0;
            }];
            break;
            break;
        }
        case HTPreviewItemButtonTypeAnswer: {
            HTARCaptureController *arCaptureController = [[HTARCaptureController alloc] init];
            [self presentViewController:arCaptureController animated:YES completion:nil];
//            [MBProgressHUD showWarningWithTitle:[NSString stringWithFormat:@"%@", previewItem.question.answers]];
//            _showAnswerView = [[HTShowAnswerView alloc] initWithURL:previewItem.question.detailURL];
//            _showAnswerView.alpha = 0.0;
//            _showAnswerView.frame = self.view.bounds;
//            [UIView animateWithDuration:0.3 animations:^{
//                _showAnswerView.alpha = 1.0f;
//                [self.view addSubview:_showAnswerView];
//            }];
//            break;
        }
        case HTPreviewItemButtonTypePause: {
        }
        case HTPreviewItemButtonTypeSound: {
            
        }
        default:
        break;
    }
}

#pragma mark - HTComposeView Delegate

- (void)composeView:(HTComposeView *)composeView didComposeWithAnswer:(NSString *)answer {
//    static int clickCount = 0;
//    [[[HTServiceManager sharedInstance] questionService] verifyQuestion:composeView.associatedQuestion.questionID withAnswer:answer callback:^(BOOL success, HTResponsePackage *package) {
//        if (success == YES && package.resultCode == 0) {
//            [composeView showAnswerCorrect:YES];
//            clickCount = 0;
//        } else {
//            [composeView showAnswerCorrect:NO];
//            clickCount++;
//        }
//        if (clickCount >= 3) {
//            [composeView showAnswerTips:composeView.associatedQuestion.hint];
//        }
//    }];
    [self composeWithAnswer:answer question:composeView.associatedQuestion];
}

- (void)composeWithAnswer:(NSString *)answer question:(HTQuestion *)question {
    static int clickCount = 0;
    NSString *daan = question.hint;
    if ([daan isEqualToString:answer]) {
        [_composeView showAnswerCorrect:YES];
        clickCount = 0;
    } else {
        [_composeView showAnswerCorrect:NO];
        clickCount++;
    }
    if (clickCount >= 3) {
        [_composeView showAnswerTips:question.hint];
    }
}

- (void)didClickDimingViewInComposeView:(HTComposeView *)composeView {
    [self.view endEditing:YES];
    [composeView removeFromSuperview];
}

#pragma mark - Tool Method

@end
