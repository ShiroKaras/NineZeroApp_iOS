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
    __weak __typeof(self)weakSelf = self;
    
    UIButton *lightButton = [UIButton new];
    [lightButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_help"] forState:UIControlStateNormal];
    [lightButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_help_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:lightButton];
    [lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(@12);
        make.right.equalTo(weakSelf.view.mas_right).offset(-4);
    }];
    
    _playBackView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 106, SCREEN_WIDTH-20, SCREEN_WIDTH-20)];
    _playBackView.backgroundColor = [UIColor redColor];
    _playBackView.layer.masksToBounds = YES;
    _playBackView.contentMode = UIViewContentModeScaleAspectFit;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_playBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _playBackView.bounds;
    maskLayer.path = maskPath.CGPath;
    _playBackView.layer.mask = maskLayer;
    [self.view addSubview:_playBackView];
    [self createVideo];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, _playBackView.bottom, _playBackView.width, 72)];
    contentView.backgroundColor = COMMON_SEPARATOR_COLOR;
    [self.view addSubview:contentView];
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = contentView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    contentView.layer.mask = maskLayer2;
    
    UIImageView *chapterImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    
    UILabel *chapterTitleLabel = [UILabel new];
    chapterTitleLabel.textColor = COMMON_PINK_COLOR;
    chapterTitleLabel.text = @"#我是异类";
    chapterTitleLabel.font = PINGFANG_FONT_OF_SIZE(14);
    [self.view addSubview:chapterTitleLabel];
    [chapterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(12);
        make.top.equalTo(contentView.mas_top).offset(13);
        make.right.equalTo(contentView.mas_right).offset(-12);
    }];
    
    UILabel *chapterSubTitleLabel = [UILabel new];
    chapterSubTitleLabel.textColor = COMMON_GREEN_COLOR;
    chapterSubTitleLabel.text = @"帮助零仔解除炸弹";
    chapterSubTitleLabel.font = PINGFANG_FONT_OF_SIZE(15);
    [self.view addSubview:chapterSubTitleLabel];
    [chapterSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(12);
        make.top.equalTo(chapterTitleLabel.mas_bottom).offset(5);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detailspage_arrow"]];
    [self.view addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chapterSubTitleLabel.mas_right).offset(6);
        make.centerY.equalTo(chapterSubTitleLabel.mas_centerY);
    }];
    
    UIImageView *triangleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_detailspage_triangle"]];
    [triangleImageView sizeToFit];
    [self.view addSubview:triangleImageView];
    [triangleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom);
        make.left.equalTo(contentView.mas_left).offset(20);
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
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_play_highlight" ] forState:UIControlStateHighlighted];
    [_playButton sizeToFit];
    _playButton.center = _playBackView.center;
    [self.view addSubview:_playButton];
    [_playButton addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
    _playButton.hidden = NO;
}

#pragma mark - Video Actions
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



@end
