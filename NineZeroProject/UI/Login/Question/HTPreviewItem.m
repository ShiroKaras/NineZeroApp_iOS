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

@interface HTPreviewItem ()

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (weak, nonatomic) IBOutlet UIView *playItemBackView;

@end

@implementation HTPreviewItem

- (void)awakeFromNib {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp4"];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.videoGravity = AVLayerVideoGravityResize;
    [_playItemBackView.layer addSublayer:_playerLayer];
    
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _playerLayer.frame = _playItemBackView.bounds;
}

@end
