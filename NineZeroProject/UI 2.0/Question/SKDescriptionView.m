//
//  SKDescriptionView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/16.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKDescriptionView.h"
#import "HTUIHeader.h"

@interface SKDescriptionView () <UIWebViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *converView;
@property (nonatomic, strong) UIButton *exchangeButton;
@property (nonatomic, assign, readwrite) SKDescriptionType type;

@end

@implementation SKDescriptionView

- (instancetype)initWithURLString:(NSString *)urlString andType:(SKDescriptionType)type {
    if (self = [super initWithFrame:CGRectZero]) {
        _type = type;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickCancelButton)];
        
        _dimmingView = [[UIView alloc] init];
        _dimmingView.backgroundColor = [UIColor blackColor];
        _dimmingView.alpha = 0.8;
        //        [_dimmingView addGestureRecognizer:tap];
        [self addSubview:_dimmingView];
        
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
        [_backView addGestureRecognizer:tap];
        [self addSubview:_backView];
        
        _converView = [[UIView alloc] init];
        _converView.backgroundColor = COMMON_SEPARATOR_COLOR;
        [_backView addSubview:_converView];
        
        UIImage *coverImage = (type == SKDescriptionTypeProp) ? [UIImage imageNamed:@"props_cover"] : [UIImage imageNamed:@"img_profile_archive_cover_default"];
        _imageView = [[UIImageView alloc] initWithImage:coverImage];
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = COMMON_SEPARATOR_COLOR;
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
        [_backView addSubview:_cancelButton];
        
        if (type == SKDescriptionTypeReward) {
//            _rewardDescriptionView = [[HTTicketDescriptionView alloc] initWithFrame:CGRectZero];
//            [_rewardDescriptionView setReward:[[HTTicket alloc] init]];
//            [_converView addSubview:_rewardDescriptionView];
        } else {
            _webView = [[UIWebView alloc] init];
            _webView.delegate = self;
            _webView.opaque = NO;
            _webView.backgroundColor = [UIColor clearColor];
            _webView.scrollView.backgroundColor = [UIColor clearColor];
            NSString *htmlString = [NSString stringWithFormat:@"<html><body font-family: '-apple-system','HelveticaNeue'; style=\"line-height:24px; font-size:13px\" text=\"#d9d9d9\" bgcolor=\"#1f1f1f\"><span style=\"font-family: \'-apple-system\',\'HelveticaNeue\';\"><div style=\"word-wrap:break-word; width:240px;\">%@</div></span></body></html>", urlString];
            [_webView loadHTMLString:htmlString baseURL: nil];
            _webView.delegate = self;
            NSString *padding = @"document.body.style.padding='6px 13px 0px 13px';";
            [_webView stringByEvaluatingJavaScriptFromString:padding];
            _webView.alpha = 0;
            [_converView addSubview:_webView];
        }
    }
    return self;
}

- (instancetype)initWithURLString:(NSString *)urlString {
    return [self initWithURLString:urlString andType:SKDescriptionTypeQuestion];
}

- (instancetype)initWithURLString:(NSString *)urlString andType:(SKDescriptionType)type andImageUrl:(NSString *)imageUrlString {
    self  = [self initWithURLString:urlString andType:type];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"img_chapter_story_cover_default"]];
    return self;
}

- (void)didClickCancelButton {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _backView.top = _backView.height;
        _dimmingView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)didClickExchangedButton {
//    _changeView = [[HTPropChangedPopController alloc] initWithProp:_prop];
//    _changeView.delegate = self;
//    [_changeView show];
}

- (void)showAnimated {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIView *parentView = [self superview];
    self.frame = parentView.bounds;
    self.alpha = 0;
    self.top = parentView.top;
    _dimmingView.top = 0;
    _backView.top = parentView.bottom;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _dimmingView.alpha = 0.8;
        _backView.top = 0;
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _webView.alpha = 1.;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setReward:(HTTicket *)reward {
//    [_rewardDescriptionView setReward:reward];
//    NSLog(@"%@", reward.ticket_cover);
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:reward.ticket_cover] placeholderImage:[UIImage imageNamed:@"img_chapter_story_cover_default"]];
}

- (void)setBadge:(HTBadge *)badge {
//    [_webView loadHTMLString:[self htmlStringWithContent:badge.medal_description] baseURL:nil];
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:badge.medal_pic] placeholderImage:[UIImage imageNamed:@"img_chapter_story_cover_default"]];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = 280;
    CGFloat imageHeight = 240;
    CGFloat webViewHeight = 140;
    _backView.frame = self.bounds;
    _dimmingView.frame = self.bounds;
    _converView.frame = CGRectMake(self.width / 2 - width / 2, (80.0 / 568.0) * SCREEN_HEIGHT, width, imageHeight + webViewHeight);
    if (SCREEN_WIDTH > IPHONE5_SCREEN_WIDTH) {
        _converView.centerY = _backView.centerY - 20;
    }
    _converView.layer.cornerRadius = 5.0f;
    _converView.layer.masksToBounds = YES;
    _imageView.frame = CGRectMake(0, 0, width, imageHeight);
    _imageView.layer.masksToBounds = YES;
    _exchangeButton.frame = CGRectMake(0, 0, 63, 33);
    _exchangeButton.right = _converView.width - 16;
    _exchangeButton.bottom = imageHeight - 15;
    if (_type == SKDescriptionTypeProp) {
        _webView.frame = CGRectMake(_imageView.left, imageHeight, width, webViewHeight);
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else if (_type == SKDescriptionTypeReward) {
//        self.rewardDescriptionView.frame = CGRectMake(_imageView.left, 0, width, webViewHeight + imageHeight);
//        _rewardDescriptionView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
    } else {
        _webView.frame = CGRectMake(_imageView.left, 0, width, webViewHeight + imageHeight);
        _webView.scrollView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
    }
    _cancelButton.centerX = self.centerX;
    _cancelButton.top = _converView.bottom + 12;
}

#pragma mark - UIWebView Delegate 

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView.isLoading) {
        return;
    }
    NSString *padding = @"document.body.style.padding='6px 13px 0px 13px';";
    [_webView stringByEvaluatingJavaScriptFromString:padding];
}

@end
