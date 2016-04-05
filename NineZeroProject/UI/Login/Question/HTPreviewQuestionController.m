//
//  HTPreviewQuestionController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/12/6.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
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
#import "HTQuestionHelper.h"
#import "HTARCaptureController.h"
#import "AppDelegate.h"
#import "HTRewardController.h"
#import "Reachability.h"
#import "SharkfoodMuteSwitchDetector.h"
#import <AFNetworking.h>

static CGFloat kLeftMargin = 13; // 暂定为0

@interface HTPreviewQuestionController () <HTPreviewViewDelegate, HTComposeViewDelegate, HTPreviewItemDelegate, HTARCaptureControllerDelegate>

@property (strong, nonatomic) HTPreviewView *previewView;                     // 预览题目控件
@property (strong, nonatomic) HTComposeView *composeView;                     // 答题界面
@property (strong, nonatomic) HTDescriptionView *descriptionView;             // 详情页面
@property (strong, nonatomic) HTShowDetailView *showDetailView;               // 提示详情
@property (strong, nonatomic) HTShowAnswerView *showAnswerView;               // 查看答案

@property (strong, nonatomic) UIImageView *bgImageView;

@property (nonatomic,strong) SharkfoodMuteSwitchDetector* detector;

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
    
    UIWindow *bgWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgWindow.windowLevel = UIWindowLevelAlert;
    bgWindow.backgroundColor = [UIColor blackColor];
    UIViewController *bgController = [[UIViewController alloc] init];
    bgController.view.backgroundColor = [UIColor blackColor];
    bgWindow.rootViewController = [[UIViewController alloc] init];
    [bgWindow makeKeyAndVisible];
    
    MBProgressHUD *HUD = [MBProgressHUD bwm_showHUDAddedTo:bgWindow title:@"加载数据中..."];
    [[[HTServiceManager sharedInstance] questionService] setLoginUser:[[[HTServiceManager sharedInstance] loginService] loginUser]];
    [[[HTServiceManager sharedInstance] questionService] getQuestionInfoWithCallback:^(BOOL success, HTQuestionInfo *questionInfo) {
    
        questionInfo = [HTQuestionHelper questionInfoFake];
        
        if (questionInfo.questionCount <= 0) return;
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [[appDelegate mainController] loadResource];
        [[[HTServiceManager sharedInstance] questionService] getQuestionListWithPage:1 count:questionInfo.questionCount callback:^(BOOL success, NSArray<HTQuestion *> *questionList) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD hide:YES];
                [bgWindow resignKeyWindow];
                [bgWindow removeFromSuperview];
                [[appDelegate window] makeKeyWindow];
            });
            
            questionList = [HTQuestionHelper questionFake];
            
            if (success) {
                _previewView = [[HTPreviewView alloc] initWithFrame:CGRectMake(kLeftMargin, 0, SCREEN_WIDTH - kLeftMargin, SCREEN_HEIGHT) andQuestions:questionList];
                _previewView.delegate = self;
                [_previewView setQuestionInfo:questionInfo];
                [self.view insertSubview:self.previewView atIndex:0];
                
                for (HTPreviewItem *item in _previewView.items) {
                    item.delegate = self;
                }
                
                // 预加载
//                UIWebView *webView1 = [[UIWebView alloc] init];
//                [webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ARTICLE_URL_STRING]]];
//                UIWebView *webView2 = [[UIWebView alloc] init];
//                [webView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ANSWER_URL_STRING]]];
                [[AFHTTPRequestOperationManager manager] HTTPRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ARTICLE_URL_STRING]] success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                    
                } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                    
                }];
            } else {
                // TODO:获取失败
            }
        }];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    __weak typeof(self) weakSelf = self;
    
    self.detector = [SharkfoodMuteSwitchDetector shared];
    self.detector.silentNotify = ^(BOOL silent){
        typeof(self) strongSelf = weakSelf;
        for (HTPreviewItem *item in strongSelf->_previewView.items) {
            [item setSoundButtonHidden:!silent];
        }
    };
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (HTPreviewItem *item in _previewView.items) {
        [item stop];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        for (HTPreviewItem *item in _previewView.items) {
//            [item setSoundButtonHidden:!self.detector.isMute];
//        }
//    });
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
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

#pragma mark - HTARCaptureController Delegate

- (void)didClickBackButtonInARCaptureController:(HTARCaptureController *)controller {
    [controller dismissViewControllerAnimated:NO completion:nil];
    HTRewardController *reward = [[HTRewardController alloc] init];
    reward.view.backgroundColor = [UIColor clearColor];
    if (IOS_VERSION >= 8.0) {
        reward.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [self presentViewController:reward animated:YES completion:nil];
}

#pragma mark - HTPreviewView Delegate

- (void)previewView:(HTPreviewView *)previewView shouldShowGoBackItem:(BOOL)needShow {
    [self.delegate previewController:self shouldShowGoBackItem:needShow];
}

- (void)previewView:(HTPreviewView *)previewView didScrollToItem:(HTPreviewItem *)item {
    Reachability *reach = [Reachability reachabilityForLocalWiFi];
    if ([reach currentReachabilityStatus] != NotReachable) {
        // 开启了wifi
        for (HTPreviewItem *iter in _previewView.items) {
            if (iter != item) {
                [iter stop];
            } else {
                [iter play];
            }
        }
    }
    if (item.breakSuccess) {
        _bgImageView.hidden = NO;
        _bgImageView.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            _bgImageView.alpha = 1.0;
        }];
    } else {
        _bgImageView.hidden = YES;
    }
}

#pragma mark - HTPreviewItem Delegate

- (void)previewItem:(HTPreviewItem *)previewItem didClickButtonWithType:(HTPreviewItemButtonType)type {
    switch (type) {
        case HTPreviewItemButtonTypeCompose: {
            if (previewItem.question.type == 1) {
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
            } else {
                HTARCaptureController *arCaptureController = [[HTARCaptureController alloc] init];
                arCaptureController.delegate = self;
                [self presentViewController:arCaptureController animated:YES completion:nil];
            }
            break;
        }
        case HTPreviewItemButtonTypeContent: {
            _descriptionView = [[HTDescriptionView alloc] initWithURLString:previewItem.question.questionDescription];
            [self.view addSubview:_descriptionView];
            [_descriptionView showAnimated];
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
            HTRewardController *reward = [[HTRewardController alloc] init];
            reward.view.backgroundColor = [UIColor clearColor];
            if (IOS_VERSION >= 8.0) {
                reward.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:reward animated:YES completion:nil];
            break;
        }
        case HTPreviewItemButtonTypeAnswer: {
            if (previewItem.question.type == 2) {
                HTARCaptureController *arCaptureController = [[HTARCaptureController alloc] init];
                arCaptureController.delegate = self;
                arCaptureController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:arCaptureController animated:YES completion:nil];
            } else {
                AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [[appDelegate mainController] showBottomButton:NO];
                _showAnswerView = [[HTShowAnswerView alloc] initWithURL:previewItem.question.detailURL];
                _showAnswerView.alpha = 0.0;
                _showAnswerView.frame = self.view.bounds;
                
                [UIView animateWithDuration:0.3 animations:^{
                    _showAnswerView.alpha = 1.0f;
                    [self.view addSubview:_showAnswerView];
                }];
                break;
            }
        }
        case HTPreviewItemButtonTypePlay: {
            for (HTPreviewItem *item in _previewView.items) {
                if (item != previewItem) {
                    [item stop];
                }
            }
            break;
        }
        case HTPreviewItemButtonTypePause: {
            break;
        }
        case HTPreviewItemButtonTypeSound: {
            break;
        }
        default:
        break;
    }
}

#pragma mark - HTComposeView Delegate

- (void)composeView:(HTComposeView *)composeView didComposeWithAnswer:(NSString *)answer {
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
