//
//  SKActivityNotificationView.m
//  NineZeroProject
//
//  Created by SinLemon on 16/9/12.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKActivityNotificationView.h"
#import "HTUIHeader.h"

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
    
    UIView *dimmingView = [[UIView alloc] initWithFrame:frame];
    dimmingView.backgroundColor = [UIColor blackColor];
    dimmingView.alpha = 0.8;
    [self addSubview:dimmingView];
    
    _contentImageView = [[UIImageView alloc] init];
    _contentImageView.backgroundColor = [UIColor colorWithHex:0xd8d8d8];
    _contentImageView.layer.cornerRadius = 5;
    _contentImageView.layer.masksToBounds = YES;
    [self addSubview:_contentImageView];
    
    _adButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_adButton];
    
    [_contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(56);
        make.left.equalTo(weakSelf).offset(20);
        make.right.equalTo(weakSelf).offset(-20);
        make.height.mas_equalTo(_contentImageView.mas_width).multipliedBy(1.5);
    }];
    
    [_adButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentImageView);
    }];
    
    UIImageView *handImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_pop_hand"]];
    [handImageView sizeToFit];
    [self addSubview:handImageView];
    
    [handImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_navi_cancel"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_navi_cancel_highlight"] forState:UIControlStateHighlighted];
    
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(_contentImageView.mas_bottom).offset(26);
    }];
}

#pragma mark - Actions

- (void)cancelButtonClick:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, -SCREEN_HEIGHT, self.width, self.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
