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
@property (nonatomic, strong) SKMascot *mascot;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *timeLabel;
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
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16+64, 45.5, 45.5)];
        icon.image = [UIImage imageNamed:@"img_lingzaipage_imprisontime"];
        [self addSubview:icon];
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_imprisontext"]];
        [self addSubview:titleImageView];
        titleImageView.left = icon.right+4;
        titleImageView.top = icon.top +4;
        
        _timeLabel = [UILabel new];
        _timeLabel.text = @"24:00:00";
        _timeLabel.textColor = COMMON_PINK_COLOR;
        _timeLabel.font = MOON_FONT_OF_SIZE(24);
        [_timeLabel sizeToFit];
        [self addSubview:_timeLabel];
        _timeLabel.left = titleImageView.left;
        _timeLabel.top = titleImageView.bottom+4;
        
//        倒计时
//        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//        long long dTime = [[NSNumber numberWithDouble:time] longLongValue]; // 将double转为long long型
//        NSString *curTime = [NSString stringWithFormat:@"%llu",dTime];      // 输出long long型
//        NSLog(@"Time:%@", curTime);
        _deltaTime = 24*3600;
        [self scheduleCountDownTimer];
    }
    return self;
}

- (void)scheduleCountDownTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    [self performSelector:@selector(scheduleCountDownTimer) withObject:nil afterDelay:1.0];
    _deltaTime--;
    time_t oneHour = 3600;
    time_t hour = _deltaTime / oneHour;
    time_t minute = (_deltaTime % oneHour) / 60;
    time_t second = _deltaTime - hour * oneHour - minute * 60;
    
    //TODO: 更改TimeView
    if (_deltaTime > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,second];
    } else {
        // 过去时间
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    }
}

@end
