//
//  HTCardCollectionCell.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/7.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTCardCollectionCell.h"
#import <AVFoundation/AVFoundation.h>
#import "HTUIHeader.h"
#import "SharkfoodMuteSwitchDetector.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <CommonCrypto/CommonDigest.h>

#define SHARE_URL(u,v) [NSString stringWithFormat:@"http://admin.90app.tv/index.php?s=/Home/user/detail.html&area_id=%@&id=%@", (u), [self md5:[NSString stringWithFormat:@"%llu",(v)]]]

typedef NS_ENUM(NSInteger, HTButtonType) {
    HTButtonTypeShare = 0,
    HTButtonTypeCancel,
    HTButtonTypeWechat,
    HTButtonTypeMoment,
    HTButtonTypeWeibo,
    HTButtonTypeQQ,
    HTButtonTypeReplay
};

@interface HTCardCollectionCell ()
@property (nonatomic, strong) UIView *cardBackView;

@property (nonatomic, strong) UIView *playBackView;
@property (nonatomic, strong) UIView *replayBackView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *replayButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIImageView *soundImageView;
@property (nonatomic, strong) UIImageView *pauseImageView;
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *composeButton;
@property (nonatomic, strong) UIButton *hintButton;
@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *momentButton;
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *weiboButton;

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
        _coverImageView.userInteractionEnabled = NO;
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
        if(SCREEN_WIDTH != IPHONE6_PLUS_SCREEN_WIDTH) {
            [_playBackView addSubview:_soundImageView];
        }
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

        
        // 2.5 蒙层
        _replayBackView = [[UIView alloc] init];
        _replayBackView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *noTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        [_replayBackView addGestureRecognizer:noTap];
        [_playBackView addSubview:_replayBackView];
        
        // 2.5.1 重播按钮
        _replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replayButton setImage:[UIImage imageNamed:@"btn_home_replay"] forState:UIControlStateNormal];
        [_replayButton setImage:[UIImage imageNamed:@"btn_home_replay_highlight"] forState:UIControlStateHighlighted];
        [_replayButton addTarget:self action:@selector(onClickReplayButton) forControlEvents:UIControlEventTouchUpInside];
        _replayButton.tag = HTButtonTypeReplay;
        [_replayButton sizeToFit];
        [_replayBackView addSubview:_replayButton];
        
        // 2.5.2 分享按钮
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"btn_home_share"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"btn_home_share_highlight"] forState:UIControlStateHighlighted];
        [_shareButton addTarget:self action:@selector(onClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
        [_shareButton sizeToFit];
        [_replayBackView addSubview:_shareButton];
        
        // 3. 下方背景
        _contentBackView = [[UIView alloc] initWithFrame:CGRectZero];
        [_cardBackView addSubview:_contentBackView];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor colorWithHex:0x24ddb2];
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

#pragma mark - ToolMethod

- (NSString *) md5:(NSString *)str
{
     const char *cStr = [str UTF8String];
     unsigned char result[16];
     CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
     return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                            result[0], result[1], result[2], result[3],
                            result[4], result[5], result[6], result[7],
                            result[8], result[9], result[10], result[11],
                            result[12], result[13], result[14], result[15]
   ];
}

#pragma mark - Actions

- (void)onClickReplayButton {
    [MobClick event:@"replay"];
    [UIView animateWithDuration:0.3 animations:^{
        _replayBackView.alpha = 0.;
    }];
    [self play];
    [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypePlay];
}

- (void)onClickPlayButton {
    [MobClick event:@"play"];
    [self play];
    [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypePlay];
}

- (void)onClickContent {
    [MobClick event:@"introduce"];
    [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypeContent];
}

- (void)onClickComposeButton:(UIButton *)button {
    if (_questionInfo.questionID == _question.questionID && _question.isPassed == NO) {
        [MobClick event:@"answer"];
        if (_question.type == 0) {
            [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypeAR];
        } else {
            [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypeCompose];
        }
    } else {
        [MobClick event:@"exanswer"];
        [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypeAnswer];
    }
}

- (void)onClickHintButton:(UIButton *)button {
    if (_question.isPassed) {
        [MobClick event:@"Vgift"];
        [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypeReward];
    } else {
        [MobClick event:@"warning"];
        [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypeHint];
    }
}

