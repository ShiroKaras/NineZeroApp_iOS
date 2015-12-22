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
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_imaga"]];
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
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        [_webView loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#d9d9d9\" bgcolor=\"#1f1f1f\" size=\"13\">这次的开放是内因。来自边缘广州的微信，如新星般冉冉升起。同样实现5亿用户，微信用了4年，而QQ用了十几年。你可以说这是互联网指数级发展的结果，也可以说微信是专为移动而生的产品。所幸，命运依旧青睐QQ，他们把时代的机遇给了微信，但是把年轻人群再次给到了QQ。腾讯即通应用部的总经理张孝超说，使用手机QQ的用户，超过半成以上是90后和00后用户。这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过20这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过20这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过20。</body></html>"] baseURL: nil];
        _webView.delegate = self;
        [_converView addSubview:_webView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *padding = @"document.body.style.padding='6px 10px 0px 10px';";
            [_webView stringByEvaluatingJavaScriptFromString:padding];
        });
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
