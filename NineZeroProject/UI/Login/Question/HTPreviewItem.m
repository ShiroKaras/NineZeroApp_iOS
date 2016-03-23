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
#import <MediaPlayer/MPMusicPlayerController.h>
#import "SharkfoodMuteSwitchDetector.h"

@interface HTPreviewItem ()

// item上方
@property (weak, nonatomic) IBOutlet UILabel *chapterLabel;    ///< 左上角章节号
@property (weak, nonatomic) IBOutlet UILabel *countDownMainLabel;   ///< 右上角主倒计时
@property (weak, nonatomic) IBOutlet UILabel *countDownDetailLabel; ///< 右上角附属倒计时
@property (weak, nonatomic) IBOutlet UIImageView *countDownImageView;  ///< 主倒计时上方的装饰
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;  ///< 右上角显示结果的装饰
@property (weak, nonatomic) IBOutlet UIView *playerContainView;

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
    [self buildConstraints];
    _playerContainView.layer.cornerRadius = 5.0f;
    _playerContainView.layer.masksToBounds = YES;
    
    // 播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    // 监听音量
//    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
//    [audioSession setActive:YES error:nil];
//    [audioSession addObserver:self
//                    forKeyPath:@"outputVolume"
//                       options:0
//                       context:nil];
}

- (void)buildPlayer {
    if ([_question.videoName isEqualToString:@""] == YES) {
        _question.videoName = @"sample";
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:_question.videoName ofType:@"mp4"];
    NSURL *localUrl = [NSURL fileURLWithPath:path];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.videoGravity = AVLayerVideoGravityResize;
    [_playItemBackView.layer addSublayer:_playerLayer];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPlayItemBackView)];
    [_playItemBackView addGestureRecognizer:tap];
    
    self.playButton.hidden = NO;
    self.soundButton.hidden = ![[SharkfoodMuteSwitchDetector shared] isMute];
    self.pauseButton.hidden = YES;
}

- (void)configureQuestion {
    if (_question == nil) return;
    [_contenButton setTitle:_question.content forState:UIControlStateNormal];
    _chapterLabel.text = [NSString stringWithFormat:@"%02lu", _question.serial];
}

- (void)setQuestion:(HTQuestion *)question {
    _question = question;
    [self buildPlayer];
    [self configureQuestion];
    [self setNeedsDisplay];
    [self setNeedsUpdateConstraints];
}

- (void)play {
//    [_playerItem seekToTime:kCMTimeZero];
    _playButton.hidden = YES;
    _pauseButton.hidden = YES;
    [_player play];
}

- (void)stop {
    _playButton.hidden = NO;
    [_playerItem seekToTime:kCMTimeZero];
    [_player setRate:0];
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player pause];
}

- (void)pause {
    _playButton.hidden = NO;
    _pauseButton.hidden = NO;
    [_player pause];
}

- (void)buildConstraints {
    // 重新给两个货补上高度约
    [_contenButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(80));
    }];
//
//    [_playItemBackView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(_playItemBackView.mas_width);
//    }];
//    
//    [_playerContainView mas_updateConstraints:^(MASConstraintMaker *make) {
//        CGFloat height = _contenButton.height + _playItemBackView.height;
//        make.height.equalTo(@(height));
//    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
        _contenButton.height = 80;
        _playerContainView.height = _contenButton.height + _playItemBackView.height;
        
        // 加入队列，保证布局
        [_playItemBackView bringSubviewToFront:_playButton];
        [_playItemBackView bringSubviewToFront:_pauseButton];
        [_playItemBackView bringSubviewToFront:_soundButton];
        _playerLayer.frame = _playItemBackView.bounds;
    });
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

- (CGRect)hintRect {
    return self.detailButton.frame;
}

- (void)setSoundButtonHidden:(BOOL)hidden {
    self.soundButton.hidden = hidden;
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
        _countDownMainLabel.textColor = COMMON_GREEN_COLOR;
        _countDownImageView.image = [UIImage imageNamed:@"img_timer_1_deco"];
    } else if (delta > oneHour * 16 && delta < oneHour * 24) {
        // 大于16小时 小于24小时
        _countDownMainLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
        _countDownMainLabel.textColor = [UIColor colorWithHex:0xed203b];
        _countDownImageView.image = [UIImage imageNamed:@"img_timer_2_deco"];
    } else if (delta > oneHour * 8 && delta < oneHour * 16) {
        // 大于8小时 小于16小时
        _countDownMainLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
        _countDownMainLabel.textColor = COMMON_PINK_COLOR;
        _countDownImageView.image = [UIImage imageNamed:@"img_timer_3_deco"];
    } else if (delta > 0 && delta < oneHour * 8) {
        // 小于1小时
        _countDownMainLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", hour, minute];
        _countDownMainLabel.textColor = COMMON_PINK_COLOR;
        _countDownImageView.hidden = YES;
        _countDownDetailLabel.hidden = NO;
        _countDownDetailLabel.text = [NSString stringWithFormat:@"%02ld", second];
        _countDownDetailLabel.textColor = COMMON_PINK_COLOR;
    } else {
        // 过去时间
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
        [self setBreakSuccess:NO];
    }
}

#pragma mark - Notification

- (void)playItemDidPlayToEndTime:(NSNotification *)notification {
    if ([notification.object isEqual:self.playerItem]) {
        _playButton.hidden = NO;
        [_player seekToTime:kCMTimeZero];
    }
}

#pragma mark - Action

- (IBAction)onClickPlayButton:(UIButton *)sender {
    [self play];
    [self.delegate previewItem:self didClickButtonWithType:HTPreviewItemButtonTypePlay];
}

- (IBAction)onClickSoundButton:(UIButton *)sender {
    [self.delegate previewItem:self didClickButtonWithType:HTPreviewItemButtonTypeSound];
}

- (IBAction)onClickPauseButton:(UIButton *)sender {
    [self pause];
    [self.delegate previewItem:self didClickButtonWithType:HTPreviewItemButtonTypePause];
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
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if ([keyPath isEqual:@"outputVolume"]) {
//         self.soundButton.hidden = ([[AVAudioSession sharedInstance] outputVolume] != 0);
//    }
//}

- (void)didTapPlayItemBackView {
    [self pause];
}

@end
