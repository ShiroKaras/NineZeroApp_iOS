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
#import "NSDate+Utility.h"
#import "HTPropChangedPopController.h"

@interface HTRewardDescriptionView : UIScrollView
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *deadLine;
@property (nonatomic, strong) UILabel *location;
@property (nonatomic, strong) UILabel *mobile;
@property (nonatomic, strong) UILabel *codeTipLabel;   // “唯一兑换码”
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *careTipLabel;   // “注意事项”
@property (nonatomic, strong) UILabel *careTip1;
@property (nonatomic, strong) UILabel *careTip2;
@property (nonatomic, strong) UILabel *careTip3;
- (void)setReward:(HTReward *)reward;
@end

@implementation HTRewardDescriptionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:19];
        _title.textColor = [UIColor colorWithHex:0xffffff];
        [self addSubview:_title];
        
        _deadLine = [self commonStyleLabel];
        _location = [self commonStyleLabel];
        _mobile = [self commonStyleLabel];
        _codeTipLabel = [self commonStyleLabel];
        
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.font = MOON_FONT_OF_SIZE(30);
        _codeLabel.textColor = COMMON_PINK_COLOR;
        [self addSubview:_codeLabel];
        
        _careTipLabel = [self commonStyleLabel];
        _careTip1 = [self commonStyleLabel];
        _careTip2 = [self commonStyleLabel];
        _careTip3 = [self commonStyleLabel];
    }
    return self;
}

