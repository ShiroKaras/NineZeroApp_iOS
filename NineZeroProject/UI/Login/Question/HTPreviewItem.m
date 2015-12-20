//
//  HTPreviewItem.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/6.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTPreviewItem.h"
#import "CommonUI.h"
#import <AVFoundation/AVFoundation.h>
#import "HTUIHeader.h"

@interface HTPreviewItem ()

// item上方
@property (weak, nonatomic) IBOutlet UILabel *chapterLabel;    ///< 左上角章节号
@property (weak, nonatomic) IBOutlet UILabel *countDownMainLabel;   ///< 右上角主倒计时
@property (weak, nonatomic) IBOutlet UILabel *countDownDetailLabel; ///< 右上角附属倒计时
@property (weak, nonatomic) IBOutlet UIImageView *countDownImageView;  ///< 主倒计时上方的装饰
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;  ///< 右上角显示结果的装饰

// item中间
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (weak, nonatomic) IBOutlet UIView *playItemBackView;

@property (weak, nonatomic) IBOutlet UIButton *playButton;  ///< 播放按钮
@property (weak, nonatomic) IBOutlet UIButton *soundButton; ///< 音量按钮
@property (weak, nonatomic) IBOutlet UIButton *pauseButton; ///< 暂停按钮

// item下方
@property (weak, nonatomic) IBOutlet UIButton *composeButton;  ///< 发布按钮
@property (weak, nonatomic) IBOutlet UIButton *contenButton;   ///< 内容
@property (weak, nonatomic) IBOutlet UIButton *detailButton;   ///< 获取提示/奖品

@end

@implementation HTPreviewItem

- (void)awakeFromNib {
//    [self play];
     
    [_composeButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playItemDidPlayToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)buildPlayer {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp4"];
    NSURL *vedioUrl = [NSURL URLWithString:[NSString qiniuDownloadURLWithFileName:_question.vedioURL]];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:vedioUrl options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.videoGravity = AVLayerVideoGravityResize;
    [_playItemBackView.layer addSublayer:_playerLayer];

    self.playButton.hidden = NO;
}

- (void)configureQuestion {
    if (_question == nil) return;
    [_contenButton setTitle:_question.content forState:UIControlStateNormal];
    _chapterLabel.text = [NSString stringWithFormat:@"%lu", _question.serial];
}

- (void)setQuestion:(HTQuestion *)question {
    _question = question;
    [self buildPlayer];
    [self configureQuestion];
}

- (void)play {
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_playItemBackView bringSubviewToFront:_playButton];
    [_playItemBackView bringSubviewToFront:_pauseButton];
    [_playItemBackView bringSubviewToFront:_soundButton];
    _playerLayer.frame = _playItemBackView.bounds;
}

#pragma mark - Public Method

- (void)setBreakSuccess:(BOOL)breakSuccess {
    _breakSuccess = breakSuccess;
    _resultImageView.hidden = NO;
    _countDownImageView.hidden = YES;
    _countDownMainLabel.hidden = YES;
    _countDownDetailLabel.hidden = YES;
    [_composeButton setImage:[UIImage imageNamed:@"btn_ans_ans"] forState:UIControlStateNormal];
    [_composeButton setImage:[UIImage imageNamed:@"btn_ans_ans_highlight"] forState:UIControlStateHighlighted];
    _composeButton.tag = 1000;  // 查看答案
    if (breakSuccess) {
        _resultImageView.image = [UIImage imageNamed:@"img_stamp_sucess"];
        _detailButton.hidden = NO;
        [_detailButton setImage:[UIImage imageNamed:@"btn_check_prize"] forState:UIControlStateNormal];
        _detailButton.tag = 1000;  // 查看奖励
    } else {
        _resultImageView.image = [UIImage imageNamed:@"img_stamp_gameover"];
        _detailButton.hidden = YES;
    }
}

