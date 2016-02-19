//
//  HTShowAnswerView.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/20.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTShowAnswerView.h"
#import "HTUIHeader.h"
#import "AppDelegate.h"

@interface HTShowAnswerView ()

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
        
        _webView = [[UIWebView alloc] init];
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor colorWithHex:0x1f1f1f];
        _webView.scrollView.backgroundColor = [UIColor colorWithHex:0x1f1f1f];
        _webView.scrollView.contentInset = UIEdgeInsetsMake(61, 0, 0, 0);
//        [_webView loadHTMLString:urlString baseURL:nil];
//        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"article" ofType:@"html"];
//        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
//        NSString *path = [[NSBundle mainBundle] bundlePath];
//        NSURL *baseURL = [NSURL fileURLWithPath:path];
//        [_webView loadHTMLString:htmlString baseURL:baseURL];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ANSWER_URL_STRING]]];
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

- (void)didClickCancelButton {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate mainController] showBottomButton:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.top = self.height;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.webView.frame = self.bounds;
    self.cancelButton.right = self.right - 11;
    self.cancelButton.top = 11;
}

@end
