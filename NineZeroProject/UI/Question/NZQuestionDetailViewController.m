//
//  NZQuestionDetailViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/30.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZQuestionDetailViewController.h"
#import "HTUIHeader.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <CommonCrypto/CommonDigest.h>
#import "NZQuestionContentView.h"

#define SHARE_URL(u, v) [NSString stringWithFormat:@"https://admin.90app.tv/index.php?s=/Home/user/detail2.html/&area_id=%@&id=%@", (u), [self md5:(v)]]

#define PLAYBACKVIEW_HEIGHT self.view.width+16+18+4+90

typedef NS_ENUM(NSInteger, HTButtonType) {
    HTButtonTypeShare = 0,
    HTButtonTypeCancel,
    HTButtonTypeWechat,
    HTButtonTypeMoment,
    HTButtonTypeWeibo,
    HTButtonTypeQQ,
    HTButtonTypeReplay
};

@interface NZQuestionDetailViewController () <UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isAnswered;

@property (nonatomic, strong) UIView *questionMainBackView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *dimmingView;

//Video
@property (nonatomic, strong) UIView *playBackView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIImageView *soundImageView;
@property (nonatomic, strong) UIImageView *pauseImageView;

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIView *progressBgView;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) UIImageView *coverImageView;

//答题
@property (nonatomic, strong) UIButton *answerButton;

//简介
@property (nonatomic, strong) UIImageView *chapterImageView;
@property (nonatomic, strong) UILabel *questionTitleLabel;

//内容
@property (nonatomic, strong) UIView *contentHeaderView;
@property (nonatomic, strong) UIView *indicatorLine;
@property (nonatomic, strong) UIScrollView *detailScrollView;

//分享
@property (nonatomic, strong) UIView *replayBackView;
@property (nonatomic, strong) UIButton *replayButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *momentButton;
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *weiboButton;

//Common
@property (nonatomic, strong) SKQuestion *currentQuestion;
@property (nonatomic, assign) SKQuestionType type;

@end

@implementation NZQuestionDetailViewController

