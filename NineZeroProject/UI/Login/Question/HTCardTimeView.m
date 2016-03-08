//
//  HTCardTimeView.m
//  NineZeroProject
//
//  Created by ronhu on 16/3/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTCardTimeView.h"
#import "HTUIHeader.h"

@interface HTCardTimeView ()
@property (weak, nonatomic) IBOutlet UILabel *mainTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *decoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (nonatomic, assign) time_t endTime;
@property (nonatomic, strong) HTQuestionInfo *questionInfo;
@property (nonatomic, strong) HTQuestion *question;
@end

@implementation HTCardTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *containerView = [[[UINib nibWithNibName:@"HTCardTimeView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        containerView.frame = self.bounds;
        [self addSubview:containerView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}

- (void)setQuestion:(HTQuestion *)question andQuestionInfo:(HTQuestionInfo *)questionInfo {
    _questionInfo = questionInfo;
    _question = question;
    _endTime = questionInfo.endTime;
    if (_question.questionID == _questionInfo.questionID) {
        [self scheduleCountDownTimer];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
        _decoImageView.hidden = YES;
        _mainTimeLabel.hidden = YES;
        _detailTimeLabel.hidden = YES;
        _resultImageView.hidden = NO;
        if (question.isPassed) {
            [_resultImageView setImage:[UIImage imageNamed:@"img_stamp_sucess"]];
        } else {
            [_resultImageView setImage:[UIImage imageNamed:@"img_stamp_gameover"]];
        }
    }
}

- (void)scheduleCountDownTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    [self performSelector:@selector(scheduleCountDownTimer) withObject:nil afterDelay:1.0];
    time_t delta = _endTime - time(NULL);
    time_t oneHour = 3600;
    time_t hour = delta / oneHour;
    time_t minute = (delta % oneHour) / 60;
    time_t second = delta - hour * oneHour - minute * 60;
    _decoImageView.hidden = NO;
    _mainTimeLabel.hidden = NO;
    _detailTimeLabel.hidden = YES;
    _resultImageView.hidden = YES;
    if (delta > oneHour * 48) {
        // 大于48小时
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    } else if (delta > oneHour * 24 && delta < oneHour * 48) {
        // 大于24小时 小于48小时
        _mainTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
        _mainTimeLabel.textColor = [UIColor colorWithHex:0x24ddb2];
        _decoImageView.image = [UIImage imageNamed:@"img_timer_1_deco"];
    } else if (delta > oneHour * 16 && delta < oneHour * 24) {
        // 大于16小时 小于24小时
        _mainTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
        _mainTimeLabel.textColor = [UIColor colorWithHex:0xed203b];
        _decoImageView.image = [UIImage imageNamed:@"img_timer_2_deco"];
    } else if (delta > oneHour * 8 && delta < oneHour * 16) {
        // 大于8小时 小于16小时
        _mainTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
        _mainTimeLabel.textColor = COMMON_PINK_COLOR;
        _decoImageView.image = [UIImage imageNamed:@"img_timer_3_deco"];
    } else if (delta > 0 && delta < oneHour * 8) {
        // 小于1小时
        _mainTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", hour, minute];
        _mainTimeLabel.textColor = COMMON_PINK_COLOR;
        _decoImageView.hidden = YES;
        _detailTimeLabel.hidden = NO;
        _detailTimeLabel.text = [NSString stringWithFormat:@"%02ld", second];
        _detailTimeLabel.textColor = COMMON_PINK_COLOR;
    } else {
        // 过去时间
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    }
}


@end
