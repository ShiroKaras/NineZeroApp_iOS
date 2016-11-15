//
//  SKQuestionViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/7.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKQuestionViewController.h"
#import "HTUIHeader.h"

@interface SKQuestionViewController ()

@property (nonatomic, strong) UIImageView *playBackView;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@end

@implementation SKQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    _playBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_WIDTH)];
    _playBackView.backgroundColor = [UIColor redColor];
    _playBackView.layer.masksToBounds = YES;
    _playBackView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_playBackView];
    [self createVideo];
    
    __weak __typeof(self)weakSelf = self;
    
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(_playBackView.mas_bottom);
        make.height.equalTo(@100);
    }];
    
    UIButton *flowerButton = [UIButton new];
    flowerButton.backgroundColor = [UIColor redColor];
    [flowerButton addTarget:self action:@selector(flowerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flowerButton];
    [flowerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-20);
    }];
}

- (void)createVideo {
    _playerItem = nil;
    _player = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    
    NSURL *localUrl = [[NSBundle mainBundle] URLForResource:@"trailer_video" withExtension:@"mp4"];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
//    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    [_playBackView.layer addSublayer:_playerLayer];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage imageNamed:@"btn_home_replay"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"btn_home_replay_highlight" ] forState:UIControlStateHighlighted];
    [_playButton sizeToFit];
    _playButton.center = _playBackView.center;
//    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_playBackView.mas_centerX);
//        make.centerY.equalTo(_playBackView.mas_centerY);
//    }];
    [self.view addSubview:_playButton];
    [_playButton addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
    _playButton.hidden = NO;
}

#pragma mark - Actions
- (void)stop {
    _playButton.hidden = NO;
    [_player setRate:0];
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player pause];
}

- (void)pause {
    _playButton.hidden = YES;
    [_player pause];
}

- (void)play {
    _playButton.hidden = YES;
    [_player play];
}

- (void)replay {
    [_player seekToTime:CMTimeMake(0, 1)];
    [self play];
}

#pragma mark - Button Click
- (void)flowerButtonClick:(UIButton*)sender {
    
}

@end
