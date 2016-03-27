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
@property (nonatomic, strong) UIButton *hintButton;
@property (nonatomic, strong) UIImageView *coverImageView;

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIView *progressBgView;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

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
    
        // 2.1 封面
        _coverImageView = [[UIImageView alloc] init];
        [_playBackView addSubview:_coverImageView];
        
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
//        _soundImageView.hidden = ![[SharkfoodMuteSwitchDetector shared] isMute];

        // 2.4 进度条
        _progressBgView = [[UIView alloc] init];
        _progressBgView.backgroundColor = [UIColor colorWithHex:0x585858];
        [_playBackView addSubview:_progressBgView];
        
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = COMMON_GREEN_COLOR;
        [_progressBgView addSubview:_progressView];

        // 3. 下方背景
        _contentBackView = [[UIView alloc] initWithFrame:CGRectZero];
        [_cardBackView addSubview:_contentBackView];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor colorWithHex:0xb0b0b0];
        [_contentBackView addSubview:_contentLabel];
        
        UITapGestureRecognizer *tapOnContent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickContent)];
        [_contentBackView addGestureRecognizer:tapOnContent];
        

        // 4. 发布按钮
        _composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_composeButton addTarget:self action:@selector(onClickComposeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_composeButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_pencil"] forState:UIControlStateNormal];
        [_composeButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_pencil_highlight"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_composeButton];
        
        // 5. 查看提示
        _hintButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hintButton addTarget:self action:@selector(onClickHintButton:) forControlEvents:UIControlEventTouchUpInside];
        [_hintButton setBackgroundImage:[UIImage imageNamed:@"btn_get_hint"] forState:UIControlStateNormal];
        [_hintButton sizeToFit];
        [self.contentView addSubview:_hintButton];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    }
    return self;
}

- (void)onClickPlayButton {
    [self play];
    [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypePlay];
}

- (void)onClickContent {
    [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypeContent];
}

- (void)onClickComposeButton:(UIButton *)button {
    if (_questionInfo.questionID == _question.questionID) {
        if (_question.type == 0) {
            [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypeAR];
        } else {
            [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypeCompose];
        }
    } else {
        [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypeAnswer];
    }
}

- (void)onClickHintButton:(UIButton *)button {
    if (_question.isPassed) {
        [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypeReward];
    } else {
        [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypeHint];
    }
}

- (void)onClickPlayBackView {
    [self pause];
    [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypePause];
}

- (void)setSoundHidden:(BOOL)soundHidden {
    self.soundImageView.hidden = soundHidden;
}