- (void)onClickPlayBackView {
    if ((self.player.rate != 0) && (self.player.error == nil)) {
        [self pause];
        [self.delegate collectionCell:self didClickButtonWithType:HTCardCollectionClickTypePause];
    } else {
        [self play];
    }
}

- (void)onClickShareButton:sender {
    [self showShareView];
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
    
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:_question.question_video_cover] placeholderImage:[UIImage imageNamed:@"img_chap_video_cover_default"]];
    
    _questionInfo = questionInfo;
    _contentLabel.text = question.content;
    if (_questionInfo.questionID == question.questionID && _question.isPassed == NO) {
        [_hintButton setBackgroundImage:[UIImage imageNamed:@"btn_get_hint"] forState:UIControlStateNormal];
        // TODO:判断是否需要显示"获取提示"
        _hintButton.hidden = (_questionInfo.endTime - time(NULL))>(3600*16)?YES:NO;
        
        if (_question.type == 0) {
            // ar
            [_composeButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_cam"] forState:UIControlStateNormal];
            [_composeButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_cam_highlight"] forState:UIControlStateHighlighted];
        } else {
            [_composeButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_pencil"] forState:UIControlStateNormal];
            [_composeButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_pencil_highlight"] forState:UIControlStateHighlighted];
        }
//        _hintButton.hidden = YES;
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
    if (_shareView) {
        [_shareView removeFromSuperview];
    }
    _shareView = nil;
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
    _playButton.hidden = YES;
    _pauseImageView.hidden = NO;
    [_player pause];
}

- (void)stop {
    _playButton.hidden = NO;
//    _replayButton.alpha = 0;
//    _shareButton.alpha = 0;
    _replayBackView.alpha = 0;
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

- (void)showReplayAndShareButton {
    _pauseImageView.hidden = YES;
    [_playerItem seekToTime:kCMTimeZero];
    [_player setRate:0];
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player pause];
    _coverImageView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
//        _replayButton.alpha = 1.;
//        _shareButton.alpha = 1.;
        _replayBackView.alpha = 1.;
    }];
}

#pragma mark - Share

- (void)createShareView {
    _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [KEY_WINDOW addSubview:_shareView];
    _shareView.backgroundColor = [UIColor blackColor];
    _shareView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareView)];
    [_shareView addGestureRecognizer:tap];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_chap_video_share_title"]];
    [_shareView addSubview:titleImageView];
    
    self.wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.wechatButton setImage:[UIImage imageNamed:@"ico_chap_video_share_wechat"] forState:UIControlStateNormal];
    [self.wechatButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.wechatButton sizeToFit];
    self.wechatButton.tag = HTButtonTypeWechat;
    self.wechatButton.alpha = 1;
    [_shareView addSubview:self.wechatButton];
    
    self.momentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.momentButton setImage:[UIImage imageNamed:@"ico_chap_video_share_moments"] forState:UIControlStateNormal];
    [self.momentButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.momentButton sizeToFit];
    self.momentButton.tag = HTButtonTypeMoment;
    self.momentButton.alpha = 1;
    [_shareView addSubview:self.momentButton];
    
    self.weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.weiboButton setImage:[UIImage imageNamed:@"ico_chap_video_share_weibo"] forState:UIControlStateNormal];
    [self.weiboButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.weiboButton sizeToFit];
    self.weiboButton.tag = HTButtonTypeWeibo;
    self.weiboButton.alpha = 1;
    [_shareView addSubview:self.weiboButton];
    
    self.qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.qqButton setImage:[UIImage imageNamed:@"ico_chap_video_share_qq"] forState:UIControlStateNormal];
    [self.qqButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.qqButton sizeToFit];
    self.qqButton.tag = HTButtonTypeQQ;
    self.qqButton.alpha = 1;
    [_shareView addSubview:self.qqButton];

    __weak UIView *weakShareView = _shareView;
    
    float padding = (SCREEN_WIDTH-self.wechatButton.width*4)/5;
//    float iconWidth = self.wechatButton.width;
    
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakShareView.mas_left).mas_offset(padding);
        make.centerY.equalTo(weakShareView);
    }];
    
    [self.momentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wechatButton.mas_right).mas_offset(padding);
        make.centerY.equalTo(weakShareView);
    }];
    
    [self.weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_momentButton.mas_right).mas_offset(padding);
        make.centerY.equalTo(weakShareView);
    }];
    
    [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weiboButton.mas_right).mas_offset(padding);
        make.centerY.equalTo(weakShareView);
    }];
    
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_wechatButton.mas_top).mas_offset(-36);
        make.centerX.equalTo(weakShareView);
    }];
}

