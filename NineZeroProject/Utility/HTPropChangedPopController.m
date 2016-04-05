//
//  HTPropChangedPopController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/19.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTPropChangedPopController.h"
#import "HTUIHeader.h"
#import <TTTAttributedLabel.h>

@interface HTPropChangedPopController ()
@property (nonatomic, strong) HTMascotProp *prop;
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *alertBottomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TTTAttributedLabel *messageLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) TTTAttributedLabel *tipLabel;
@property (nonatomic, strong) UIImageView *successImageView;
@property (nonatomic, strong) UILabel *successTipLabel;
@end

@implementation HTPropChangedPopController
- (instancetype)initWithProp:(HTMascotProp *)prop {
    if (self = [super init]) {
        _prop = prop;
        
        _dimmingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 144)];
        _alertView.backgroundColor = [UIColor colorWithHex:0xE1002D];
        _alertView.layer.cornerRadius = 5.0f;
        _alertView.clipsToBounds = YES;
        [_dimmingView addSubview:_alertView];
        
        _alertBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _alertView.width, 43)];
        _alertBottomView.backgroundColor = [UIColor colorWithHex:0xBA0329];
        [_alertView addSubview:_alertBottomView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"兑换玩意儿";
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_alertView addSubview:_titleLabel];
        
        _messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineSpacing = 5.0f;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.text = @"你是否确定要兑换新西兰圣诞空气礼包？";
        [_alertView addSubview:_messageLabel];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(onClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.35] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_alertBottomView addSubview:_cancelButton];
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton addTarget:self action:@selector(onClickSureButton) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_alertBottomView addSubview:_sureButton];
        
        _tipLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.lineSpacing = 8.0f;
        _tipLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _tipLabel.numberOfLines = 0;
        _tipLabel.text = @"在兑换之前，请到个人主页右上角设置填写管理地址，否则我们无法寄出！";
        [_dimmingView addSubview:_tipLabel];
        
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews {
    _alertView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    _alertBottomView.bottom = _alertView.height;
    [_titleLabel sizeToFit];
    _titleLabel.centerX = _alertView.width / 2;
    _titleLabel.top = 20;
    _messageLabel.frame = CGRectMake(30, _titleLabel.bottom + 6, _alertView.width - 60, 50);
    _cancelButton.frame = CGRectMake(0, 0, _alertView.width / 2, _alertBottomView.height);
    _sureButton.frame = CGRectMake(_alertView.width / 2, 0, _alertView.width / 2, _alertBottomView.height);
    _tipLabel.frame = CGRectMake(_alertView.left + 20, _alertView.bottom + 12, _alertView.width - 40, 45);
}

- (void)onClickCancelButton {
    [UIView animateWithDuration:0.3 animations:^{
        _dimmingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_dimmingView removeFromSuperview];
    }];
}

- (void)onClickSureButton {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[[HTServiceManager sharedInstance] mascotService] exchangeProps:_prop completion:^(BOOL success, HTResponsePackage *response) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if (success && response.resultCode == 0) {
            [_alertView removeFromSuperview];
            [_tipLabel removeFromSuperview];
            
            _successImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_props_redeem_success"]];
            _successImageView.top = ROUND_HEIGHT_FLOAT(217);
            _successImageView.centerX = SCREEN_WIDTH / 2;
            [_dimmingView addSubview:_successImageView];
            
            _successTipLabel = [[UILabel alloc] init];
            _successTipLabel.textColor = [UIColor whiteColor];
            _successTipLabel.textAlignment = NSTextAlignmentCenter;
            _successTipLabel.text = @"稍安勿躁，我们会尽快寄出!";
            _successTipLabel.font = [UIFont systemFontOfSize:14];
            [_dimmingView addSubview:_successTipLabel];
            [_successTipLabel sizeToFit];
            _successTipLabel.top = _successImageView.bottom + 13;
            _successTipLabel.centerX = SCREEN_WIDTH / 2;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_dimmingView removeFromSuperview];
            });
            
            [self.delegate onClickSureButtonInPopController:self];
        }
    }];
}

- (void)show {
    [KEY_WINDOW addSubview:_dimmingView];
    _dimmingView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _dimmingView.alpha = 1.0;
    }];
}

@end
