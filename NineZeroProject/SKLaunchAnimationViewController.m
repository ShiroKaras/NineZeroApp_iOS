//
//  SKLaunchAnimationViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/5/21.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKLaunchAnimationViewController.h"
#import "HTLoginRootController.h"
#import <AVFoundation/AVFoundation.h>
#import "HTUIHeader.h"

@interface SKLaunchAnimationViewController ()

@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIButton *enterButton;

@property (strong, nonatomic) AVPlayer      *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem  *playerItem;

@end

@implementation SKLaunchAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self createUI];
    [self createVideo];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showSkipButton) userInfo:nil repeats:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.view = nil;
}

#pragma mark - Acitons
- (void)createUI {
    _skipButton = [UIButton new];
    [_skipButton addTarget:self action:@selector(onClickSkipButton:) forControlEvents:UIControlEventTouchUpInside];
    [_skipButton setImage:[UIImage imageNamed:@"btn_trailer_skip"] forState:UIControlStateNormal];
    [_skipButton sizeToFit];
    _skipButton.alpha = 0;
    [self.view addSubview:_skipButton];
    
    _enterButton = [UIButton new];
    [_enterButton addTarget:self action:@selector(onClickEnterButton:) forControlEvents:UIControlEventTouchUpInside];
    [_enterButton setImage:[UIImage imageNamed:@"btn_trailer_enter"] forState:UIControlStateNormal];
    [_enterButton sizeToFit];
    _enterButton.alpha = 0;
    [self.view addSubview:_enterButton];
    
    [_skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.bottom.equalTo(self.view.mas_bottom).offset(-25);
    }];
    
    [_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(31);
    }];
}

- (void)createVideo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"trailer_video" ofType:@"mp4"];
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:filePath];
    
    AVAsset *movieAsset	= [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:_playerLayer atIndex:0];
    
    [_player play];
}

- (void)showSkipButton {
    _skipButton.alpha = 1.0;
}

- (void)showEnterButton {
    _enterButton.alpha = 1.0;
}

- (void)onClickSkipButton:(UIButton*)sender {
    if (self.didSelectedEnter) {
        self.didSelectedEnter();
    }
}


- (void)onClickEnterButton:(UIButton*)sender {
    if (self.didSelectedEnter) {
        self.didSelectedEnter();
    }
}

#pragma mark - Notification

- (void)playItemDidPlayToEndTime:(NSNotification *)notification {
    if ([notification.object isEqual:self.playerItem]) {
        //显示进入按钮
        [self showEnterButton];
    }
}

@end