- (instancetype)initWithType:(SKQuestionType)type questionID:(NSString *)questionID {
    if (self = [super init]) {
        self.currentQuestion = [SKQuestion new];
        _type = type;
        self.currentQuestion.qid = questionID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    WS(weakSelf);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49)];
    _scrollView.contentSize = CGSizeMake(self.view.width, PLAYBACKVIEW_HEIGHT+self.view.height-49);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-49, self.view.width, 49)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    
    UIButton *backButton = [UIButton new];
    [backButton addTarget:self action:@selector(didClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_highlight"] forState:UIControlStateHighlighted];
    [bottomView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.left.equalTo(@13.5);
    }];
  
    
    UIButton *shareButton = [UIButton new];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"btn_arpage_share"] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"btn_arpage_share_highlight"] forState:UIControlStateHighlighted];
    [bottomView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.equalTo(bottomView).offset(-13.5);
    }];
    
    UIButton *hintButton = [UIButton new];
    [hintButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_hint"] forState:UIControlStateNormal];
    [hintButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_hint_highlight"] forState:UIControlStateHighlighted];
    [bottomView addSubview:hintButton];
    [hintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.equalTo(shareButton.mas_left).offset(-25);
    }];

    //////////////////////////////////////// 视频 ////////////////////////////////////////
    
    _questionMainBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, PLAYBACKVIEW_HEIGHT+20)];
    [_scrollView addSubview:_questionMainBackView];
    
    // 主界面
    _playBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    _playBackView.layer.masksToBounds = YES;
    _playBackView.contentMode = UIViewContentModeScaleAspectFit;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_playBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _playBackView.bounds;
    maskLayer.path = maskPath.CGPath;
    _playBackView.layer.mask = maskLayer;
    [_questionMainBackView addSubview:_playBackView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPlayBackView)];
    [_playBackView addGestureRecognizer:tap];
    
    _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _playBackView.width, _playBackView.height)];
    _coverImageView.image = [UIImage imageNamed:@"img_chap_video_cover_default"];
    _coverImageView.layer.masksToBounds = YES;
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_playBackView addSubview:_coverImageView];
    
    // 2.5 蒙层
    _replayBackView = [[UIView alloc] init];
    _replayBackView.alpha = 0;
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
    
    _replayBackView.frame = CGRectMake(0, 0, _playBackView.width, _playBackView.height);
    _playButton.frame = CGRectMake(_playBackView.width / 2 - 35, _playBackView.height / 2 - 35, 70, 70);
    _replayButton.frame = CGRectMake(_replayBackView.width / 2 - 35 - 70, _replayBackView.height / 2 - 35, 70, 70);
    _shareButton.frame = CGRectMake(_replayBackView.width / 2 + 35, _replayBackView.height / 2 - 35, 70, 70);
    
    // 2.3 暂停按钮，静音按钮
    _soundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_mute"]];
    _soundImageView.alpha = 0.32;
    if (SCREEN_WIDTH != IPHONE6_PLUS_SCREEN_WIDTH) {
        //        [_playBackView addSubview:_soundImageView];
    }
    _pauseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_pause"]];
    _pauseImageView.alpha = 0.32;
    [_playBackView addSubview:_pauseImageView];
    
    // 进度条
    _progressBgView = [[UIView alloc] init];
    _progressBgView.backgroundColor = [UIColor colorWithHex:0x585858];
    [_playBackView addSubview:_progressBgView];
    [_progressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_playBackView.width, 3));
        make.bottom.equalTo(_playBackView);
        make.centerX.equalTo(_playBackView);
    }];
    
    _progressView = [[UIView alloc] init];
    _progressView.backgroundColor = COMMON_GREEN_COLOR;
    [_progressBgView addSubview:_progressView];
    _progressView.height = 3;
    
    _soundImageView.right = _playBackView.width - 13;
    _soundImageView.top = 5;
    _pauseImageView.right = _playBackView.width - 8;
    _pauseImageView.bottom = _playBackView.height - 8;
    
    _pauseImageView.hidden = YES;
    
    //////////////////////////////////////// 答题 ////////////////////////////////////////
    
    _answerButton = [UIButton new];
    [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_write"] forState:UIControlStateNormal];
    [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_write_highlight"] forState:UIControlStateHighlighted];
    [_scrollView addSubview:_answerButton];
    [_answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_playBackView).offset(-16);
        make.bottom.equalTo(_playBackView).offset(-16);
    }];
    
    //////////////////////////////////////// 介绍 ////////////////////////////////////////
    
    _chapterImageView = [UIImageView new];
    _chapterImageView.backgroundColor = COMMON_GREEN_COLOR;
    [_questionMainBackView addSubview:_chapterImageView];
    _chapterImageView.top = _playBackView.bottom +16;
    _chapterImageView.left = 16;
    _chapterImageView.size = CGSizeMake(80, 18);
    
    _questionTitleLabel = [UILabel new];
    _questionTitleLabel.text = @"零仔们\n在盐映画的证件照里\n看到了什么？";
    _questionTitleLabel.textColor = [UIColor whiteColor];
    _questionTitleLabel.font = PINGFANG_FONT_OF_SIZE(18);
    _questionTitleLabel.numberOfLines = 3;
    [_questionTitleLabel sizeToFit];
    [_questionMainBackView addSubview:_questionTitleLabel];
    _questionTitleLabel.size = CGSizeMake(270, 90);
    _questionTitleLabel.top = _chapterImageView.bottom +4;
    _questionTitleLabel.left = _chapterImageView.left;
    
    //////////////////////////////////////// 详细内容 ////////////////////////////////////////
    
    _contentHeaderView = [UIView new];
    _contentHeaderView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_contentHeaderView];
    [_contentHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_contentHeaderView.superview);
        make.height.equalTo(@55);
        make.top.equalTo(_questionMainBackView.mas_bottom);
        make.centerX.equalTo(_contentHeaderView.superview);
    }];
    
    [self.view layoutIfNeeded];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 54, self.view.width, 1)];
    bottomLine.backgroundColor = COMMON_TEXT_3_COLOR;
    [_contentHeaderView addSubview:bottomLine];
    
    _indicatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 54, 44, 1)];
    _indicatorLine.backgroundColor = COMMON_GREEN_COLOR;
    [_contentHeaderView addSubview:_indicatorLine];
    
    float padding = (self.view.width-52-27)/3;
    NSArray *imageNameArray = @[@"btn_puzzledetailpage_story", @"btn_puzzledetailpage_answer", @"btn_puzzledetailpage_ranking", @"btn_puzzledetailpage_gift"];
    
    for (int i=0; i<4; i++) {
        UIButton *button = [UIButton new];
        button.tag = 100+i;
        [button addTarget:self action:@selector(didClickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [_contentHeaderView addSubview:button];
        [button setBackgroundImage:[UIImage imageNamed:imageNameArray[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlight", imageNameArray[i]]] forState:UIControlStateHighlighted];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(27, 27));
            make.centerY.equalTo(_contentHeaderView);
            make.left.mas_equalTo(26+i*padding);
        }];
    }
    [self.view layoutIfNeeded];
    
    _indicatorLine.centerX = [self.view viewWithTag:100].centerX;
    
    UIView *contentView = [UIView new];
    [_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(contentView.superview);
        make.centerX.equalTo(contentView.superview);
        make.top.equalTo(_contentHeaderView.mas_bottom);
        make.height.mas_equalTo(SCREEN_HEIGHT-20-55-49);
    }];
    
    [self.view layoutIfNeeded];
    
    _detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, contentView.width, contentView.height)];
    _detailScrollView.bounces = NO;
    _detailScrollView.showsHorizontalScrollIndicator = NO;
    _detailScrollView.pagingEnabled = YES;
    _detailScrollView.contentSize = CGSizeMake(contentView.width*4, contentView.height-20);
    _detailScrollView.delegate = self;
    [contentView addSubview:_detailScrollView];
    
    //本章故事
    NZQuestionContentView *questionContentView = [[NZQuestionContentView alloc] initWithFrame:CGRectMake(0, 0, contentView.width, contentView.height) content:@"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试\n\n测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试\n\n测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试\n\n测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试\n\n测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试\n\n测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试\n\n"];
    questionContentView.height = questionContentView.viewHeight;
    [_detailScrollView addSubview:questionContentView];

    
    
    //////////////////////////////////////// END ////////////////////////////////////////
    
    if (NO_NETWORK) {
        [HTProgressHUD dismiss];
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        HTBlankView *blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
        [self.view addSubview:blankView];
        blankView.top = ROUND_HEIGHT_FLOAT(217);
    } else {
        [self loadData];
    }
}

