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

#import "SKCardTimeView.h"
#import "NZQuestionContentView.h"
#import "SKAnswerDetailView.h"
#import "NZQuestionRankListView.h"
#import "NZQuestionGiftView.h"
#import "SKHintView.h"
#import "HTARCaptureController.h"
#import "SKComposeView.h"

#define SHARE_URL(u, v) [NSString stringWithFormat:@"https://admin.90app.tv/index.php?s=/Home/user/detail2.html/&area_id=%@&id=%@", (u), [self md5:(v)]]

#define PLAYBACKVIEW_HEIGHT (self.view.width+16+18+4+90)
#define SCROLLVIEW_HEIGHT (SCREEN_HEIGHT-20-55-49)
typedef NS_ENUM(NSInteger, HTButtonType) {
    HTButtonTypeShare = 0,
    HTButtonTypeCancel,
    HTButtonTypeWechat,
    HTButtonTypeMoment,
    HTButtonTypeWeibo,
    HTButtonTypeQQ,
    HTButtonTypeReplay
};

@interface NZQuestionDetailViewController () <UIScrollViewDelegate,SKComposeViewDelegate,HTARCaptureControllerDelegate>

@property (nonatomic, strong) UIView *questionMainBackView;
@property (nonatomic, strong) UIScrollView *questionMainScrollView;
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
@property (nonatomic, strong) SKCardTimeView *timeView;
@property (nonatomic, strong) SKComposeView *composeView;	 // 答题界面

//简介
@property (nonatomic, strong) UIImageView *chapterImageView;
@property (nonatomic, strong) UILabel *questionTitleLabel;

//内容
@property (nonatomic, strong) UIView *contentHeaderView;
@property (nonatomic, strong) UIView *indicatorLine;
@property (nonatomic, strong) UIScrollView *detailScrollView;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NZQuestionContentView *questionContentView;
@property (nonatomic, strong) NZQuestionRankListView *questionListView;
@property (nonatomic, strong) NZQuestionGiftView *questionGiftView;

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
@property (nonatomic, strong) NSArray<SKUserInfo *> *top10Array;
@property (nonatomic, assign) NZQuestionType type;
@property (nonatomic, assign) BOOL isAnswered;
@property (nonatomic, assign) NSInteger wrongAnswerCount;

//奖励
@property (nonatomic, strong) NSDictionary *rewardDict;
@property (nonatomic, strong) SKReward *reward;

@end

@implementation NZQuestionDetailViewController

