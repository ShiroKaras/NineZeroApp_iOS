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

// item中间
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (weak, nonatomic) IBOutlet UIView *playItemBackView;

@property (weak, nonatomic) IBOutlet UIButton *playButton; ///< 播放按钮
@property (weak, nonatomic) IBOutlet UIButton *soundButton; ///< 音量按钮
@property (weak, nonatomic) IBOutlet UIButton *pauseButton; ///< 暂停按钮

// item下方
@property (weak, nonatomic) IBOutlet UIButton *composeButton;  ///< 发布按钮
@property (weak, nonatomic) IBOutlet UIButton *contenButton;   ///< 内容

@end

@implementation HTPreviewItem

- (void)awakeFromNib {
    [self buildPlayer];
    [self play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playItemDidPlayToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)buildPlayer {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp4"];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.videoGravity = AVLayerVideoGravityResize;
    [_playItemBackView.layer addSublayer:_playerLayer];
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

- (IBAction)onClickContentButton:(UIButton *)sender {
}

- (IBAction)onClickComposeButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(previewItem:didClickComposeButton:)]) {
        [self.delegate previewItem:self didClickComposeButton:sender];
    }
}


@end
