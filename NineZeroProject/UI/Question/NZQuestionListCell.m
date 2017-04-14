//
//  NZQuestionListCell.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/30.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZQuestionListCell.h"
#import "HTUIHeader.h"

@interface NZQuestionListCell()
@property (nonatomic, strong) SKQuestion *question;
@property (nonatomic, strong) UIImageView *questionCoverImageView;
@property (nonatomic, strong) UIImageView *timeLabelImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) time_t deltaTime;
@end

@implementation NZQuestionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COMMON_BG_COLOR;
        
        _questionCoverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_monday_music_cover_default"]];
        _questionCoverImageView.layer.masksToBounds = YES;
        _questionCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_questionCoverImageView];
        [_questionCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(@16);
            make.right.equalTo(self).offset(-16);
            make.height.mas_equalTo((self.width-32)/288*162);
        }];

        _timeLabelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzlepage_timelabel"]];
        [self.contentView addSubview:_timeLabelImageView];
        [_timeLabelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_questionCoverImageView.mas_top).offset(6);
            make.right.equalTo(_questionCoverImageView.mas_right).offset(6);
        }];
        
        _timeLabel = [UILabel new];
        _timeLabel.text = @"00:00:00";
        _timeLabel.textColor = COMMON_PINK_COLOR;
        _timeLabel.font = MOON_FONT_OF_SIZE(18);
        [_timeLabel sizeToFit];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_timeLabelImageView);
            make.centerY.equalTo(_timeLabelImageView);
        }];
        
        [self layoutIfNeeded];
        self.cellHeight = _questionCoverImageView.bottom+20;
    }
    return self;
}

- (void)setCellWithQuetion:(SKQuestion *)question {
    _question = question;
    if (question.limit_time_type==1) {
        _timeLabel.hidden = NO;
        _deltaTime = [question.count_down longLongValue];
        [self scheduleCountDownTimer];
    } else {
        _timeLabel.hidden = YES;
        //往期关卡
        if (question.is_answer) {
            _timeLabelImageView.image = [UIImage imageNamed:@"img_puzzlepage_successlabel"];
        } else {
            if (question.base_type) {
                _timeLabelImageView.image = [UIImage imageNamed:@"img_puzzlepage_offlinelabel"];
            } else {
                _timeLabelImageView.hidden = YES;
            }
        }
    }
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
        _timeLabel.text = [NSString stringWithFormat:@"%2ld:%2ld:%2ld",hour,minute,second];
    } else {
        // 过去时间
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    }
}

@end