- (instancetype)initWithType:(NZQuestionType)type questionID:(NSString *)questionID {
    if (self = [super init]) {
        self.currentQuestion = [SKQuestion new];
        _type = type;
        self.currentQuestion.qid = questionID;
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"isAnswered"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    [self createUI];
    
    [self addObserver:self forKeyPath:@"isAnswered" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
//    WS(weakSelf);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _questionMainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49)];
    _questionMainScrollView.contentSize = CGSizeMake(self.view.width, PLAYBACKVIEW_HEIGHT+self.view.height-49);
    _questionMainScrollView.showsHorizontalScrollIndicator = NO;
    _questionMainScrollView.showsVerticalScrollIndicator = NO;
    _questionMainScrollView.bounces = NO;
    _questionMainScrollView.pagingEnabled = YES;
    _questionMainScrollView.delegate = self;
    [self.view addSubview:_questionMainScrollView];
    
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
    [shareButton addTarget:self action:@selector(onClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"btn_arpage_share"] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"btn_arpage_share_highlight"] forState:UIControlStateHighlighted];
    [bottomView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.equalTo(bottomView).offset(-13.5);
    }];
    
    UIButton *hintButton = [UIButton new];
    [hintButton addTarget:self action:@selector(didClickHintButton:) forControlEvents:UIControlEventTouchUpInside];
    [hintButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_hint"] forState:UIControlStateNormal];
    [hintButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_hint_highlight"] forState:UIControlStateHighlighted];
    [bottomView addSubview:hintButton];
    [hintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.equalTo(shareButton.mas_left).offset(-25);
    }];

    //////////////////////////////////////// 视频 ////////////////////////////////////////
    
    _questionMainBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, PLAYBACKVIEW_HEIGHT+20)];
    [_questionMainScrollView addSubview:_questionMainBackView];
    
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
    [_answerButton addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_write"] forState:UIControlStateNormal];
    [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_write_highlight"] forState:UIControlStateHighlighted];
    [_answerButton sizeToFit];
    [_questionMainBackView addSubview:_answerButton];
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
    _chapterImageView.size = CGSizeMake(210, 90);
    
    //////////////////////////////////////// 详细内容 ////////////////////////////////////////
    
    _contentHeaderView = [UIView new];
    _contentHeaderView.backgroundColor = [UIColor clearColor];
    [_questionMainScrollView addSubview:_contentHeaderView];
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
    [((UIButton*)[self.view viewWithTag:100]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlight",imageNameArray[0]]] forState:UIControlStateNormal];
    
    [self.view layoutIfNeeded];
    
    _indicatorLine.centerX = [self.view viewWithTag:100].centerX;
    
    UIView *contentBackView = [UIView new];
    [_questionMainScrollView addSubview:contentBackView];
    [contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(contentBackView.superview);
        make.centerX.equalTo(contentBackView.superview);
        make.top.equalTo(_contentHeaderView.mas_bottom);
        make.height.mas_equalTo(SCREEN_HEIGHT-20-55-49);
    }];
    
    [self.view layoutIfNeeded];
    
    _detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, contentBackView.width, contentBackView.height)];
    _detailScrollView.bounces = NO;
    _detailScrollView.showsHorizontalScrollIndicator = NO;
    _detailScrollView.pagingEnabled = YES;
    _detailScrollView.contentSize = CGSizeMake(contentBackView.width*4, contentBackView.height-20);
    _detailScrollView.delegate = self;
    [contentBackView addSubview:_detailScrollView];
    
    //本章故事

    //答案文章
    
    
    //排名列表
    _questionListView = [[NZQuestionRankListView alloc] initWithFrame:CGRectMake(2*contentBackView.width, 0, contentBackView.width, contentBackView.height) rankArray:nil];
    [_detailScrollView addSubview:_questionListView];
    
    //奖励
    _questionGiftView = [[NZQuestionGiftView alloc] initWithFrame:CGRectMake(3*contentBackView.width, 0, contentBackView.width, contentBackView.height) withReward:nil];
    [_detailScrollView addSubview:_questionGiftView];
    
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
    [HTProgressHUD show];
    [[[SKServiceManager sharedInstance] questionService] getQuestionDetailWithQuestionID:self.currentQuestion.qid
                                                                                callback:^(BOOL success, SKQuestion *question) {
                                                                                    [HTProgressHUD dismiss];
//                                                                                    _timeView.hidden = NO;
                                                                                    _answerButton.hidden = NO;
                                                                                    
                                                                                    self.currentQuestion = question;
                                                                                    self.isAnswered = question.is_answer;
                                                                                    
                                                                                    //题目文章
                                                                                    _questionContentView = [[NZQuestionContentView alloc] initWithFrame:CGRectMake(0, 0, _detailScrollView.width, _detailScrollView.height) question:self.currentQuestion];
//                                                                                    _questionContentView.height = _questionContentView.viewHeight;
                                                                                    [_detailScrollView addSubview:_questionContentView];
                                                                                    
                                                                                    //视频
                                                                                    [self createVideoOnView:_playBackView withFrame:CGRectMake(0, 0, _playBackView.width, _playBackView.height)];
                                                                                    
                                                                                    if (self.currentQuestion.base_type==0) {
                                                                                        [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_write"] forState:UIControlStateNormal];
                                                                                        [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_write_highlight"] forState:UIControlStateHighlighted];
                                                                                    } else {
                                                                                        if (self.type == NZQuestionTypeTimeLimitLevel) {
                                                                                            [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_scanning"] forState:UIControlStateNormal];
                                                                                            [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_scanning_highlight"] forState:UIControlStateHighlighted];
                                                                                        } else if (self.type == NZQuestionTypeHistoryLevel) {
                                                                                            [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_locked"] forState:UIControlStateNormal];
                                                                                            [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_locked_highlight"] forState:UIControlStateHighlighted];
                                                                                        }
                                                                                    }
                                                                                    
                                                                                    
                                                                                    
                                                                                    [[[SKServiceManager sharedInstance] answerService] getRewardWithQuestionID:self.currentQuestion.qid
                                                                                                                                                      rewardID:self.currentQuestion.reward_id
                                                                                                                                                      callback:^(BOOL success, SKResponsePackage *response) {
                                                                                                                                                          if (response.result == 0) {
                                                                                                                                                              self.rewardDict = response.data;
                                                                                                                                                              self.reward = [SKReward mj_objectWithKeyValues:self.rewardDict];
                                                                                                                                                          }
                                                                                                                                                      }];
                                                                                    
                                                                                    [[[SKServiceManager sharedInstance] questionService] getQuestionTop10WithQuestionID:self.currentQuestion.qid
                                                                                                                                                               callback:^(BOOL success, NSArray<SKUserInfo *> *userRankList) {
                                                                                                                                                                   self.top10Array = userRankList;
                                                                                                                                                               }];
                                                                                    
//                                                                                    [self loadMascot];
                                                                                }];
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
    [_questionMainBackView addSubview:_playButton];
}

#pragma mark - ScrollView Delegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _questionMainScrollView) {
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
    NSArray *imageNameArray = @[@"btn_puzzledetailpage_story", @"btn_puzzledetailpage_answer", @"btn_puzzledetailpage_ranking", @"btn_puzzledetailpage_gift"];
    switch (index) {
        case 0:
            [((UIButton*)[self.view viewWithTag:100+index]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlight",imageNameArray[index]]] forState:UIControlStateNormal];
            [((UIButton*)[self.view viewWithTag:101]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameArray[1]]] forState:UIControlStateNormal];
            [((UIButton*)[self.view viewWithTag:102]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameArray[2]]] forState:UIControlStateNormal];
            [((UIButton*)[self.view viewWithTag:103]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameArray[3]]] forState:UIControlStateNormal];
            break;
        case 1:
            [((UIButton*)[self.view viewWithTag:100+index]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlight",imageNameArray[index]]] forState:UIControlStateNormal];
            [((UIButton*)[self.view viewWithTag:100]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameArray[0]]] forState:UIControlStateNormal];
            [((UIButton*)[self.view viewWithTag:102]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameArray[2]]] forState:UIControlStateNormal];
            [((UIButton*)[self.view viewWithTag:103]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameArray[3]]] forState:UIControlStateNormal];
            break;
        case 2:
            [((UIButton*)[self.view viewWithTag:100+index]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlight",imageNameArray[index]]] forState:UIControlStateNormal];
            [((UIButton*)[self.view viewWithTag:100]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameArray[0]]] forState:UIControlStateNormal];
            [((UIButton*)[self.view viewWithTag:101]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameArray[1]]] forState:UIControlStateNormal];
            [((UIButton*)[self.view viewWithTag:103]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameArray[3]]] forState:UIControlStateNormal];
            break;
        case 3:
            [((UIButton*)[self.view viewWithTag:100+index]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlight",imageNameArray[index]]] forState:UIControlStateNormal];
            [((UIButton*)[self.view viewWithTag:100]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameArray[0]]] forState:UIControlStateNormal];
            [((UIButton*)[self.view viewWithTag:101]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameArray[1]]] forState:UIControlStateNormal];
            [((UIButton*)[self.view viewWithTag:102]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameArray[2]]] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _indicatorLine.centerX = [self.view viewWithTag:100+index].centerX;
    }];
}

#pragma mark - HTARCaptureController Delegate

- (void)didClickBackButtonInARCaptureController:(HTARCaptureController *)controller reward:(SKReward *)reward {
    [controller dismissViewControllerAnimated:NO
                                   completion:^{
                                       [_composeView showAnswerCorrect:YES];
                                       self.isAnswered = YES;
                                       self.reward = reward;
                                       [_composeView endEditing:YES];
                                       [_composeView removeFromSuperview];
                                       [self removeDimmingView];
                                       [self showRewardViewWithReward:nil];
                                       
                                       [[[SKServiceManager sharedInstance] profileService] updateUserInfoFromServer];
                                       [[[SKServiceManager sharedInstance] questionService] getQuestionTop10WithQuestionID:self.currentQuestion.qid
                                                                                                                  callback:^(BOOL success, NSArray<SKUserInfo *> *userRankList) {
                                                                                                                      self.top10Array = userRankList;
                                                                                                                  }];
                                       [[[SKServiceManager sharedInstance] questionService] getQuestionListCallback:^(BOOL success, NSArray<SKQuestion *> *questionList) {
                                           self.currentQuestion = [questionList lastObject];
                                       }];
                                       //					   [[[SKServiceManager sharedInstance] questionService] getAllQuestionListCallback:^(BOOL success, NSInteger answeredQuestion_season1, NSInteger answeredQuestion_season2, NSArray<SKQuestion *> *questionList_season1, NSArray<SKQuestion *> *questionList_season2) {
                                       //					       self.currentQuestion = [questionList_season2 lastObject];
                                       //					   }];
                                   }];
}

#pragma mark - Actions

- (void)answerButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"answer"];
    if (self.currentQuestion.base_type == 0) {
        _composeView = [[SKComposeView alloc] initWithQustionID:self.currentQuestion.qid frame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _composeView.associatedQuestion = self.currentQuestion;
        _composeView.delegate = self;
        _composeView.alpha = 0.0;
        [self.view addSubview:_composeView];
        [_composeView becomeFirstResponder];
        [UIView animateWithDuration:0.3
                         animations:^{
                             _composeView.alpha = 1.0;
                             [self.view addSubview:_composeView];
                         }
                         completion:^(BOOL finished) {
                             [self stop];
                         }];
    } else {
        if (self.type == SKQuestionTypeHistoryLevel) {
            //往期关卡-线下题（地标已毁坏）
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_prompt_Invalid"]];
            [imageView sizeToFit];
            imageView.right = self.view.right - 10;
            imageView.bottom = _answerButton.top - 5;
            imageView.alpha = 0;
            [self.view addSubview:imageView];
            [UIView animateWithDuration:0.5
                             animations:^{
                                 imageView.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.5
                                                       delay:5
                                                     options:UIViewAnimationOptionCurveEaseIn
                                                  animations:^{
                                                      imageView.alpha = 0;
                                                  }
                                                  completion:^(BOOL finished) {
                                                      [imageView removeFromSuperview];
                                                  }];
                             }];
        } else if (self.type == SKQuestionTypeTimeLimitLevel) {
            //限时关卡-线下题目
            if (self.currentQuestion.base_type == 1) {
                //LBS
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
                    HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeCamera];
                    [alertView show];
                } else {
                    HTARCaptureController *arCaptureController = [[HTARCaptureController alloc] initWithQuestion:self.currentQuestion];
                    arCaptureController.delegate = self;
                    [self presentViewController:arCaptureController animated:YES completion:nil];
                }
            } else if (self.currentQuestion.base_type == 2) {
                //扫图片
            }
        }
    }
}