- (void)showShareView {
    if (_shareView == nil) {
        [self createShareView];
    }
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.alpha = 0.8;
    }];
}

- (void)hideShareView {
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.alpha = 0;
    }];
}

- (void)shareWithThirdPlatform:(UIButton*)sender {
    [MobClick event:@"share"];
    HTButtonType type = (HTButtonType)sender.tag;
    switch (type) {
        case HTButtonTypeWechat: {
//            UIImage *oImage = [SKImageHelper getImageFromURL:_question.question_video_cover];
//            UIImage *finImage = [SKImageHelper compressImage:oImage toMaxFileSize:32];
            NSArray* imageArray = @[_question.question_video_cover];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"你会是下一个被选召的人吗？不是所有人都能完成这道考验"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(AppDelegateInstance.cityCode, _question.questionID)]
                                                  title:[NSString stringWithFormat:@"第%ld章",(unsigned long)_question.serial]
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    DLog(@"State -> %lu", (unsigned long)state);
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@",error]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil, nil];
                            [alert show];
                            break;
                        }
                        default:
                            break;
                    }
                }];
            }
            break;
        }
        case HTButtonTypeMoment: {
//            UIImage *oImage = [SKImageHelper getImageFromURL:_question.question_video_cover];
//            UIImage *finImage = [SKImageHelper compressImage:oImage toMaxFileSize:32];
            NSArray* imageArray = @[_question.question_video_cover];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:_question.content
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(AppDelegateInstance.cityCode, _question.questionID)]
                                                  title:@"你会是下一个被选召的人吗？不是所有人都能完成这道考验"
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@",error]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil, nil];
                            [alert show];
                            break;
                        }
                        default:
                            break;
                    }
                }];
            }
            break;
        }
        case HTButtonTypeWeibo: {
            NSArray* imageArray = @[_question.question_video_cover];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"你会是下一个被选召的人吗？不是所有人都能完成这道考验 %@ 来自@九零APP", [NSURL URLWithString:SHARE_URL(AppDelegateInstance.cityCode, _question.questionID)]]
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(AppDelegateInstance.cityCode, _question.questionID)]
                                                  title:_question.chapterText
                                                   type:SSDKContentTypeImage];
                [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@",error]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil, nil];
                            [alert show];
                            break;
                        }
                        default:
                            break;
                    }
                }];
            }
            break;
        }
        case HTButtonTypeQQ: {
            NSArray* imageArray = @[_question.question_video_cover];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"你会是下一个被选召的人吗？不是所有人都能完成这道考验"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(AppDelegateInstance.cityCode, _question.questionID)]
                                                  title:[NSString stringWithFormat:@"第%ld章",(unsigned long)_question.serial]
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@",error]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil, nil];
                            [alert show];
                            break;
                        }
                        default:
                            break;
                    }
                }];
            }
            break;
        }
            default:
            break;
    }
}

#pragma mark - Notification

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            DLog(@"AVPlayerStatusReadyToPlay");
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            DLog(@"AVPlayerStatusFailed");
        }
    }
}

- (void)playItemDidPlayToEndTime:(NSNotification *)notification {
    if ([notification.object isEqual:self.playerItem]) {
//        [self stop];
        //显示分享界面
        [self showReplayAndShareButton];
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
    
    _replayBackView.frame = CGRectMake(0, 0, _playBackView.frame.size.width, _playBackView.frame.size.height);
    _playButton.frame = CGRectMake(_playBackView.width / 2 - 35, _playBackView.height / 2 - 35, 70, 70);
    _replayButton.frame = CGRectMake(_replayBackView.width /2 -35 -70, _replayBackView.height / 2 -35, 70, 70);
    _shareButton.frame = CGRectMake(_replayBackView.width / 2 +35, _replayBackView.height / 2 -35, 70, 70);
    
    _soundImageView.right = _playBackView.width - 13;
    _soundImageView.top = 5;
    _pauseImageView.right = _playBackView.width - 8;
    _pauseImageView.bottom = _playBackView.height - 8;
    _contentLabel.left = 16;
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