- (void)loadData {
//    [self createVideoOnView:_playBackView withFrame:CGRectMake(0, 0, _playBackView.width, _playBackView.height)];
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"img_puzzledetailpage_play"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"img_puzzledetailpage_play_highlight"] forState:UIControlStateHighlighted];
    [_playButton sizeToFit];
    _playButton.center = _playBackView.center;
    _playButton.hidden = NO;
    [_questionMainBackView addSubview:_playButton];

}

//视频
- (void)createVideoOnView:(UIView *)backView withFrame:(CGRect)frame {
    _playerItem = nil;
    _player = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    //    [_playButton removeFromSuperview];
    
    NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:self.currentQuestion.question_video];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectoryURL path]]) {
        NSURL *localUrl = [NSURL fileURLWithPath:[documentsDirectoryURL path]];
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
        self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        self.player = [AVPlayer playerWithPlayerItem:_playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.videoGravity = AVLayerVideoGravityResize;
        _playerLayer.frame = frame;
        [backView.layer insertSublayer:_playerLayer atIndex:0];
        _progressBgView.hidden = YES;
    } else {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:self.currentQuestion.question_video_url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        [_downloadTask cancel];
        _downloadTask = [manager downloadTaskWithRequest:request
                                                progress:nil
                                             destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                 NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                                 return [documentsDirectoryURL URLByAppendingPathComponent:self.currentQuestion.question_video];
                                             }
                                       completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                           [self stop];
                                           _playerItem = nil;
                                           _player = nil;
                                           [_playerLayer removeFromSuperlayer];
                                           _playerLayer = nil;
                                           if (filePath == nil)
                                               return;
                                           NSURL *localUrl = [NSURL fileURLWithPath:[filePath path]];
                                           AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
                                           self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
                                           self.player = [AVPlayer playerWithPlayerItem:_playerItem];
                                           self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
                                           _playerLayer.videoGravity = AVLayerVideoGravityResize;
                                           _playerLayer.frame = frame;
                                           [backView.layer insertSublayer:_playerLayer atIndex:0];
                                           [self.view setNeedsLayout];
                                       }];
        [_downloadTask resume];
        [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *_Nonnull session, NSURLSessionDownloadTask *_Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            CGFloat progress = ((CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite);
            progress = MIN(1.0, progress);
            dispatch_async(dispatch_get_main_queue(), ^{
                _progressView.width = progress * _playBackView.width;
                if (progress == 1) {
                    _progressBgView.hidden = YES;
                } else {
                    _progressBgView.hidden = NO;
                }
            });
        }];
    }
    
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:self.currentQuestion.question_video_cover] placeholderImage:[UIImage imageNamed:@"img_chap_video_cover_default"]];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"img_puzzledetailpage_play"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"img_puzzledetailpage_play_highlight"] forState:UIControlStateHighlighted];
    [_playButton sizeToFit];
    _playButton.center = backView.center;
    _playButton.hidden = NO;
    [self.view addSubview:_playButton];
}