- (void)setQuestion:(HTQuestion *)question questionInfo:(HTQuestionInfo *)questionInfo {
    _question = question;

    [self stop];
    _playerItem = nil;
    _player = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    
    NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:_question.videoName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectoryURL path]]) {
        NSURL *localUrl = [NSURL fileURLWithPath:[documentsDirectoryURL path]];
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
        self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        self.player = [AVPlayer playerWithPlayerItem:_playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.videoGravity = AVLayerVideoGravityResize;
        [_playBackView.layer insertSublayer:_playerLayer atIndex:0];
        _progressBgView.hidden = YES;
    } else {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:question.videoURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        [_downloadTask cancel];
        _downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:_question.videoName];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [self stop];
            _playerItem = nil;
            _player = nil;
            [_playerLayer removeFromSuperlayer];
            _playerLayer = nil;
            if (filePath == nil) return;
            NSURL *localUrl = [NSURL fileURLWithPath:[filePath path]];
            AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
            self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
            self.player = [AVPlayer playerWithPlayerItem:_playerItem];
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
            _playerLayer.videoGravity = AVLayerVideoGravityResize;
            [_playBackView.layer insertSublayer:_playerLayer atIndex:0];
            [self setNeedsLayout];
        }];
        [_downloadTask resume];
        [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            CGFloat progress = ((CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite);
            progress = MIN(1.0, progress);
            dispatch_async(dispatch_get_main_queue(), ^{
                _progressView.width = progress * self.width;
                if (progress == 1) {
                    _progressBgView.hidden = YES;
                } else {
                    _progressBgView.hidden = NO;
                }
            });
        }];
    }
    
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:_question.descriptionPic] placeholderImage:[UIImage imageNamed:@"img_chap_video_cover_default"]];
    
    _questionInfo = questionInfo;
    _contentLabel.text = question.content;
    if (_questionInfo.questionID == question.questionID) {
        [_hintButton setBackgroundImage:[UIImage imageNamed:@"btn_get_hint"] forState:UIControlStateNormal];
        // TODO:判断是否需要显示
        _hintButton.hidden = NO;
        if (_question.type == 0) {
            // ar
            [_composeButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_cam"] forState:UIControlStateNormal];
            [_composeButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_cam_highlight"] forState:UIControlStateHighlighted];
        } else {
            [_composeButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_pencil"] forState:UIControlStateNormal];
            [_composeButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_pencil_highlight"] forState:UIControlStateHighlighted];
        }
        _hintButton.hidden = YES;
    } else {
        [_composeButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_ans"] forState:UIControlStateNormal];
        [_composeButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_ans_highlight"] forState:UIControlStateHighlighted];
        if (_question.isPassed) {
            _hintButton.hidden = NO;
            [_hintButton setBackgroundImage:[UIImage imageNamed:@"btn_check_prize"] forState:UIControlStateNormal];
        } else {
            [_hintButton setBackgroundImage:[UIImage imageNamed:@"btn_get_hint"] forState:UIControlStateNormal];
            _hintButton.hidden = YES;
        }
    }
    [_contentLabel sizeToFit];
    _pauseImageView.hidden = YES;
    _playButton.hidden = NO;
    [_hintButton sizeToFit];
    self.soundImageView.hidden = ![[SharkfoodMuteSwitchDetector shared] isMute];
    [self setNeedsLayout];
}

- (void)dealloc {
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)play {
//    if (![self.playerItem canPlayReverse]) return;
    _playButton.hidden = YES;
    _pauseImageView.hidden = YES;
    [_player play];
    _coverImageView.hidden = YES;
}

- (void)pause {
    _playButton.hidden = NO;
    _pauseImageView.hidden = NO;
    [_player pause];
}

- (void)stop {
    _playButton.hidden = NO;
    _pauseImageView.hidden = YES;
    [_playerItem seekToTime:kCMTimeZero];
    [_player setRate:0];
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player pause];
    _coverImageView.hidden = NO;
}

- (CGRect)hintRect {
    return self.hintButton.frame;
}

#pragma mark - Notification

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    }
}

- (void)playItemDidPlayToEndTime:(NSNotification *)notification {
    if ([notification.object isEqual:self.playerItem]) {
        [self stop];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _cardBackView.frame = CGRectMake(0, 0, self.width, self.width + 80);
    _playBackView.frame = CGRectMake(0, 0, self.width, self.width);
    _contentBackView.frame = CGRectMake(0, self.width, self.width, 80);
    
    _coverImageView.frame = _playBackView.bounds;
    
    _playerLayer.frame = CGRectMake(0, 0, self.width, self.width);
//    _playButton.center = CGPointMake(self.width / 2 , self.width / 2);
    _playButton.frame = CGRectMake(_playBackView.width / 2 - 35,
                                   _playBackView.height / 2 - 35, 70, 70);
    _soundImageView.right = _playBackView.width - 13;
    _soundImageView.top = 5;
    _pauseImageView.right = _playBackView.width - 8;
    _pauseImageView.bottom = _playBackView.height - 8;
    _contentLabel.left = 21;
    _contentLabel.centerY = 40;
    [_composeButton sizeToFit];
    _composeButton.top = _contentBackView.bottom - 21;
    _composeButton.right = _cardBackView.right - 18;
    _hintButton.left = 5;
    _hintButton.top = _contentBackView.bottom;
    
    _progressBgView.frame = CGRectMake(0, 0, self.width, 3);
//    _progressView.frame = CGRectMake(0, 0, 0, 3);
    _progressView.height = 3;
    _progressBgView.bottom = _contentBackView.top;
}

@end
