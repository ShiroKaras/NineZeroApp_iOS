//
//  HTDescriptionView.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/19.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTDescriptionView.h"
#import <Masonry.h>
#import "UIButton+EnlargeTouchArea.h"
#import "HTUIHeader.h"
@interface HTDescriptionView () <UIWebViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *converView;

@end

@implementation HTDescriptionView

- (instancetype)initWithURLString:(NSString *)urlString {
    if (self = [super initWithFrame:CGRectZero]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickCancelButton)];
        _dimmingView = [[UIView alloc] init];
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [_dimmingView addGestureRecognizer:tap];
        [self addSubview:_dimmingView];
    
        _converView = [[UIView alloc] init];
        _converView.backgroundColor = [UIColor colorWithHex:0x1f1f1f];
        [self addSubview:_converView];
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ex_image"]];
        _imageView.backgroundColor = [UIColor colorWithHex:0x1f1f1f];
        [_converView addSubview:_imageView];
    
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(didClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_navi_cancel"] forState:UIControlStateNormal];
        [_cancelButton sizeToFit];
        [_cancelButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        [self addSubview:_cancelButton];
        
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.opaque = NO;
//        _webView.backgroundColor = [UIColor colorWithHex:0x1f1f1f];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.backgroundColor = [UIColor clearColor];
//        [_webView loadHTMLString:urlString baseURL:nil];
        [_webView loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#d9d9d9\" size=\"13\">%@</body></html>", urlString] baseURL: nil];
        [_converView addSubview:_webView];
    }
    return self;
}

- (void)didClickCancelButton {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.top = self.height;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = 280;
    CGFloat imageHeight = 240;
    CGFloat webViewHeight = 140;
    _dimmingView.frame = self.bounds;
    _converView.frame = CGRectMake(self.width / 2 - width / 2, (80.0 / 568.0) * SCREEN_HEIGHT, width, imageHeight + webViewHeight);
    _converView.layer.cornerRadius = 5.0f;
    _converView.layer.masksToBounds = YES;
    _imageView.frame = CGRectMake(0, 0, width, imageHeight);
    _webView.frame = CGRectMake(_imageView.left, 0, width, webViewHeight + imageHeight);
    _webView.scrollView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
    _cancelButton.centerX = self.centerX;
    _cancelButton.top = _converView.bottom + 16;
}

@end