#pragma mark - ScrollView Delegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        //得到图片移动相对原点的坐标
        CGPoint point = scrollView.contentOffset;
        
        if (point.y > 2*SCREEN_HEIGHT) {
            point.y = 503;
            scrollView.contentOffset = point;
        }
    }
    
    if (scrollView == _detailScrollView) {
        //得到图片移动相对原点的坐标
        CGPoint point = scrollView.contentOffset;
        //移动不能超过右边
        if (point.x > 4 * SCREEN_WIDTH) {
            point.x = SCREEN_WIDTH * 4;
            scrollView.contentOffset = point;
        }
        //根据图片坐标判断页数
        int index = round(point.x / (SCREEN_WIDTH));
        [self scrollToIndex:index];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
}

- (void)scrollToIndex:(int)index {
    [UIView animateWithDuration:0.2 animations:^{
        _indicatorLine.centerX = [self.view viewWithTag:100+index].centerX;
    }];
}

#pragma mark - Actions

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeDimmingView {
    [_dimmingView removeFromSuperview];
    _dimmingView = nil;
    self.currentIndex = 0;
}

- (void)didClickTitleButton:(UIButton*)sender {
    int index = (int)sender.tag -100;
    [self scrollToIndex:index];
    CGPoint point = _detailScrollView.contentOffset;
    point.x = self.view.width*index;
    [UIView animateWithDuration:0.3 animations:^{
        _detailScrollView.contentOffset = point;
    }];
}

#pragma mark - Video Actions

- (void)stop {
    _playButton.hidden = NO;
    _coverImageView.hidden = NO;
    _pauseImageView.hidden = YES;
    _replayBackView.alpha = 0;
    [_player setRate:0];
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player pause];
}

- (void)pause {
    _playButton.hidden = YES;
    _pauseImageView.hidden = NO;
    [_player pause];
}

- (void)play {
    [TalkingData trackEvent:@"play"];
    _pauseImageView.hidden = YES;
    _playButton.hidden = YES;
    _coverImageView.hidden = YES;
    [_player play];
}

- (void)replay {
    [TalkingData trackEvent:@"replay"];
    [_player seekToTime:CMTimeMake(0, 1)];
    [self play];
}

- (void)showReplayAndShareButton {
    _pauseImageView.hidden = YES;
    [_playerItem seekToTime:kCMTimeZero];
    [_player setRate:0];
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player pause];
    _coverImageView.hidden = NO;
    [self.view bringSubviewToFront:_replayBackView];
    [UIView animateWithDuration:0.3
                     animations:^{
                         _replayBackView.alpha = 1.;
                     }];
}

- (void)onClickPlayBackView {
    if ((self.player.rate != 0) && (self.player.error == nil)) {
        [self pause];
    } else {
        [self play];
    }
}

