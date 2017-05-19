//
//  NZAdView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/19.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZAdView.h"
#import "HTUIHeader.h"

@interface NZAdView ()
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIImageView *nextArrow;
@property (nonatomic, strong) UILabel *nextLabel;
@property (nonatomic, strong) UILabel *countDownLabel;
@end

@implementation NZAdView {
    int _secondsToCountDown;
}

- (instancetype)initWithFrame:(CGRect)frame image:(NSURL*)imageURL
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COMMON_BG_COLOR;
        
        UIImageView *adPic = [[UIImageView alloc] initWithFrame:frame];
        [adPic sd_setImageWithURL:imageURL];
        [self addSubview:adPic];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAd)];
        [adPic addGestureRecognizer:tap];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-55, frame.size.width, 55)];
        bottomView.backgroundColor = COMMON_BG_COLOR;
        bottomView.alpha = 0.75;
        [self addSubview:bottomView];
        
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_adpage_logo"]];
        [self addSubview:logoImageView];
        logoImageView.centerY = bottomView.centerY;
        logoImageView.left = 16;
        
        _nextArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_settingpage_next"]];
        [self addSubview:_nextArrow];
        _nextArrow.right = bottomView.right -16;
        _nextArrow.centerY = bottomView.centerY;
        
        _nextLabel = [UILabel new];
        _nextLabel.text = @"跳过";
        _nextLabel.textColor = [UIColor whiteColor];
        _nextLabel.font = PINGFANG_FONT_OF_SIZE(12);
        [_nextLabel sizeToFit];
        [self addSubview:_nextLabel];
        _nextLabel.right = _nextArrow.left;
        _nextLabel.centerY = bottomView.centerY;
        
        _nextButton = [UIButton new];
        [_nextButton addTarget:self action:@selector(didClickNextButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextButton];
        _nextButton.width = _nextLabel.width+22;
        _nextButton.height = 22;
        _nextButton.right = bottomView.right -16;
        _nextButton.centerY = bottomView.centerY;
        
        _countDownLabel = [UILabel new];
        _countDownLabel.text = @"3秒";
        _countDownLabel.textColor = [UIColor whiteColor];
        _countDownLabel.font = PINGFANG_FONT_OF_SIZE(12);
        [_countDownLabel sizeToFit];
        [self addSubview:_countDownLabel];
        _countDownLabel.right = _nextLabel.left-8;
        _countDownLabel.centerY = bottomView.centerY;
        
        _secondsToCountDown = 3;
        [self scheduleTimerCountDown];
    }
    return self;
}

- (void)didClickNextButton:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)onClickAd {
    
}

- (void)scheduleTimerCountDown {
    [self performSelector:@selector(scheduleTimerCountDown) withObject:nil afterDelay:1.0];
    _secondsToCountDown--;
    if (_secondsToCountDown == 0) {
        [self didClickNextButton:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleTimerCountDown) object:nil];
    } else {
        [UIView setAnimationsEnabled:NO];
        _countDownLabel.text = [NSString stringWithFormat:@"%d秒", _secondsToCountDown];
        [UIView setAnimationsEnabled:YES];
    }
}

@end