- (void)didClickHintButton:(UIButton*)sender {
    SKHintView *hintView = [[SKHintView alloc] initWithFrame:self.view.bounds questionID:self.currentQuestion season:2];
    [self.view addSubview:hintView];
}

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

#pragma mark - SKComposeView Delegate 答题

- (void)updateHintCount:(NSInteger)count {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[UD dictionaryForKey:kQuestionWrongAnswerCountSeason1]];
    [dict setObject:@(count) forKey:self.currentQuestion.qid];
    [UD setObject:dict forKey:kQuestionWrongAnswerCountSeason1];
}

- (void)composeView:(SKComposeView *)composeView didComposeWithAnswer:(NSString *)answer {
    if (_type == SKQuestionTypeTimeLimitLevel) {
        [[[SKServiceManager sharedInstance] answerService] answerTimeLimitTextQuestionWithAnswerText:answer
                                                                                            callback:^(BOOL success, SKResponsePackage *response) {
                                                                                                if (response.result == 0) {
                                                                                                    //回答正确
                                                                                                    [self.delegate answeredQuestionWithSerialNumber:self.currentQuestion.serial season:self.currentQuestion.level_type];
                                                                                                    self.currentQuestion.is_answer = YES;
                                                                                                    [_composeView showAnswerCorrect:YES];
                                                                                                    self.isAnswered = YES;
                                                                                                    
                                                                                                    self.rewardDict = response.data;
                                                                                                    self.reward = [SKReward mj_objectWithKeyValues:self.rewardDict];
                                                                                                    [[[SKServiceManager sharedInstance] questionService] getQuestionTop10WithQuestionID:self.currentQuestion.qid
                                                                                                                                                                               callback:^(BOOL success, NSArray<SKUserInfo *> *userRankList) {
                                                                                                                                                                                   self.top10Array = userRankList;
                                                                                                                                                                               }];
                                                                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                                                        [_composeView endEditing:YES];
                                                                                                        [_composeView removeFromSuperview];
                                                                                                        [self removeDimmingView];
                                                                                                        [self showRewardViewWithReward:nil];
                                                                                                    });
                                                                                                } else if (response.result == -3004) {
                                                                                                    //回答错误
                                                                                                    [_composeView showAnswerCorrect:NO];
                                                                                                    _wrongAnswerCount++;
                                                                                                    [self updateHintCount:_wrongAnswerCount];
                                                                                                    if ([[UD dictionaryForKey:kQuestionWrongAnswerCountSeason1][self.currentQuestion.qid] integerValue] > 2) {
                                                                                                        [_composeView showAnswerTips:self.currentQuestion.hint];
                                                                                                    }
                                                                                                } else if (response.result == -7007) {
                                                                                                }
                                                                                            }];
    } else if (_type == SKQuestionTypeHistoryLevel) {
        [[[SKServiceManager sharedInstance] answerService] answerExpiredTextQuestionWithQuestionID:self.currentQuestion.qid
                                                                                        answerText:answer
                                                                                          callback:^(BOOL success, SKResponsePackage *response) {
                                                                                              if (response.result == 0) {
                                                                                                  //回答正确
                                                                                                  [self.delegate answeredQuestionWithSerialNumber:self.currentQuestion.serial season:self.currentQuestion.level_type];
                                                                                                  self.currentQuestion.is_answer = YES;
                                                                                                  [_composeView showAnswerCorrect:YES];
                                                                                                  self.isAnswered = YES;
                                                                                                  
                                                                                                  self.rewardDict = response.data;
                                                                                                  self.reward = [SKReward mj_objectWithKeyValues:self.rewardDict];
                                                                                                  [[[SKServiceManager sharedInstance] questionService] getQuestionTop10WithQuestionID:self.currentQuestion.qid
                                                                                                                                                                             callback:^(BOOL success, NSArray<SKUserInfo *> *userRankList) {
                                                                                                                                                                                 self.top10Array = userRankList;
                                                                                                                                                                             }];
                                                                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                                                      [_composeView endEditing:YES];
                                                                                                      [_composeView removeFromSuperview];
                                                                                                      [self removeDimmingView];
                                                                                                      [self showRewardViewWithReward:nil];
                                                                                                  });
                                                                                              } else if (response.result == -3004) {
                                                                                                  //回答错误
                                                                                                  [_composeView showAnswerCorrect:NO];
                                                                                                  _wrongAnswerCount++;
                                                                                                  [self updateHintCount:_wrongAnswerCount];
                                                                                              } else if (response.result == -7007) {
                                                                                              }
                                                                                          }];
    }
}

