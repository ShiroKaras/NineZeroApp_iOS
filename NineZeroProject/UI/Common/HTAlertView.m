//
//  HTAlertView.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/27.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTAlertView.h"
#import "HTUIHeader.h"
#import <TTTAttributedLabel.h>

@interface HTAlertView ()
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *alertBottomView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) TTTAttributedLabel *messageLabel;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, assign) HTAlertViewType type;
@end

@implementation HTAlertView

- (instancetype)initWithType:(HTAlertViewType)type {
    if (self = [super initWithFrame:SCREEN_BOUNDS]) {
        _type = type;
    
        _dimmingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        [self addSubview:_dimmingView];
        
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 179)];
        _alertView.backgroundColor = [UIColor colorWithHex:0xE1002D];
        _alertView.layer.cornerRadius = 5.0f;
        _alertView.clipsToBounds = YES;
        [_dimmingView addSubview:_alertView];
        
        _alertBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _alertView.width, 43)];
        _alertBottomView.backgroundColor = [UIColor colorWithHex:0xBA0329];
        [_alertView addSubview:_alertBottomView];
        
        UIImage *image;
        if (type == HTAlertViewTypeLocation) {
            image = [UIImage imageNamed:@"img_ask_permission_location"];
        } else {
            image = [UIImage imageNamed:@"img_ask_permission_notification"];
        }
        _titleImageView = [[UIImageView alloc] initWithImage:image];
        [_alertView addSubview:_titleImageView];

        _messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineSpacing = 5.0f;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _messageLabel.font = [UIFont systemFontOfSize:14];
        
        NSString *messageText;
        if (type == HTAlertViewTypeLocation) {
            messageText = @"九零需要访问您的地理位置，要不然零仔怎么找到你？";
        } else if (type == HTAlertViewTypePush){
            messageText = @"九零需要你允许我们推送相关通知，我们会悄悄把线索塞给你，嘘！";
        }else if (type == HTAlertViewTypePhotoLibrary){
            messageText = @"拜托你快去“设置—隐私—相机”的选项中，让我们找到你。";
        }else {
            
        }
        _messageLabel.text = messageText;
        [_alertView addSubview:_messageLabel];
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton addTarget:self action:@selector(onClickSureButton) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_alertBottomView addSubview:_sureButton];
    }
    return self;
}

- (void)show {
    [KEY_WINDOW addSubview:self];
    _dimmingView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _dimmingView.alpha = 1.0;
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _alertView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    _alertBottomView.bottom = _alertView.height;
    if (_type == HTAlertViewTypeLocation) {
        _titleImageView.top = 13;
        _titleImageView.centerX = _alertView.width / 2;
        _messageLabel.frame = CGRectMake(30, _titleImageView.bottom + 6, _alertView.width - 60, 50);
    } else {
        _titleImageView.top = 16;
        _titleImageView.centerX = _alertView.width / 2;
        _messageLabel.frame = CGRectMake(30, _titleImageView.bottom + 6, _alertView.width - 60, 50);
    }
    _sureButton.frame = CGRectMake(0, 0, _alertView.width, _alertBottomView.height);
}

- (void)onClickSureButton {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