- (void)setEndTime:(time_t)endTime {
    _endTime = endTime;
    // 开始倒计时
    DLog(@"结束时间为 = %ld, 当前时间 = %ld", endTime, time(NULL));
    [self scheduleCountDownTimer];
}

#pragma mark - Tool Method

- (void)scheduleCountDownTimer {
    [self performSelector:@selector(scheduleCountDownTimer) withObject:nil afterDelay:1.0];
    time_t delta = _endTime - time(NULL);
    time_t oneHour = 3600;
    time_t hour = delta / oneHour;
    time_t minute = (delta % oneHour) / 60;
    time_t second = delta - hour * oneHour - minute * 60;
    _countDownImageView.hidden = NO;
    _countDownMainLabel.hidden = NO;
    _countDownDetailLabel.hidden = YES;
    _detailButton.hidden = NO;
    [_detailButton setImage:[UIImage imageNamed:@"btn_get_hint"] forState:UIControlStateNormal];
    _detailButton.tag = 0;
    if (delta > oneHour * 48) {
        // 大于48小时
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    } else if (delta > oneHour * 24 && delta < oneHour * 48) {
        // 大于24小时 小于48小时
        _countDownMainLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
        _countDownMainLabel.textColor = [UIColor colorWithHex:0x24ddb2];
        _countDownImageView.image = [UIImage imageNamed:@"img_timer_1_deco"];
    } else if (delta > oneHour * 16 && delta < oneHour * 24) {
        // 大于16小时 小于24小时
        _countDownMainLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
        _countDownMainLabel.textColor = [UIColor colorWithHex:0xed203b];
        _countDownImageView.image = [UIImage imageNamed:@"img_timer_2_deco"];
    } else if (delta > oneHour * 8 && delta < oneHour * 16) {
        // 大于8小时 小于16小时
        _countDownMainLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
        _countDownMainLabel.textColor = [UIColor colorWithHex:0xd40e88];
        _countDownImageView.image = [UIImage imageNamed:@"img_timer_3_deco"];
    } else if (delta > 0 && delta < oneHour * 8) {
        // 小于1小时
        _countDownMainLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", hour, minute];
        _countDownMainLabel.textColor = [UIColor colorWithHex:0xd40e88];
        _countDownImageView.hidden = YES;
        _countDownDetailLabel.hidden = NO;
        _countDownDetailLabel.text = [NSString stringWithFormat:@"%02ld", second];
        _countDownDetailLabel.textColor = [UIColor colorWithHex:0xd40e88];
    } else {
        // 过去时间
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
        [self setBreakSuccess:NO];
    }
}

#pragma mark - Notification

- (void)playItemDidPlayToEndTime {
    _playButton.hidden = NO;
}

#pragma mark - Action

- (IBAction)onClickPlayButton:(UIButton *)sender {
    _playButton.hidden = YES;
    [self play];
}

- (IBAction)onClickSoundButton:(UIButton *)sender {
    
}

- (IBAction)onClickDetailButton:(UIButton *)sender {
    if (sender.tag == 1000) {
        // 查看奖励
        [self.delegate previewItem:self didClickButtonWithType:HTPreviewItemButtonTypeReward];
    } else {
        // 查看提示
        [self.delegate previewItem:self didClickButtonWithType:HTPreviewItemButtonTypeHint];
    }
}

- (IBAction)onClickContentButton:(UIButton *)sender {
    // 内容
    [self.delegate previewItem:self didClickButtonWithType:HTPreviewItemButtonTypeContent];
}

- (IBAction)onClickComposeButton:(UIButton *)sender {
    if (sender.tag == 1000) {
        // 查看答案
        [self.delegate previewItem:self didClickButtonWithType:HTPreviewItemButtonTypeAnswer];
    } else {
        // 答题
        [self.delegate previewItem:self didClickButtonWithType:HTPreviewItemButtonTypeCompose];
    }
}

@end