- (void)didClickDimingViewInComposeView:(SKComposeView *)composeView {
    [self.view endEditing:YES];
    [composeView removeFromSuperview];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _composeView.frame = CGRectMake(0, 0, self.view.width, self.view.height - keyboardRect.size.height);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [_composeView removeFromSuperview];
    [_composeView endEditing:YES];
}

- (void)keyboardDidHide:(NSNotification *)notification {
//    //显示GuideView
//    if (FIRST_COACHMARK_TYPE_2 && [[UD dictionaryForKey:kQuestionWrongAnswerCountSeason1][self.currentQuestion.qid] integerValue] > 2) {
//        [self showGuideviewWithType:SKHelperGuideViewType2];
//        [UD setBool:YES forKey:@"firstLaunchTypeThreeWrongAnswer"];
//    }
}

#pragma mark - 获取奖励

- (void)showRewardViewWithReward:(SKReward *)reward {
    NZQuestionFullScreenGiftView *rewardView = [[NZQuestionFullScreenGiftView alloc] initWithFrame:self.view.bounds withReward:self.reward];
    [self.view addSubview:rewardView];
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

- (void)playItemDidPlayToEndTime:(NSNotification *)notification {
    if ([notification.object isEqual:self.playerItem]) {
        //        [self stop];
        //显示分享界面
        [self showReplayAndShareButton];
//        if (FIRST_COACHMARK_TYPE_1 && !self.currentQuestion.is_answer) {
//            [self showGuideviewWithType:SKHelperGuideViewType1];
//            [UD setBool:YES forKey:@"firstLaunchTypePlayToEnd"];
//        }
    }
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
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sharepage_text"]];
    [_shareView addSubview:titleImageView];
    
    self.wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.wechatButton setImage:[UIImage imageNamed:@"btn_sharepage_weibo"] forState:UIControlStateNormal];
    [self.wechatButton setImage:[UIImage imageNamed:@"btn_sharepage_weibo_highlight"] forState:UIControlStateHighlighted];
    [self.wechatButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.wechatButton sizeToFit];
    self.wechatButton.tag = HTButtonTypeWechat;
    self.wechatButton.alpha = 1;
    [_shareView addSubview:self.wechatButton];
    
    self.momentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.momentButton setImage:[UIImage imageNamed:@"btn_sharepage_friendcircle"] forState:UIControlStateNormal];
    [self.momentButton setImage:[UIImage imageNamed:@"btn_sharepage_friendcircle_highlight"] forState:UIControlStateHighlighted];
    [self.momentButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.momentButton sizeToFit];
    self.momentButton.tag = HTButtonTypeMoment;
    self.momentButton.alpha = 1;
    [_shareView addSubview:self.momentButton];
    
    self.weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.weiboButton setImage:[UIImage imageNamed:@"btn_sharepage_wechat"] forState:UIControlStateNormal];
    [self.weiboButton setImage:[UIImage imageNamed:@"btn_sharepage_wechat_highlight"] forState:UIControlStateHighlighted];
    [self.weiboButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [self.weiboButton sizeToFit];
    self.weiboButton.tag = HTButtonTypeWeibo;
    self.weiboButton.alpha = 1;
    [_shareView addSubview:self.weiboButton];
    
    self.qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.qqButton setImage:[UIImage imageNamed:@"btn_sharepage_qq"] forState:UIControlStateNormal];
    [self.qqButton setImage:[UIImage imageNamed:@"btn_sharepage_qq_highlight"] forState:UIControlStateHighlighted];
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

#pragma mark - Notification

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isAnswered"]) {
        _answerButton.hidden = self.isAnswered;
        if (self.isAnswered == NO) {
            //[_timeView setQuestion:self.currentQuestion type:_type endTime:_endTime];
            _detailScrollView.contentSize = CGSizeMake(self.view.width, SCROLLVIEW_HEIGHT);
            [self.view viewWithTag:100].hidden = NO;
            [self.view viewWithTag:101].hidden = YES;
            [self.view viewWithTag:102].hidden = YES;
            [self.view viewWithTag:103].hidden = YES;
        } else {
            //[_timeView setQuestion:self.currentQuestion type:_type endTime:_endTime];
            _detailScrollView.contentSize = CGSizeMake(self.view.width*4, SCROLLVIEW_HEIGHT);
            [self.view viewWithTag:100].hidden = NO;
            [self.view viewWithTag:101].hidden = NO;
            [self.view viewWithTag:102].hidden = NO;
            [self.view viewWithTag:103].hidden = NO;
        }
    }
}

@end
