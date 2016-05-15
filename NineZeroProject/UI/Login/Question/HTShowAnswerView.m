//
//  HTShowAnswerView.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/12/20.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTShowAnswerView.h"
#import "HTUIHeader.h"

@interface HTShowAnswerView () <UIWebViewDelegate>

@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation HTShowAnswerView

- (instancetype)initWithURL:(NSString *)URLString {
    if (self = [super initWithFrame:CGRectZero]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickCancelButton)];
        _dimmingView = [[UIView alloc] init];
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [_dimmingView addGestureRecognizer:tap];
        [self addSubview:_dimmingView];
        
        [HTProgressHUD show];
        _webView = [[UIWebView alloc] init];
        _webView.opaque = NO;
        _webView.backgroundColor = COMMON_SEPARATOR_COLOR;
        _webView.scrollView.backgroundColor = COMMON_SEPARATOR_COLOR;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
        _webView.delegate = self;
        [self addSubview:_webView];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(didClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_fullscreen_close"] forState:UIControlStateNormal];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_fullscreen_close_highlight"] forState:UIControlStateHighlighted];
        [_cancelButton sizeToFit];
        [_cancelButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        [self addSubview:_cancelButton];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.webView.frame = self.bounds;
    self.cancelButton.right = self.right - 11;
    self.cancelButton.top = 11;
}

#pragma mark - Action

- (void)didClickCancelButton {
    [AppDelegateInstance.mainController showBottomButton:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.top = self.height;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [HTProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [HTProgressHUD dismiss];
}



@end
