//
//  NZMascotView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/17.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZMascotView.h"
#import "HTUIHeader.h"

@interface NZMascotView ()
@property (nonatomic, strong) UIView *countDownBackView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *mascotDefaultImageView;
@property (nonatomic, strong) UIImageView *mascotGifImageView;
@property (nonatomic, assign) int currentFrameCount;
@end

@implementation NZMascotView

- (instancetype)initWithFrame:(CGRect)frame withMascot:(SKMascot*)mascot {
    self = [super initWithFrame:frame];
    if (self) {
        _mascot = mascot;
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.layer.masksToBounds = YES;
        _backgroundImageView.image = [UIImage imageNamed:@"img_lingzaipage_bg"];
        [self addSubview:_backgroundImageView];
        
        _mascotDefaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.width, self.height-64)];
        _mascotDefaultImageView.layer.masksToBounds = YES;
        _mascotDefaultImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mascotDefaultImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_lingzaipage_%ld_default", [_mascot.pet_id integerValue]-1]];
        [self addSubview:_mascotDefaultImageView];
        
        _mascotGifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.width, self.height-64)];
        _mascotGifImageView.layer.masksToBounds = YES;
        _mascotGifImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mascotGifImageView.userInteractionEnabled = YES;
        NSString *imageName = [NSString stringWithFormat:@"png_%@gif_00000.png", _mascot.pet_name];
        _mascotGifImageView.image = ImageWithPath(imageName);
        [self addSubview:_mascotGifImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMascot)];
        tap.numberOfTapsRequired = 1;
        [_mascotGifImageView addGestureRecognizer:tap];

        _countDownBackView = [[UIView alloc] initWithFrame:CGRectMake(16, 16+64, 150, 50)];
        _countDownBackView.backgroundColor = [UIColor clearColor];
        [self addSubview:_countDownBackView];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45.5, 45.5)];
        icon.image = [UIImage imageNamed:@"img_lingzaipage_imprisontime"];
        [_countDownBackView addSubview:icon];
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_imprisontext"]];
        [_countDownBackView addSubview:titleImageView];
        titleImageView.left = icon.right+4;
        titleImageView.top = icon.top +4;
        
        //倒计时
        _timeLabel = [UILabel new];
        _timeLabel.text = @"24:00:00";
        _timeLabel.textColor = COMMON_PINK_COLOR;
        _timeLabel.font = MOON_FONT_OF_SIZE(24);
        [_timeLabel sizeToFit];
        [_countDownBackView addSubview:_timeLabel];
        _timeLabel.left = titleImageView.left;
        _timeLabel.top = titleImageView.bottom+4;

        [self scheduleCountDownTimer];
    }
    return self;
}

- (void)tapMascot {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearAinimationImageMemory) object:nil];
    NSMutableArray *_imageArray = [NSMutableArray array];
    NSArray *imageCount = @[@50,@59,@64,@64,@53,@60,@45];
    _currentFrameCount = [imageCount[[_mascot.pet_id intValue]-1] intValue];
    for (int i=0; i<_currentFrameCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"png_%@gif_%05d.png", _mascot.pet_name, i];
        UIImage *image = ImageWithPath(imageName);
        [_imageArray addObject:image];
    }
    _mascotGifImageView.animationImages = _imageArray;
    _mascotGifImageView.animationDuration = 0.033*_currentFrameCount;
    _mascotGifImageView.animationRepeatCount = 1;
    [_mascotGifImageView startAnimating];
    [self performSelector:@selector(clearAinimationImageMemory) withObject:nil afterDelay:0.033*_currentFrameCount+1];
}

// 清除animationImages所占用内存
- (void)clearAinimationImageMemory {
    [self.mascotGifImageView stopAnimating];
    self.mascotGifImageView.animationImages = nil;
    NSString *imageName = [NSString stringWithFormat:@"png_%@gif_00000.png", _mascot.pet_name];
    _mascotGifImageView.image = ImageWithPath(imageName);
}

- (void)scheduleCountDownTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    [self performSelector:@selector(scheduleCountDownTimer) withObject:nil afterDelay:1.0];
    _deltaTime--;
    time_t oneHour = 3600;
    time_t hour = _deltaTime / oneHour;
    time_t minute = (_deltaTime % oneHour) / 60;
    time_t second = _deltaTime - hour * oneHour - minute * 60;
    
    _mascotDefaultImageView.hidden = _deltaTime>0?YES:NO;
    _mascotGifImageView.hidden = [_mascot.pet_id integerValue]==1?NO:(_deltaTime>0?NO:YES);
    _countDownBackView.hidden = _deltaTime>0?NO:YES;
    //TODO: 更改TimeView
    if (_deltaTime > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,second];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
        _timeLabel.text = [NSString stringWithFormat:@"00:00:00"];
    }
}

- (void)setDeltaTime:(time_t)deltaTime {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    _deltaTime = deltaTime;
    [self scheduleCountDownTimer];
}

#pragma mark - Mascot

- (void)setMascot:(SKMascot *)mascot {
    _mascot = mascot;
    if ([mascot.last_coop_time integerValue]>0) {
        _mascotDefaultImageView.hidden = YES;
    } else {
        _mascotDefaultImageView.hidden = NO;
    }
}

@end
