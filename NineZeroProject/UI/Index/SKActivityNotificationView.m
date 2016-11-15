//
//  SKActivityNotificationView.m
//  NineZeroProject
//
//  Created by SinLemon on 16/9/12.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKActivityNotificationView.h"
#import "HTUIHeader.h"

@interface SKActivityNotificationView ()
@property (nonatomic, strong) UIImageView *handImageView;
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *backView;
@end

@implementation SKActivityNotificationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViewWithFrame:frame];
    }
    return self;
}

- (void)createViewWithFrame:(CGRect)frame {
    
    __weak __typeof(self)weakSelf = self;
    
    _dimmingView = [[UIView alloc] initWithFrame:frame];
    _dimmingView.backgroundColor = [UIColor blackColor];
    _dimmingView.alpha = 0;
    [self addSubview:_dimmingView];
    
    _backView = [[UIView alloc] initWithFrame:frame];
    _backView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backView];
    
    _contentImageView = [[UIImageView alloc] init];
    _contentImageView.backgroundColor = [UIColor blackColor];
    _contentImageView.layer.cornerRadius = 5;
    _contentImageView.layer.masksToBounds = YES;
    [_backView addSubview:_contentImageView];
    
    _adButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backView addSubview:_adButton];
    
    _contentImageView.frame = CGRectMake(20, 56, SCREEN_WIDTH-40, (SCREEN_WIDTH-40)*1.5);
    
    _adButton.frame = _contentImageView.frame;
    
    _handImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_pop_hand"]];
    [_handImageView sizeToFit];
    [_backView addSubview:_handImageView];
    
    _handImageView.top = 0;
    _handImageView.centerX = self.centerX;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_navi_cancel"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_navi_cancel_highlight"] forState:UIControlStateHighlighted];
    
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(_contentImageView.mas_bottom).offset(26);
    }];
}

#pragma mark - Actions

- (void)cancelButtonClick:(UIButton *)sender {
    [UIView animateWithDuration:0.6 animations:^{
        _backView.bottom = 0;
        _dimmingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show {
    _backView.bottom = 0;
    [UIView animateWithDuration:0.6 animations:^{
        _backView.bottom = SCREEN_HEIGHT;
        _dimmingView.alpha = 0.8;
    } completion:^(BOOL finished) {
        
    }];
}

@end
