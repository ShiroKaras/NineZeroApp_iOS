//
//  SKCardTimeView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/16.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKCardTimeView.h"
#import "HTUIHeader.h"

@interface SKCardTimeView()

@property (strong, nonatomic) IBOutlet UILabel *mainTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *decoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *resultImageView;
//@property (nonatomic, strong) SKHelperGuideView *guideView;
@property (nonatomic, assign) time_t endTime;
@property (nonatomic, strong) SKQuestion *question;

@end

@implementation SKCardTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *containerView = [[[UINib nibWithNibName:@"SKCardTimeView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        containerView.frame = self.bounds;
        [self addSubview:containerView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setQuestion:(SKQuestion *)question type:(SKQuestionType)type endTime:(time_t)endTime {
    _question = question;
    _endTime = endTime;
    if (type == SKQuestionTypeTimeLimitLevel) {
        if (question.is_answer == NO) {
            [self scheduleCountDownTimer];
        } else {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
            _decoImageView.hidden = YES;
            _mainTimeLabel.hidden = YES;
            _detailTimeLabel.hidden = YES;
            _resultImageView.hidden = NO;
            _resultImageView.contentMode = UIViewContentModeScaleAspectFit;
            if (question.is_answer) {
                [_resultImageView setImage:[UIImage imageNamed:@"img_stamp_sucess"]];
            } else {
                [_resultImageView setImage:[UIImage imageNamed:@"img_stamp_gameover"]];
            }
        }
    } else if (type == SKQuestionTypeHistoryLevel) {
        _decoImageView.hidden = YES;
        _mainTimeLabel.hidden = YES;
        _detailTimeLabel.hidden = YES;
        _resultImageView.hidden = NO;
        if (question.is_answer) {
            [_resultImageView setImage:[UIImage imageNamed:@"img_stamp_sucess"]];
        } else {
            if (question.base_type == 1 || _question.base_type == 2) {
                [_resultImageView setImage:[UIImage imageNamed:@"img_stamp_AR"]];
            } else {
                _resultImageView.hidden = YES;
            }
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
    
    //TODO: 更改TimeView
    if (delta > 0) {
        if (delta < oneHour * 36 && FIRST_TYPE_2) {
//            [self showGuideviewWithType:SKHelperGuideViewType2];
            [UD setBool:YES forKey:@"firstLaunchType2"];
        }
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
