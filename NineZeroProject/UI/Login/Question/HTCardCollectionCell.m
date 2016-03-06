//
//  HTCardCollectionCell.m
//  NineZeroProject
//
//  Created by ronhu on 16/3/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTCardCollectionCell.h"
#import <AVFoundation/AVFoundation.h>
#import "HTUIHeader.h"
#import "SharkfoodMuteSwitchDetector.h"

@interface HTCardCollectionCell ()
@property (nonatomic, strong) UIView *cardBackView;
@property (nonatomic, strong) UIView *playBackView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIImageView *soundImageView;
@property (nonatomic, strong) UIImageView *pauseImageView;
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *composeButton;

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@end

@implementation HTCardCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 1. 背景
        _cardBackView = [[UIView alloc] initWithFrame:CGRectZero];
        _cardBackView.backgroundColor = [UIColor colorWithHex:0x1d1d1d];
        _cardBackView.layer.cornerRadius = 5.0;
        _cardBackView.layer.masksToBounds = YES;
        [self.contentView addSubview:_cardBackView];
        
        // 2. 上方背景
        _playBackView = [[UIView alloc] initWithFrame:CGRectZero];
        [_cardBackView addSubview:_playBackView];
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPlayBackView)];
        [_playBackView addGestureRecognizer:tap];
    
        // 2.1 播放控件
        NSString *path = [[NSBundle mainBundle] pathForResource:@"demo1" ofType:@"mp4"];
        NSURL *localUrl = [NSURL fileURLWithPath:path];
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
        self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        self.player = [AVPlayer playerWithPlayerItem:_playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.videoGravity = AVLayerVideoGravityResize;
        [_playBackView.layer addSublayer:_playerLayer];

        // 2.2 播放按钮
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_play_highlight"] forState:UIControlStateHighlighted];
        [_playButton addTarget:self action:@selector(onClickPlayButton) forControlEvents:UIControlEventTouchUpInside];
        [_playBackView addSubview:_playButton];
        
        // 2.3 暂停按钮，静音按钮
        _soundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_mute"]];
        _soundImageView.alpha = 0.32;
        [_playBackView addSubview:_soundImageView];
        _pauseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_pause"]];
        _pauseImageView.alpha = 0.32;
        [_playBackView addSubview:_pauseImageView];
        
        // 3. 下方背景
        _contentBackView = [[UIView alloc] initWithFrame:CGRectZero];
        [_cardBackView addSubview:_contentBackView];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor colorWithHex:0xb0b0b0];
        [_contentBackView addSubview:_contentLabel];
        
        UITapGestureRecognizer *tapOnContent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickContent)];
        [_contentBackView addGestureRecognizer:tapOnContent];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];


//        _soundImageView.hidden = ![[SharkfoodMuteSwitchDetector shared] isMute];
    }
    return self;
}

- (void)onClickPlayButton {
    [self play];
    [self.delegate onClickedPlayButtonInCollectionCell:self];
}

- (void)onClickContent {
    
}

- (void)onClickPlayBackView {


}


- (void)setQuestion:(HTQuestion *)question {
    _question = question;
    _contentLabel.text = @"111111111111111111111111111";
    [_contentLabel sizeToFit];
    
    [self setNeedsLayout];
}

- (void)dealloc {
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)play {
    _playButton.hidden = YES;
    _pauseImageView.hidden = YES;
    [_player play];
}

- (void)pause {
    _playButton.hidden = NO;
    _pauseImageView.hidden = NO;
    [_player pause];
}

- (void)stop {
    _playButton.hidden = NO;
    [_playerItem seekToTime:kCMTimeZero];
    [_player setRate:0];
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player pause];
}

#pragma mark - Notification

- (void)playItemDidPlayToEndTime:(NSNotification *)notification {
    if ([notification.object isEqual:self.playerItem]) {
        _playButton.hidden = NO;
        [_player seekToTime:kCMTimeZero];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _cardBackView.frame = CGRectMake(0, 0, self.width, self.width + 80);
    _playBackView.frame = CGRectMake(0, 0, self.width, self.width);
    _contentBackView.frame = CGRectMake(0, self.width, self.width, 80);
    
    _playerLayer.frame = CGRectMake(0, 0, self.width, self.width);
//    _playButton.center = CGPointMake(self.width / 2 , self.width / 2);
    _playButton.frame = CGRectMake(_playBackView.width / 2 - 35,
                                   _playBackView.height / 2 - 35, 70, 70);
    _soundImageView.right = _playBackView.width - 6;
    _soundImageView.top = 5;
    _pauseImageView.right = _playBackView.width - 8;
    _pauseImageView.bottom = _playBackView.height - 8;
    _contentLabel.left = 21;
    _contentLabel.centerY = 40;
}

@end