- (void)onClickReplayButton {
    //[MobClick event:@"replay"];
    [TalkingData trackEvent:@"replay"];
    [UIView animateWithDuration:0.3
                     animations:^{
                         _replayBackView.alpha = 0.;
                     }];
    [self play];
}

- (void)setSoundHidden:(BOOL)soundHidden {
    self.soundImageView.hidden = soundHidden;
}

#pragma mark - 分享

- (void)onClickShareButton:sender {
    [self showShareView];
}

- (void)showShareView {
    if (_shareView == nil) {
        [self createShareView];
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         _shareView.alpha = 0.9;
                     }];
}

- (void)hideShareView {
    [UIView animateWithDuration:0.3
                     animations:^{
                         _shareView.alpha = 0;
                     }];
}

- (void)createShareView {
    _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_shareView];
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
    
    float padding = (SCREEN_WIDTH - self.wechatButton.width * 4) / 5;
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

- (void)showSharePromptView {
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0;
    [_dimmingView addSubview:alphaView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
    tap.numberOfTapsRequired = 1;
    [_dimmingView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         alphaView.alpha = 0.6;
                     }];
    
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_popup_share"]];
    promptImageView.center = _dimmingView.center;
    [_dimmingView addSubview:promptImageView];
}

- (void)sharedQuestion {
    [[[SKServiceManager sharedInstance] questionService] shareQuestionWithQuestionID:self.currentQuestion.qid
                                                                            callback:^(BOOL success, SKResponsePackage *response) {
                                                                                if (response.result == 0) {
                                                                                    [self showSharePromptView];
                                                                                }
                                                                            }];
}

- (void)shareWithThirdPlatform:(UIButton *)sender {
    [TalkingData trackEvent:@"share"];
    HTButtonType type = (HTButtonType)sender.tag;
    switch (type) {
        case HTButtonTypeWechat: {
            if (![WXApi isWXAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            NSArray *imageArray = @[self.currentQuestion.question_video_cover];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"你会是下一个被选召的人吗？不是所有人都能完成这道考验"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(AppDelegateInstance.cityCode, self.currentQuestion.qid)]
                                                  title:[NSString stringWithFormat:@"第%@章", self.currentQuestion.serial]
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatSession
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     DLog(@"State -> %lu", (unsigned long)state);
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self hideShareView];
                             [self sharedQuestion];
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
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
            if (![WXApi isWXAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray *imageArray = @[self.currentQuestion.question_video_cover];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:self.currentQuestion.content
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(AppDelegateInstance.cityCode, self.currentQuestion.qid)]
                                                  title:@"你会是下一个被选召的人吗？不是所有人都能完成这道考验"
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self hideShareView];
                             [self sharedQuestion];
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
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
            if (![WeiboSDK isWeiboAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray *imageArray = @[self.currentQuestion.question_video_cover];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"你会是下一个被选召的人吗？不是所有人都能完成这道考验 %@ 来自@九零APP", SHARE_URL(AppDelegateInstance.cityCode, self.currentQuestion.qid)]
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(AppDelegateInstance.cityCode, self.currentQuestion.qid)]
                                                  title:self.currentQuestion.chapter
                                                   type:SSDKContentTypeImage];
                [ShareSDK share:SSDKPlatformTypeSinaWeibo
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self hideShareView];
                             [self sharedQuestion];
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
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
            if (![QQApiInterface isQQInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray *imageArray = @[self.currentQuestion.question_video_cover];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"你会是下一个被选召的人吗？不是所有人都能完成这道考验"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(AppDelegateInstance.cityCode, self.currentQuestion.qid)]
                                                  title:[NSString stringWithFormat:@"第%@章", self.currentQuestion.serial]
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeQQFriend
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self hideShareView];
                             [self sharedQuestion];
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
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

#pragma mark - ToolMethod

- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0],
            result[1],
            result[2],
            result[3],
            result[4],
            result[5],
            result[6],
            result[7],
            result[8],
            result[9],
            result[10],
            result[11],
            result[12],
            result[13],
            result[14],
            result[15]];
}

@end