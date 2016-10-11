//
//  SKVideoView.m
//  NineZeroProject
//
//  Created by SinLemon on 16/10/10.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKVideoView.h"
#import "HTUIHeader.h"
#import <AVFoundation/AVFoundation.h>

@interface SKVideoView ()
@property (strong, nonatomic) AVPlayer      *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem  *playerItem;
@end

@implementation SKVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self createVideo];
}

- (void)createVideo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"trailer_video" ofType:@"mp4"];
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:filePath];
    
    AVAsset *movieAsset	= [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 0, self.width, self.height);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer insertSublayer:_playerLayer atIndex:0];
    
    [_player play];
}

@end
