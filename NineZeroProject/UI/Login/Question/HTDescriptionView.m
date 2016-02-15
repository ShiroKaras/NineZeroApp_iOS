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
@property (nonatomic, strong) UIButton *exchangeButton;
@property (nonatomic, assign, readwrite) HTDescriptionType type;

@end

@implementation HTDescriptionView

- (instancetype)initWithURLString:(NSString *)urlString andType:(HTDescriptionType)type {
    if (self = [super initWithFrame:CGRectZero]) {
        _type = type;
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickCancelButton)];
        _dimmingView = [[UIView alloc] init];
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [_dimmingView addGestureRecognizer:tap];
        [self addSubview:_dimmingView];
    
        _converView = [[UIView alloc] init];
        _converView.backgroundColor = [UIColor colorWithHex:0x1f1f1f];
        [self addSubview:_converView];
        
        UIImage *converImage = (type == HTDescriptionTypeProp) ? [UIImage imageNamed:@"props_cover"] : [UIImage imageNamed:@"test_imaga"];
        _imageView = [[UIImageView alloc] initWithImage:converImage];
        _imageView.backgroundColor = [UIColor colorWithHex:0x1f1f1f];
        [_converView addSubview:_imageView];
    
        _exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _exchangeButton.layer.cornerRadius = 5.0f;
        _exchangeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_exchangeButton addTarget:self action:@selector(didClickExchangedButton) forControlEvents:UIControlEventTouchUpInside];
        [_converView addSubview:_exchangeButton];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(didClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_popover_close"] forState:UIControlStateNormal];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_popover_close_highlight"] forState:UIControlStateHighlighted];
        [_cancelButton sizeToFit];
        [_cancelButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
        [self addSubview:_cancelButton];
        
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        [_webView loadHTMLString:[NSString stringWithFormat:@"<html><body font-family: '-apple-system','HelveticaNeue'; style=\"line-height:24px; font-size:13px\" text=\"#d9d9d9\" bgcolor=\"#1f1f1f\"><span style=\"font-family: \'-apple-system\',\'HelveticaNeue\';\">这次的开放是内因。来自边缘广州的微信，如新星般冉冉升起。同样实现5亿用户，微信用了4年，而QQ用了十几年。你可以说这是互联网指数级发展的结果，也可以说微信是专为移动而生的产品。所幸，命运依旧青睐QQ，他们把时代的机遇给了微信，但是把年轻人群再次给到了QQ。腾讯即通应用部的总经理张孝超说，使用手机QQ的用户，超过半成以上是90后和00后用户。这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过20这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过20这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过20。</span></body></html>"] baseURL: nil];
        _webView.delegate = self;
        NSString *padding = @"document.body.style.padding='6px 13px 0px 13px';";
        [_webView stringByEvaluatingJavaScriptFromString:padding];
        [_converView addSubview:_webView];
    }
    return self;
}

- (instancetype)initWithURLString:(NSString *)urlString {
    return [self initWithURLString:urlString andType:HTDescriptionTypeQuestion];
}

- (void)didClickCancelButton {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.top = self.height;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)didClickExchangedButton {
    _exchangeButton.backgroundColor = [UIColor colorWithHex:0x545454];
    [_exchangeButton setTitle:@"已兑换" forState:UIControlStateNormal];
    _exchangeButton.enabled = NO;
//    if (_prop) _prop.isExchanged = YES;
//    [self setProp:_prop];
}

- (void)showInView:(UIView *)parentView {
    self.frame = parentView.bounds;
    self.alpha = 0;
    self.top = parentView.bottom;
    _dimmingView.top = -SCREEN_HEIGHT;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _dimmingView.top = 0;
        self.top = 0;
        self.alpha = 1.0;
    } completion:nil];
}

- (void)showAnimated {
    UIView *parentView = [self superview];
    self.frame = parentView.bounds;
    self.alpha = 0;
    self.top = parentView.bottom;
    _dimmingView.top = -SCREEN_HEIGHT;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _dimmingView.top = 0;
        self.top = 0;
        self.alpha = 1.0;
    } completion:nil];
}

- (void)setProp:(HTMascotProp *)prop {
    _prop = prop;
    if (prop && prop.isExchanged) {
        _exchangeButton.backgroundColor = [UIColor colorWithHex:0x545454];
        [_exchangeButton setTitle:@"已兑换" forState:UIControlStateNormal];
        _exchangeButton.enabled = NO;
    } else {
        _exchangeButton.backgroundColor = [UIColor colorWithHex:0x24ddb2];
        [_exchangeButton setTitle:@"兑换" forState:UIControlStateNormal];
        _exchangeButton.enabled = YES;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = 280;
    CGFloat imageHeight = 240;
    CGFloat webViewHeight = 140;
    _dimmingView.frame = self.bounds;
    _converView.frame = CGRectMake(self.width / 2 - width / 2, (80.0 / 568.0) * SCREEN_HEIGHT, width, imageHeight + webViewHeight);
    if (SCREEN_WIDTH > IPHONE5_SCREEN_WIDTH) {
        _converView.centerY = self.centerY - 20;
    }
    _converView.layer.cornerRadius = 5.0f;
    _converView.layer.masksToBounds = YES;
    _imageView.frame = CGRectMake(0, 0, width, imageHeight);
    _exchangeButton.frame = CGRectMake(0, 0, 63, 33);
    _exchangeButton.right = _converView.width - 16;
    _exchangeButton.bottom = imageHeight - 15;
    if (_type == HTDescriptionTypeProp) {
        _webView.frame = CGRectMake(_imageView.left, imageHeight, width, webViewHeight);
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        _webView.frame = CGRectMake(_imageView.left, 0, width, webViewHeight + imageHeight);
        _webView.scrollView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
    }
    _cancelButton.centerX = self.centerX;
    _cancelButton.top = _converView.bottom + 12;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *padding = @"document.body.style.padding='6px 13px 0px 13px';";
    [_webView stringByEvaluatingJavaScriptFromString:padding];
}

@end
