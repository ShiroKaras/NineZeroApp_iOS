//
//  HTProfileRecordCell.m
//  NineZeroProject
//
//  Created by ronhu on 16/3/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfileRecordCell.h"
#import <AVFoundation/AVFoundation.h>
#import "HTUIHeader.h"

@interface HTProfileRecordCell ()
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) UIView *playItemBackView;
@property (nonatomic, strong) UIButton *playButton;
@end

@implementation HTProfileRecordCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _playItemBackView = [[UIView alloc] initWithFrame:CGRectZero];
        _playItemBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
        _playItemBackView.layer.cornerRadius = 5.0f;
        [self addSubview:_playItemBackView];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"demo1" ofType:@"mp4"];
        NSURL *localUrl = [NSURL fileURLWithPath:path];
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
        self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        self.player = [AVPlayer playerWithPlayerItem:_playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.videoGravity = AVLayerVideoGravityResize;
        [_playItemBackView.layer addSublayer:_playerLayer];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_profile_success_record_play"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_profile_success_record_play_highlight"] forState:UIControlStateHighlighted];
        [_playButton addTarget:self action:@selector(onClickPlayButton) forControlEvents:UIControlEventTouchUpInside];
        [_playItemBackView addSubview:_playButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _playItemBackView.frame = self.bounds;
    _playerLayer.frame = CGRectMake(4, 4, self.width - 8, self.height - 8);
    _playButton.size = CGSizeMake(57, 57);
    _playButton.center = CGPointMake(self.width / 2, self.height / 2);
}

- (void)onClickPlayButton {
    [self play];
    [self.delegate onClickedPlayButtonInCollectionCell:self];
}

- (void)dealloc {
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)play {
    _playButton.hidden = YES;
    [_player play];
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

@end