- (void)setReward:(HTReward *)reward {
    _title.text = reward.title;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:reward.expire_time];
    _deadLine.text = [NSString stringWithFormat:@"有效期至%04ld-%02ld-%02ld", [date year], [date month], [date day]];
    _location.text = [NSString stringWithFormat:@"地点：%@", reward.address];
    _mobile.text = [NSString stringWithFormat:@"电话：%@", reward.mobile];
    _codeTipLabel.text = @"唯一兑换码";
    _codeLabel.text = [NSString stringWithFormat:@"%ld", reward.code];
    _careTipLabel.text = @"注意事项：";
    _careTip1.text = @"1.本活动仅限本人；";
    _careTip2.text = @"2.如有疑问，请联系客服；";
    _careTip3.text = @"3.最终解释权归深圳九零九五网络科技";
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftMargin = 23;
    CGFloat labelVerticalMargin = 11;
    _title.frame = CGRectMake(leftMargin, 18, self.width - 2 * leftMargin, 20);
    _deadLine.frame = CGRectMake(leftMargin, _title.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    _location.frame = CGRectMake(leftMargin, _deadLine.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    _mobile.frame = CGRectMake(leftMargin, _location.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    _codeTipLabel.frame = CGRectMake(leftMargin, _mobile.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    _codeLabel.frame = CGRectMake(leftMargin, _codeTipLabel.bottom + 9, self.width - 2 * leftMargin, 30);
    _careTipLabel.frame = CGRectMake(leftMargin, _codeLabel.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    _careTip1.frame = CGRectMake(leftMargin, _careTipLabel.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    _careTip2.frame = CGRectMake(leftMargin, _careTip1.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    _careTip3.frame = CGRectMake(leftMargin, _careTip2.bottom + labelVerticalMargin, self.width - 2 * leftMargin, 13);
    self.contentSize = CGSizeMake(self.width, _careTip3.bottom + labelVerticalMargin);
}

- (UILabel *)commonStyleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHex:0xd9d9d9];
    [self addSubview:label];
    return label;
}

@end

@interface HTDescriptionView () <UIWebViewDelegate, HTPropChangedPopControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *converView;
@property (nonatomic, strong) UIButton *exchangeButton;
@property (nonatomic, strong) HTRewardDescriptionView *rewardDescriptionView;
@property (nonatomic, assign, readwrite) HTDescriptionType type;
@property (nonatomic, strong) HTPropChangedPopController *changeView;
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
        _converView.backgroundColor = COMMON_SEPARATOR_COLOR;
        [self addSubview:_converView];
        
        UIImage *converImage = (type == HTDescriptionTypeProp) ? [UIImage imageNamed:@"props_cover"] : [UIImage imageNamed:@"test_imaga"];
        _imageView = [[UIImageView alloc] initWithImage:converImage];
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
        [self addSubview:_cancelButton];

        if (type == HTDescriptionTypeReward) {
            _rewardDescriptionView = [[HTRewardDescriptionView alloc] initWithFrame:CGRectZero];
            [_rewardDescriptionView setReward:[[HTReward alloc] init]];
            _rewardDescriptionView.backgroundColor = [UIColor colorWithHex:0x1f1f1f];
            [_converView insertSubview:_rewardDescriptionView belowSubview:_imageView];
        } else {
            _webView = [[UIWebView alloc] init];
            _webView.delegate = self;
            _webView.opaque = NO;
            _webView.backgroundColor = [UIColor clearColor];
            _webView.scrollView.backgroundColor = [UIColor clearColor];
            NSString *content = @"这次的开放是内因。来自边缘广州的微信，如新星般冉冉升起。同样实现5亿用户，微信用了4年，而QQ用了十几年。你可以说这是互联网指数级发展的结果，也可以说微信是专为移动而生的产品。所幸，命运依旧青睐QQ，他们把时代的机遇给了微信，但是把年轻人群再次给到了QQ。腾讯即通应用部的总经理张孝超说，使用手机QQ的用户，超过半成以上是90后和00后用户。这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过20这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过20这意味着，QQ与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过20。";
            NSString *htmlString = [NSString stringWithFormat:@"<html><body font-family: '-apple-system','HelveticaNeue'; style=\"line-height:24px; font-size:13px\" text=\"#d9d9d9\" bgcolor=\"#1f1f1f\"><span style=\"font-family: \'-apple-system\',\'HelveticaNeue\';\">%@</span></body></html>", content];
            [_webView loadHTMLString:htmlString baseURL: nil];
            _webView.delegate = self;
            NSString *padding = @"document.body.style.padding='6px 13px 0px 13px';";
            [_webView stringByEvaluatingJavaScriptFromString:padding];
            [_converView addSubview:_webView];
        }
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
    _changeView = [[HTPropChangedPopController alloc] initWithProp:_prop];
    _changeView.delegate = self;
    [_changeView show];
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
    [_webView loadHTMLString:[self htmlStringWithContent:prop.prop_desc] baseURL:nil];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:prop.prop_pic] placeholderImage:[UIImage imageNamed:@"props_cover"]];
    if (prop && prop.used) {
        _exchangeButton.backgroundColor = [UIColor colorWithHex:0x545454];
        [_exchangeButton setTitle:@"已兑换" forState:UIControlStateNormal];
        _exchangeButton.enabled = NO;
    } else {
        _exchangeButton.backgroundColor = COMMON_GREEN_COLOR;
        [_exchangeButton setTitle:@"兑换" forState:UIControlStateNormal];
        _exchangeButton.enabled = YES;
    }
    [self setNeedsLayout];
}

- (void)setReward:(HTReward *)reward {
    [_rewardDescriptionView setReward:reward];
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
    } else if (_type == HTDescriptionTypeReward) {
        self.rewardDescriptionView.frame = CGRectMake(_imageView.left, 0, width, webViewHeight + imageHeight);
        _rewardDescriptionView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
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

#pragma mark - HTPropChangedPopControllerDelegate

- (void)onClickSureButtonInPopController:(HTPropChangedPopController *)controller {
    _exchangeButton.backgroundColor = [UIColor colorWithHex:0x545454];
    [_exchangeButton setTitle:@"已兑换" forState:UIControlStateNormal];
    _exchangeButton.enabled = NO;
    _prop.used = YES;
    [self.delegate descriptionView:self didChangeProp:_prop];
}

- (NSString *)htmlStringWithContent:(NSString *)content {
    NSString *htmlString = [NSString stringWithFormat:@"<html><body font-family: '-apple-system','HelveticaNeue'; style=\"line-height:24px; font-size:13px\" text=\"#d9d9d9\" bgcolor=\"#1f1f1f\"><span style=\"font-family: \'-apple-system\',\'HelveticaNeue\';\">%@</span></body></html>", content];
    return htmlString;
}

@end
