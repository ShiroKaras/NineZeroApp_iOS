//
//  SKQuestionViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/7.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKQuestionViewController.h"
#import "HTUIHeader.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "WXApi.h"

#import <CommonCrypto/CommonDigest.h>
#import "SharkfoodMuteSwitchDetector.h"
#import <SSZipArchive/ZipArchive.h>

#import "SKTicketView.h"
#import "SKHintView.h"
#import "SKQuestionRankListView.h"
#import "SKComposeView.h"
#import "SKCardTimeView.h"
#import "SKDescriptionView.h"
#import "SKMascotView.h"
#import "SKQuestionRewardView.h"
#import "SKHelperView.h"
#import "HTARCaptureController.h"
#import "SKAnswerDetailView.h"

#define PADDING (SCREEN_WIDTH-48-ROUND_WIDTH_FLOAT(160))/3
#define TOP_PADDING ROUND_HEIGHT_FLOAT(53)

#define SHARE_URL(u,v) [NSString stringWithFormat:@"https://admin.90app.tv/index.php?s=/Home/user/detail2.html/&area_id=%@&id=%@", (u), [self md5:(v)]]

typedef NS_ENUM(NSInteger, HTButtonType) {
    HTButtonTypeShare = 0,
    HTButtonTypeCancel,
    HTButtonTypeWechat,
    HTButtonTypeMoment,
    HTButtonTypeWeibo,
    HTButtonTypeQQ,
    HTButtonTypeReplay
};

@interface SKQuestionViewController () <SKComposeViewDelegate, SKHelperScrollViewDelegate, HTARCaptureControllerDelegate, SKMascotSkillDelegate>

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isAnswered;
@property (nonatomic, assign) SKQuestionType type;

@property (nonatomic, strong) UIButton  *helpButton;
@property (nonatomic, strong) UIView    *dimmingView;
@property (nonatomic, strong) UILabel   *chapterNumberLabel;
@property (nonatomic, strong) UILabel   *chapterTitleLabel;
@property (nonatomic, strong) UILabel   *chapterSubTitleLabel;

@property (nonatomic, strong) UIView *playBackView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIImageView *soundImageView;
@property (nonatomic, strong) UIImageView *pauseImageView;
@property (nonatomic, strong) UIImageView *triangleImageView;

@property (nonatomic, strong) UIButton *answerButton;

@property (nonatomic, strong) SKCardTimeView *timeView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *toolsView;

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIView *progressBgView;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) SKComposeView *composeView;                     // 答题界面
@property (strong, nonatomic) SKDescriptionView *descriptionView;             // 详情页面
@property (strong, nonatomic) SKAnswerDetailView *answerDetailView;
@property (nonatomic, strong) SKReward *questionReward;
@property (nonatomic, strong) SKQuestion *currentQuestion;
@property (nonatomic, strong) NSArray<SKUserInfo *> *top10Array;
//@property (nonatomic, strong) SKAnswerDetail *answerDetail;
@property (nonatomic, assign) time_t endTime;

//奖励
@property (nonatomic, strong) NSDictionary  *rewardDict;
@property (nonatomic, strong) SKReward      *reward;

@property (nonatomic, assign) NSInteger wrongAnswerCount;

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
@end

@implementation SKQuestionViewController

- (instancetype)initWithType:(SKQuestionType)type questionID:(NSString *)questionID {
    if (self = [super init]) {
        self.currentQuestion = [SKQuestion new];
        _type = type;
        self.currentQuestion.qid = questionID;
    }
    return self;
}

- (instancetype)initWithType:(SKQuestionType)type questionID:(NSString *)questionID endTime:(time_t)endTime{
    if (self = [super init]) {
        self.currentQuestion = [SKQuestion new];
        _type = type;
        self.currentQuestion.qid = questionID;
        _endTime = endTime;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wrongAnswerCount = [[UD dictionaryForKey:kQuestionWrongAnswerCountSeason1][self.currentQuestion.qid] integerValue];
    [self createUI];
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"isAnswered" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.type == SKQuestionTypeTimeLimitLevel) {
        [TalkingData trackPageBegin:@"timelimitpage"];
    } else if (self.type == SKQuestionTypeHistoryLevel) {
        [TalkingData trackPageBegin:@"historylevelpage"];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.type == SKQuestionTypeTimeLimitLevel) {
        [TalkingData trackPageEnd:@"timelimitpage"];
    } else if (self.type == SKQuestionTypeHistoryLevel) {
        [TalkingData trackPageEnd:@"historylevelpage"];
    }
    
    [self stop];
    if (_dimmingView) {
        [self removeDimmingView];
    }
    if (_shareView) {
        [_shareView removeFromSuperview];
    }
    _shareView = nil;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"currentIndex"];
    [self removeObserver:self forKeyPath:@"isAnswered"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [HTProgressHUD show];
    [[[SKServiceManager sharedInstance] questionService] getQuestionDetailWithQuestionID:self.currentQuestion.qid callback:^(BOOL success, SKQuestion *question) {
        [HTProgressHUD dismiss];
        _timeView.hidden = NO;
        _answerButton.hidden = NO;
        
        self.currentQuestion = question;
        self.isAnswered = question.is_answer;
        self.chapterNumberLabel.text = [NSString stringWithFormat:@"%02lu", (long)[question.serial integerValue]];
        self.chapterTitleLabel.text = question.title_one;
        self.chapterSubTitleLabel.text = question.title_two;
        [self createVideoOnView:_playBackView withFrame:CGRectMake(0, 0, _playBackView.width, _playBackView.height)];
        
        if (self.type == SKQuestionTypeTimeLimitLevel) {
            if (self.currentQuestion.base_type == 0) {
                [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_pencil"] forState:UIControlStateNormal];
                [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_pencil_highlight"] forState:UIControlStateHighlighted];
            } else {
                [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_cam"] forState:UIControlStateNormal];
                [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_ans_cam_highlight"] forState:UIControlStateHighlighted];
            }
        } else if (self.type == SKQuestionTypeHistoryLevel) {
            if (self.currentQuestion.base_type == 0) {
                [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_pencil"] forState:UIControlStateNormal];
                [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_pencil_highlight"] forState:UIControlStateHighlighted];
            } else {
                [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_locked"] forState:UIControlStateNormal];
                [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_locked_highlight"] forState:UIControlStateHighlighted];
            }
        }
        
        [[[SKServiceManager sharedInstance] answerService] getRewardWithQuestionID:self.currentQuestion.qid rewardID:self.currentQuestion.reward_id callback:^(BOOL success, SKResponsePackage *response) {
            if (response.result == 0) {
                self.rewardDict = response.data;
                self.reward = [SKReward objectWithKeyValues:self.rewardDict];
            }
        }];
        
        [[[SKServiceManager sharedInstance] questionService] getQuestionTop10WithQuestionID:self.currentQuestion.qid callback:^(BOOL success, NSArray<SKUserInfo *> *userRankList) {
            self.top10Array = userRankList;
        }];
        
        [self loadMascot];
    }];
    
    if (_type == SKQuestionTypeTimeLimitLevel) {
        
    } else if (_type == SKQuestionTypeHistoryLevel) {
        
    }
}

- (void)loadMascot {
    NSString *cacheDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/"]];
    NSString *zipFilePath = [cacheDirectory stringByAppendingPathComponent:self.currentQuestion.question_ar_pet];
    NSString *unzipFilesPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", [self.currentQuestion.question_ar_pet stringByDeletingPathExtension]]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:zipFilePath]) {
        NSURL *localUrl = [NSURL fileURLWithPath:zipFilePath];
        [SSZipArchive unzipFileAtPath:zipFilePath toDestination:unzipFilesPath overwrite:YES password:nil progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
            
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
            
        }];
    } else {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:self.currentQuestion.question_ar_pet_url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSString *cacheDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/"]];
            NSString *zipFilePath = [cacheDirectory stringByAppendingPathComponent:self.currentQuestion.question_ar_pet];
            return [NSURL fileURLWithPath:zipFilePath];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (filePath == nil) return;
            NSURL *localUrl = [NSURL fileURLWithPath:[filePath path]];
            [SSZipArchive unzipFileAtPath:[filePath path] toDestination:unzipFilesPath overwrite:YES password:nil progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                
            } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
                
            }];
        }];
        [downloadTask resume];
    }
}

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    __weak __typeof(self)weakSelf = self;
    
    // 主界面
    if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH) {
        _playBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 138, SCREEN_WIDTH-20, SCREEN_WIDTH-20)];
    } else {
        _playBackView = [[UIView alloc] initWithFrame:CGRectMake(10, ROUND_HEIGHT_FLOAT(122), SCREEN_WIDTH-20, SCREEN_WIDTH-20)];
    }
    _playBackView.layer.masksToBounds = YES;
    _playBackView.contentMode = UIViewContentModeScaleAspectFit;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_playBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _playBackView.bounds;
    maskLayer.path = maskPath.CGPath;
    _playBackView.layer.mask = maskLayer;
    [self.view addSubview:_playBackView];
    
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
    _replayButton.frame = CGRectMake(_replayBackView.width /2 -35 -70, _replayBackView.height / 2 -35, 70, 70);
    _shareButton.frame = CGRectMake(_replayBackView.width / 2 +35, _replayBackView.height / 2 -35, 70, 70);
    
    // 2.3 暂停按钮，静音按钮
    _soundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_mute"]];
    _soundImageView.alpha = 0.32;
    if(SCREEN_WIDTH != IPHONE6_PLUS_SCREEN_WIDTH) {
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
    self.soundImageView.hidden = ![[SharkfoodMuteSwitchDetector shared] isMute];
    
    // 题目标题
    if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(10, _playBackView.bottom, _playBackView.width, 92)];
    } else {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(10, _playBackView.bottom, _playBackView.width, 72)];
    }
    _contentView.backgroundColor = COMMON_SEPARATOR_COLOR;
    [self.view addSubview:_contentView];
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _contentView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    _contentView.layer.mask = maskLayer2;
    
    UITapGestureRecognizer *tap_content = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewClick)];
    tap_content.numberOfTapsRequired = 1;
    [_contentView addGestureRecognizer:tap_content];
    
    UIImageView *chapterImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detailspage_chapter"]];
    [self.view addSubview:chapterImageView];
    chapterImageView.width = 75;
    chapterImageView.height = 27;
    chapterImageView.left = 10;
    chapterImageView.bottom = _playBackView.top -6;
    
    _chapterNumberLabel = [UILabel new];
    _chapterNumberLabel.textColor = COMMON_PINK_COLOR;
    _chapterNumberLabel.text = @"00";
    _chapterNumberLabel.font = MOON_FONT_OF_SIZE(14);
    [_chapterNumberLabel sizeToFit];
    _chapterNumberLabel.center = chapterImageView.center;
    [self.view addSubview:_chapterNumberLabel];
    
    _chapterTitleLabel = [UILabel new];
    _chapterTitleLabel.textColor = COMMON_PINK_COLOR;
    _chapterTitleLabel.font = PINGFANG_FONT_OF_SIZE(14);
    [_chapterTitleLabel sizeToFit];
    [self.view addSubview:_chapterTitleLabel];
    if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH) {
        [_chapterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView.mas_left).offset(12);
            make.top.equalTo(_contentView.mas_top).offset(20);
        }];
    } else {
        [_chapterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView.mas_left).offset(12);
            make.top.equalTo(_contentView.mas_top).offset(13);
        }];
    }
    
    _chapterSubTitleLabel = [UILabel new];
    _chapterSubTitleLabel.textColor = COMMON_GREEN_COLOR;
    _chapterSubTitleLabel.font = PINGFANG_FONT_OF_SIZE(14);
    [self.view addSubview:_chapterSubTitleLabel];
    if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH) {
        [_chapterSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView.mas_left).offset(12);
            make.top.equalTo(_chapterTitleLabel.mas_bottom).offset(12);
        }];
    } else {
        [_chapterSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView.mas_left).offset(12);
            make.top.equalTo(_chapterTitleLabel.mas_bottom).offset(5);
        }];
    }
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detailspage_detail"]];
    [self.view addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_chapterTitleLabel.mas_right).offset(4);
        make.centerY.equalTo(_chapterTitleLabel.mas_centerY);
    }];
    
    _answerButton = [UIButton new];
    _answerButton.hidden = YES;
    [_answerButton addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_pencil"] forState:UIControlStateNormal];
    [_answerButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_pencil_highlight"] forState:UIControlStateHighlighted];
    [_answerButton sizeToFit];
    [self.view addSubview:_answerButton];
    [_answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentView.mas_right).offset(-16);
        make.centerY.equalTo(_contentView.mas_bottom);
    }];
    
    _triangleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_detailspage_triangle"]];
    [_triangleImageView sizeToFit];
    [self.view addSubview:_triangleImageView];
    
    // 倒计时
    _timeView = [[SKCardTimeView alloc] initWithFrame:CGRectZero];
    _timeView.hidden = YES;
    [self.view addSubview:_timeView];
    
    _timeView.size = CGSizeMake(ROUND_WIDTH_FLOAT(150), ROUND_HEIGHT_FLOAT(96));
    _timeView.right = SCREEN_WIDTH - 10;
    _timeView.bottom = _playBackView.top -6;
    
    // 帮助按钮
    _helpButton = [UIButton new];
    [_helpButton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_helpButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_help"] forState:UIControlStateNormal];
    [_helpButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_help_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:_helpButton];
    [_helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(@12);
        make.right.equalTo(weakSelf.view.mas_right).offset(-4);
    }];
    
    //底部按钮组
    NSArray *buttonsNameArray = @[@"puzzle", @"key", @"top", @"gift", @"tools"];
    self.currentIndex = 0;
    for (int i = 0; i<5; i++) {
        UIButton *btn = [UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_detailspage_%@", buttonsNameArray[i]]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_detailspage_%@_highlight", buttonsNameArray[i]]] forState:UIControlStateHighlighted];
        btn.tag = 200+i;
        btn.hidden = YES;
        [btn addTarget:self action:@selector(bottomButtonsClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if (i<4) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(ROUND_WIDTH(40));
                make.height.equalTo(ROUND_WIDTH(40));
                make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-(SCREEN_HEIGHT-ROUND_HEIGHT_FLOAT(122)-SCREEN_WIDTH+20-72-12-ROUND_WIDTH_FLOAT(40))/2);
                make.left.equalTo(@(24+(ROUND_WIDTH_FLOAT(40)+PADDING)*i));
            }];
            if (i==0) {
                btn.hidden = NO;
                [_triangleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_contentView.mas_bottom).offset(-1);
                    make.centerX.equalTo(btn.mas_centerX);
                }];
            }
        } else {
            //道具按钮
            if (_type == SKQuestionTypeTimeLimitLevel) {
                btn.hidden = YES;
            } else if (_type ==  SKQuestionTypeHistoryLevel) {
                btn.hidden = NO;
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(ROUND_WIDTH(40));
                    make.height.equalTo(ROUND_WIDTH(40));
                    make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-(SCREEN_HEIGHT-ROUND_HEIGHT_FLOAT(122)-SCREEN_WIDTH+20-72-12-ROUND_WIDTH_FLOAT(40))/2);
                    make.left.equalTo(@(24+(ROUND_WIDTH_FLOAT(40)+PADDING)*1));
                }];
            }
        }
    }
    
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
        _downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:self.currentQuestion.question_video];
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
            _playerLayer.frame = frame;
            [backView.layer insertSublayer:_playerLayer atIndex:0];
            [self.view setNeedsLayout];
        }];
        [_downloadTask resume];
        [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
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
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_play"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_play_highlight" ] forState:UIControlStateHighlighted];
    [_playButton sizeToFit];
    _playButton.center = backView.center;
    _playButton.hidden = NO;
    [self.view addSubview:_playButton];
}

#pragma mark - Tools View

//气泡：选择道具
- (void)createToolsViewWithButton:(UIButton *)button {
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = COMMON_BG_COLOR;
    alphaView.alpha = 0.6;
    [_dimmingView addSubview:alphaView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
    tap.numberOfTapsRequired = 1;
    [_dimmingView addGestureRecognizer:tap];
    
    UIImageView *toolImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_tools_highlight"]];
    [_dimmingView addSubview:toolImageView];
    toolImageView.frame = button.frame;
    
    [self.view bringSubviewToFront:_triangleImageView];
    
    UIView *toolBackView = [UIView new];
    toolBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    toolBackView.layer.cornerRadius = 5;
    [_dimmingView addSubview:toolBackView];
    [toolBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_contentView.mas_bottom);
        make.left.equalTo(@10);
        make.height.equalTo(@94);
        make.width.equalTo(@188);
    }];
    
    UIButton *toolHintButton = [UIButton new];
    [toolHintButton addTarget:self action:@selector(hintButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolHintButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_clue"] forState:UIControlStateNormal];
    [toolHintButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_clue_highlight"] forState:UIControlStateHighlighted];
    [toolBackView addSubview:toolHintButton];
    [toolHintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@27);
        make.top.equalTo(@18);
    }];
    
    UIButton *toolAnswerButton = [UIButton new];
    [toolAnswerButton addTarget:self action:@selector(answerPropButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolAnswerButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_solution"] forState:UIControlStateNormal];
    [toolAnswerButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_solution_highlight"] forState:UIControlStateHighlighted];
    [toolBackView addSubview:toolAnswerButton];
    [toolAnswerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-27));
        make.top.equalTo(@18);
    }];
}

- (void)createHintView {
    SKHintView *hintView = [[SKHintView alloc] initWithFrame:self.view.bounds questionID:self.currentQuestion season:self.season];
    [self.view addSubview:hintView];
    hintView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        hintView.alpha = 1;
    }];
}

- (void)showAnswerPropAlertView {
    [TalkingData trackEvent:@"props"];
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
    tap.numberOfTapsRequired = 1;
    [_dimmingView addGestureRecognizer:tap];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = COMMON_BG_COLOR;
    alphaView.alpha = 0.9;
    [_dimmingView addSubview:alphaView];
    
    UIView *alertBackView = [UIView new];
    alertBackView.layer.cornerRadius = 3;
    alertBackView.layer.masksToBounds = YES;
    alertBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    [_dimmingView addSubview:alertBackView];
    [alertBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@270);
        make.height.equalTo(@146);
        make.center.equalTo(_dimmingView);
    }];
    
    UILabel *titleLabel = [UILabel new];
    if (self.currentQuestion.num==0) {
        titleLabel.text = [NSString stringWithFormat:@"第%ld季答案道具已耗尽，请购买补充",(unsigned long)self.season];
    } else {
        titleLabel.text = @"确定要使用答案道具通过本关吗？";
    }
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = PINGFANG_FONT_OF_SIZE(14);
    [titleLabel sizeToFit];
    [alertBackView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertBackView);
        make.top.equalTo(alertBackView).offset(17);
    }];
    
    
    UIImageView *iconImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_popup_solution_season%lu",(unsigned long)self.season]]];
    [iconImageview sizeToFit];
    [alertBackView addSubview:iconImageview];
    [iconImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.centerX.equalTo(alertBackView).offset(-29);
    }];
    
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_popup_solution_text"]];
    [textImageView sizeToFit];
    [alertBackView addSubview:textImageView];
    [textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageview.mas_right).offset(4);
        make.centerY.equalTo(iconImageview);
    }];
    
    UILabel *propCountLabel = [UILabel new];
    propCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentQuestion.num];
    propCountLabel.textColor = [UIColor whiteColor];
    propCountLabel.font = MOON_FONT_OF_SIZE(18);
    [propCountLabel sizeToFit];
    [alertBackView addSubview:propCountLabel];
    [propCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textImageView.mas_right).offset(4);
        make.centerY.equalTo(textImageView);
    }];
    
    //取消按钮
    UIButton *cancelButton = [UIButton new];
    [cancelButton addTarget:self action:@selector(cancelButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [cancelButton addTarget:self action:@selector(cancelButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton addTarget:self action:@selector(cancelButtonTouchExit:) forControlEvents:UIControlEventTouchDragExit];
    cancelButton.backgroundColor = alertBackView.backgroundColor;
    cancelButton.layer.cornerRadius = 3;
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    cancelButton.titleLabel.font = PINGFANG_FONT_OF_SIZE(14);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (_season == 1)   [cancelButton setTitleColor:COMMON_GREEN_COLOR forState:UIControlStateHighlighted];
    else if (_season == 2)  [cancelButton setTitleColor:COMMON_PINK_COLOR forState:UIControlStateHighlighted];
    [alertBackView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 42));
        make.left.equalTo(alertBackView).offset(10);
        make.bottom.equalTo(alertBackView).offset(-10);
    }];
    
    if (self.currentQuestion.num>0) {
        //使用道具
        UIButton *usePropButton = [UIButton new];
        [usePropButton addTarget:self action:@selector(usePropButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.season == 1) {
            [usePropButton setBackgroundImage:[UIImage imageWithColor:COMMON_GREEN_COLOR] forState:UIControlStateNormal];
            [usePropButton setBackgroundImage:[UIImage imageWithColor:COMMON_PINK_COLOR] forState:UIControlStateHighlighted];
        } else if (self.season == 2) {
            [usePropButton setBackgroundImage:[UIImage imageWithColor:COMMON_PINK_COLOR] forState:UIControlStateNormal];
            [usePropButton setBackgroundImage:[UIImage imageWithColor:COMMON_GREEN_COLOR] forState:UIControlStateHighlighted];
        }
        usePropButton.layer.cornerRadius = 3;
        usePropButton.layer.masksToBounds = YES;
        usePropButton.titleLabel.font = PINGFANG_FONT_OF_SIZE(14);
        [usePropButton setTitle:@"使用道具" forState:UIControlStateNormal];
        [usePropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [usePropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [alertBackView addSubview:usePropButton];
        [usePropButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(120, 42));
            make.right.equalTo(alertBackView).offset(-10);
            make.bottom.equalTo(alertBackView).offset(-10);
        }];
    } else {
        //购买道具
        UIButton *purchPropButton = [UIButton new];
        [purchPropButton addTarget:self action:@selector(purchasePropButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [purchPropButton setBackgroundImage:[UIImage imageWithColor:COMMON_RED_COLOR] forState:UIControlStateNormal];
        [purchPropButton setBackgroundImage:[UIImage imageWithColor:COMMON_GREEN_COLOR] forState:UIControlStateHighlighted];
        purchPropButton.layer.cornerRadius = 3;
        purchPropButton.layer.masksToBounds = YES;
        purchPropButton.titleLabel.font = PINGFANG_FONT_OF_SIZE(14);
        [purchPropButton setTitle:@"去购买" forState:UIControlStateNormal];
        [purchPropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [purchPropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        purchPropButton.backgroundColor = [UIColor colorWithHex:0xed203b];
        [alertBackView addSubview:purchPropButton];
        [purchPropButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(120, 42));
            make.right.equalTo(alertBackView).offset(-10);
            make.bottom.equalTo(alertBackView).offset(-10);
        }];
    }
    
}

//取消
- (void)cancelButtonOnClick:(UIButton*)sender {
    [self removeDimmingView];
}

- (void)cancelButtonTouchDown:(UIButton*)sender {
    switch (_season) {
        case 1:
            sender.layer.borderColor = COMMON_GREEN_COLOR.CGColor;
            break;
        case 2:
            sender.layer.borderColor = COMMON_PINK_COLOR.CGColor;
            break;
        default:
            break;
    }
}

- (void)cancelButtonTouchExit:(UIButton*)sender {
    sender.layer.borderColor = [UIColor whiteColor].CGColor;
}

//使用答案道具
- (void)usePropButtonOnClick:(UIButton*)sender {
    [TalkingData trackEvent:@"answerprops"];
    for (UIView *view in _dimmingView.subviews) {
        [view removeFromSuperview];
    }
    
    [[[SKServiceManager sharedInstance] answerService] answerExpiredTextQuestionWithQuestionID:self.currentQuestion.qid answerPropsCount:[NSString stringWithFormat:@"%ld",(long)self.currentQuestion.num] callback:^(BOOL success, SKResponsePackage *response) {
        if (response.result == 0) {
            //回答正确
            [self.delegate answeredQuestionWithSerialNumber:self.currentQuestion.serial season:self.currentQuestion.level_type];
            self.currentQuestion.is_answer = YES;
            self.isAnswered = YES;
            
            self.rewardDict = response.data;
            self.reward = [SKReward objectWithKeyValues:self.rewardDict];
            
            UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
            alphaView.backgroundColor = COMMON_BG_COLOR;
            alphaView.alpha = 0.9;
            [_dimmingView addSubview:alphaView];
            
            NSMutableArray<UIImage *> *animatedImages = [NSMutableArray arrayWithCapacity:21];
            for (int i = 0; i != 21; i++) {
                [animatedImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"right_answer_gif_%04d", i]]];
            }
            UIImageView *resultImageView = [UIImageView new];
            [_dimmingView addSubview:resultImageView];
            [resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@165);
                make.height.equalTo(@165);
                make.center.equalTo(_dimmingView);
            }];
            resultImageView.animationDuration = 1.05f;
            resultImageView.animationRepeatCount = 1;
            resultImageView.animationImages = animatedImages;
            [resultImageView startAnimating];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeDimmingView];
                [self showRewardViewWithReward:nil];
            });
        } else if (response.result == -3004) {
            //回答错误
            [_composeView showAnswerCorrect:NO];
        } else if (response.result == -7007) {
            
        }
    }];
}

//购买道具
- (void)purchasePropButtonOnClick:(UIButton*)sender {
    [_dimmingView removeFromSuperview];
    SKMascotSkillView *purchaseView = [[SKMascotSkillView alloc] initWithFrame:self.view.bounds Type:SKMascotTypeDefault isHad:YES];
    purchaseView.alpha = 0;
    purchaseView.delegate = self;
    [self.view addSubview:purchaseView];
    [UIView animateWithDuration:0.3 animations:^{
        purchaseView.alpha = 1;
    }];
}

#pragma mark - MascotSkillViewDelegate

- (void)didClickCloseButtonMascotSkillView:(SKMascotSkillView *)view {
    [[[SKServiceManager sharedInstance] questionService] getQuestionDetailWithQuestionID:self.currentQuestion.qid callback:^(BOOL success, SKQuestion *question) {
        self.currentQuestion = question;
    }];
}

#pragma mark - Answer View

- (void)createAnswerViewWithButton:(UIButton*)button answer:(NSDictionary *)answer {
    _dimmingView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_PADDING, SCREEN_WIDTH, _contentView.bottom-TOP_PADDING)];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UIView *answerBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, _contentView.bottom-10-TOP_PADDING)];
    answerBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    answerBackView.layer.cornerRadius = 5;
    answerBackView.layer.masksToBounds = YES;
    [_dimmingView addSubview:answerBackView];
    
    UIImageView *answerButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_key_highlight"]];
    [_dimmingView addSubview:answerButtonImageView];
    [answerButtonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(button);
        make.center.equalTo(button);
    }];
    
    if (self.answerDetailView == nil) {
        self.answerDetailView = [[SKAnswerDetailView alloc] initWithFrame:CGRectMake(0, 0, answerBackView.width, answerBackView.height) questionID:self.currentQuestion.qid];
    }
    [answerBackView addSubview:self.answerDetailView];
    
    UIImageView *dimmingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detailspage_success_shading_down"]];
    dimmingImageView.width = answerBackView.width;
    dimmingImageView.height = dimmingImageView.width/300*84;
    dimmingImageView.bottom = answerBackView.bottom;
    [answerBackView addSubview:dimmingImageView];
}

#pragma mark - Rank View

- (void)createRankViewWithButton:(UIButton*)button {
    _dimmingView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_PADDING, SCREEN_WIDTH, _contentView.bottom-TOP_PADDING)];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    SKQuestionRankListView *rankView = [[SKQuestionRankListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, _contentView.bottom-10) rankerList:self.top10Array withButton:button];
    [_dimmingView addSubview:rankView];
}

#pragma mark - Gift View

- (void)createGiftViewWithButton:(UIButton*)button reward:(NSDictionary*)reward ticket:(NSDictionary*)ticket {
    BOOL isTicket = self.reward.ticket==nil?NO:YES;
    
    _dimmingView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_PADDING, SCREEN_WIDTH, _contentView.bottom-TOP_PADDING)];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    //rewardBackView
    UIView *rewardBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, _contentView.bottom-10-TOP_PADDING)];
    rewardBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    rewardBackView.layer.cornerRadius = 5;
    [_dimmingView addSubview:rewardBackView];
    
    UIImageView *giftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_gift_highlight"]];
    [_dimmingView addSubview:giftImageView];
    [giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(button);
        make.center.equalTo(button);
    }];
    
    //Ticket
    SKTicketView *card;
    if (isTicket) {
        if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH) {
            card = [[SKTicketView alloc] initWithFrame:CGRectMake(0, 0, 362, 140) reward:self.reward.ticket];
            [rewardBackView addSubview:card];
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(362));
                make.height.equalTo(@(140));
                make.centerX.equalTo(rewardBackView);
                make.bottom.equalTo(rewardBackView.mas_bottom).offset(-15);
            }];
        } else if (SCREEN_WIDTH == IPHONE6_SCREEN_WIDTH) {
            card = [[SKTicketView alloc] initWithFrame:CGRectMake(0, 0, 335, 130) reward:self.reward.ticket];
            [rewardBackView addSubview:card];
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@335);
                make.height.equalTo(@130);
                make.centerX.equalTo(rewardBackView);
                make.bottom.equalTo(rewardBackView.mas_bottom).offset(-10);
            }];
        } else if (SCREEN_WIDTH == IPHONE5_SCREEN_WIDTH) {
            card = [[SKTicketView alloc] initWithFrame:CGRectMake(0, 0, 280, 108) reward:self.reward.ticket];
            [rewardBackView addSubview:card];
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@280);
                make.height.equalTo(@108);
                make.centerX.equalTo(rewardBackView);
                make.bottom.equalTo(rewardBackView.mas_bottom).offset(-10);
            }];
        }
    }
    
    UIView *rewardBaseInfoView = [UIView new];
    rewardBaseInfoView.backgroundColor = [UIColor clearColor];
    [rewardBackView addSubview:rewardBaseInfoView];
    [rewardBaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@248);
        make.height.equalTo(@294);
        make.centerX.equalTo(rewardBackView);
        if (isTicket)   make.top.equalTo(@((rewardBackView.height-card.height-294-20)/2));
        else            make.top.equalTo(@((rewardBackView.height-294)/2));
    }];
    
    [self createRewardBaseInfoWithBaseInfoView:rewardBaseInfoView];
}

- (void)createRewardBaseInfoWithBaseInfoView:(UIView*)rewardBaseInfoView {
    UIImageView *rewardImageView_mascot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_mascot"]];
    [rewardBaseInfoView addSubview:rewardImageView_mascot];
    [rewardImageView_mascot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@139);
        make.height.equalTo(@146);
        make.top.equalTo(rewardBaseInfoView.mas_top);
        make.right.equalTo(rewardBaseInfoView.mas_right);
    }];
    
    //rank小于10，数字
    UIImageView *rewardImageView_txt_top10_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_1-10_txt_1"]];
    UIImageView *rewardImageView_txt_top10_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_1-10_txt_2"]];
    UIImageView *rewardImageView_txt_top10_3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_1-10_txt_3"]];
    
    //rank大于10，百分比
    UIImageView *rewardImageView_txt_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_1"]];
    UIImageView *rewardImageView_txt_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_2"]];
    
    //金币行
    UIImageView *rewardImageView_txt_3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_3"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_3];
    
    if (self.reward.rank<10) {
        [rewardBaseInfoView addSubview:rewardImageView_txt_top10_1];
        [rewardBaseInfoView addSubview:rewardImageView_txt_top10_2];
        [rewardBaseInfoView addSubview:rewardImageView_txt_top10_3];
        
        [rewardImageView_txt_top10_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(105, 60));
            make.top.equalTo(rewardBaseInfoView).offset(120);
            make.left.equalTo(rewardBaseInfoView);
        }];
        
        UILabel *rankLabel = [UILabel new];
        rankLabel.font = MOON_FONT_OF_SIZE(32.5);
        rankLabel.textColor = COMMON_GREEN_COLOR;
        rankLabel.text = [NSString stringWithFormat:@"%ld", self.reward.rank];
        [rankLabel sizeToFit];
        [rewardBaseInfoView addSubview:rankLabel];
        [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rewardImageView_txt_top10_1.mas_right).offset(4);
            make.top.equalTo(rewardImageView_mascot.mas_bottom).offset(8);
        }];
        
        [rewardImageView_txt_top10_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24, 24));
            make.left.equalTo(rankLabel.mas_right).offset(4);
            make.bottom.equalTo(rewardImageView_txt_top10_1);
        }];
        
        [rewardImageView_txt_top10_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(138, 24));
            make.top.equalTo(rewardBaseInfoView).offset(217-24);
            make.right.equalTo(rewardBaseInfoView).offset(-27);
        }];
        
        [rewardImageView_txt_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
            make.height.equalTo(@19);
            if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH) {
                make.top.equalTo(rewardImageView_txt_top10_3.mas_bottom).offset(20);
            } else {
                make.top.equalTo(rewardImageView_txt_top10_3.mas_bottom).offset(10);
            }
            make.left.equalTo(rewardBaseInfoView);
        }];
    } else {
        [rewardBaseInfoView addSubview:rewardImageView_txt_1];
        [rewardBaseInfoView addSubview:rewardImageView_txt_2];
        
        [rewardImageView_txt_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@105);
            make.height.equalTo(@60);
            make.top.equalTo(rewardBaseInfoView).offset(121);
            make.left.equalTo(rewardBaseInfoView);
        }];
        
        [rewardImageView_txt_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@111);
            make.height.equalTo(@24);
            make.left.equalTo(rewardBaseInfoView).offset(106);
            make.top.equalTo(rewardBaseInfoView).offset(217-24);
        }];
        
        //百分比
        UILabel *percentLabel = [UILabel new];
        percentLabel.font = MOON_FONT_OF_SIZE(32.5);
        percentLabel.textColor = COMMON_GREEN_COLOR;
        percentLabel.text = [[NSString stringWithFormat:@"%.1lf", 100. - self.reward.rank/10.] stringByAppendingString:@"%"];
        if (self.reward.rank >= 700) {
            percentLabel.text = @"30%";
        }
        [percentLabel sizeToFit];
        [rewardBaseInfoView addSubview:percentLabel];
        [percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rewardImageView_txt_1.mas_right).offset(4);
            make.top.equalTo(rewardImageView_mascot.mas_bottom).offset(8);
        }];
        
        [rewardImageView_txt_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100);
            make.height.equalTo(@19);
            if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH) {
                make.top.equalTo(rewardImageView_txt_2.mas_bottom).offset(20);
            } else {
                make.top.equalTo(rewardImageView_txt_2.mas_bottom).offset(10);
            }
            make.left.equalTo(rewardBaseInfoView);
        }];
    }
    
    
    
    UILabel *coinCountLabel = [UILabel new];
    coinCountLabel.textColor = COMMON_RED_COLOR;
    coinCountLabel.text = self.reward.gold;
    coinCountLabel.font = MOON_FONT_OF_SIZE(19);
    [coinCountLabel sizeToFit];
    [rewardBaseInfoView addSubview:coinCountLabel];
    [coinCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardImageView_txt_3.mas_right).offset(6);
        make.centerY.equalTo(rewardImageView_txt_3);
    }];
    
    UIImageView *rewardImageView_txt_gold = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_goldtext"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_gold];
    [rewardImageView_txt_gold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@37);
        make.height.equalTo(@19);
        make.left.equalTo(coinCountLabel.mas_right).offset(6);
        make.centerY.equalTo(coinCountLabel);
    }];
    
    //经验值行
    UIImageView *rewardImageView_exp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_exp"]];
    rewardImageView_exp.hidden = ![self.reward.experience_value boolValue];
    [rewardBaseInfoView addSubview:rewardImageView_exp];
    [rewardImageView_exp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@18);
        make.height.equalTo(@18);
        if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH) {
            make.top.equalTo(rewardImageView_txt_3.mas_bottom).offset(9);
        } else {
            make.top.equalTo(rewardImageView_txt_3.mas_bottom).offset(6);
        }
        make.right.equalTo(rewardImageView_txt_3);
    }];
    
    UILabel *expCountLabel = [UILabel new];
    expCountLabel.hidden = ![self.reward.experience_value boolValue];
    expCountLabel.textColor = COMMON_RED_COLOR;
    expCountLabel.text = self.reward.experience_value;
    expCountLabel.font = MOON_FONT_OF_SIZE(19);
    [expCountLabel sizeToFit];
    [rewardBaseInfoView addSubview:expCountLabel];
    [expCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardImageView_exp.mas_right).offset(6);
        make.centerY.equalTo(rewardImageView_exp);
    }];
    
    UIImageView *rewardImageView_txt_exp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_exptext"]];
    rewardImageView_txt_exp.hidden = ![self.reward.experience_value boolValue];
    [rewardBaseInfoView addSubview:rewardImageView_txt_exp];
    [rewardImageView_txt_exp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@56);
        make.height.equalTo(@19);
        make.left.equalTo(expCountLabel.mas_right).offset(6);
        make.centerY.equalTo(expCountLabel);
    }];
    
    //宝石行
    UIImageView *rewardImageView_diamond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_monds"]];
    rewardImageView_diamond.hidden = ![self.reward.gemstone boolValue];
    [rewardBaseInfoView addSubview:rewardImageView_diamond];
    [rewardImageView_diamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@18);
        make.height.equalTo(@18);
        if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH) {
            make.top.equalTo(rewardImageView_exp.mas_bottom).offset(9);
        } else {
            make.top.equalTo(rewardImageView_exp.mas_bottom).offset(6);
        }
        make.right.equalTo(rewardImageView_exp);
    }];
    
    UILabel *diamondCountLabel = [UILabel new];
    diamondCountLabel.hidden = ![self.reward.gemstone boolValue];
    diamondCountLabel.textColor = COMMON_RED_COLOR;
    diamondCountLabel.text = self.reward.gemstone;
    diamondCountLabel.font = MOON_FONT_OF_SIZE(19);
    [diamondCountLabel sizeToFit];
    [rewardBaseInfoView addSubview:diamondCountLabel];
    [diamondCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardImageView_diamond.mas_right).offset(6);
        make.centerY.equalTo(rewardImageView_diamond);
    }];
    
    UIImageView *rewardImageView_txt_diamond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_mondstext"]];
    rewardImageView_txt_diamond.hidden = ![self.reward.gemstone boolValue];
    [rewardBaseInfoView addSubview:rewardImageView_txt_diamond];
    [rewardImageView_txt_diamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@38);
        make.height.equalTo(@19);
        make.left.equalTo(diamondCountLabel.mas_right).offset(6);
        make.centerY.equalTo(diamondCountLabel);
    }];
}

#pragma mark - 获取奖励

- (void)showRewardViewWithReward:(SKReward*)reward {
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0;
    [_dimmingView addSubview:alphaView];
    
    [UIView animateWithDuration:0.3 animations:^{
        alphaView.alpha = 0.9;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
    tap.numberOfTapsRequired = 1;
    [_dimmingView addGestureRecognizer:tap];
    
    UIView *rewardBaseInfoView = [UIView new];
    rewardBaseInfoView.backgroundColor = [UIColor clearColor];
    [_dimmingView addSubview:rewardBaseInfoView];
    
    UILabel *bottomLabel = [UILabel new];
    bottomLabel.text = @"点击任意区域关闭";
    bottomLabel.textColor = [UIColor colorWithHex:0xa2a2a2];
    bottomLabel.font = PINGFANG_FONT_OF_SIZE(12);
    [bottomLabel sizeToFit];
    [_dimmingView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_dimmingView);
        make.bottom.equalTo(_dimmingView).offset(-16);
    }];
    
    if (self.reward.ticket != nil) {
        if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH) {
            SKTicketView *card = [[SKTicketView alloc] initWithFrame:CGRectMake(0, 0, 362, 140) reward:self.reward.ticket];
            [_dimmingView addSubview:card];
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@362);
                make.height.equalTo(@140);
                make.centerX.equalTo(rewardBaseInfoView);
                make.bottom.equalTo(_dimmingView).offset(-62);
            }];
            
            [rewardBaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@248);
                make.height.equalTo(@294);
                make.centerX.equalTo(_dimmingView);
                make.top.equalTo(@((_dimmingView.height-card.height-294-62)/2));
            }];
            [self createRewardBaseInfoWithBaseInfoView:rewardBaseInfoView];
        } else {
            SKTicketView *card = [[SKTicketView alloc] initWithFrame:CGRectMake(0, 0, 280, 108) reward:self.reward.ticket];
            [_dimmingView addSubview:card];
            [card mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@280);
                make.height.equalTo(@108);
                make.centerX.equalTo(rewardBaseInfoView);
                make.bottom.equalTo(_dimmingView.mas_bottom).offset(-(_dimmingView.height-320-108)/2);
            }];
            
            [rewardBaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@248);
                make.height.equalTo(@294);
                make.centerX.equalTo(_dimmingView);
                make.top.equalTo(@((_dimmingView.height-card.height-294-62)/2));
            }];
            [self createRewardBaseInfoWithBaseInfoView:rewardBaseInfoView];
        }
    } else {
        [rewardBaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@248);
            make.height.equalTo(@294);
            make.centerX.equalTo(_dimmingView);
            make.centerY.equalTo(_dimmingView);
        }];
        
        [self createRewardBaseInfoWithBaseInfoView:rewardBaseInfoView];
    }
    
    if (self.reward.pet) {
        [_dimmingView removeGestureRecognizer:tap];
        UITapGestureRecognizer *tap_showMascot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMascotViewWithReward:)];
        tap_showMascot.numberOfTapsRequired = 1;
        [_dimmingView addGestureRecognizer:tap_showMascot];
    } else {
        if (self.reward.piece) {
            [_dimmingView removeGestureRecognizer:tap];
            UITapGestureRecognizer *tap_showThing = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showThingViewWithReward:)];
            tap_showThing.numberOfTapsRequired = 1;
            [_dimmingView addGestureRecognizer:tap_showThing];
        }
    }
}

- (void)createMascotRewardViewWithReward:(SKReward*)reward {
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0;
    [_dimmingView addSubview:alphaView];
    
    [UIView animateWithDuration:0.3 animations:^{
        alphaView.alpha = 0.9;
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    if (IPHONE5_SCREEN_WIDTH == SCREEN_WIDTH) {
        bgImageView.image = [UIImage imageNamed:@"img_img_popup_giftbg_640"];
    } else if (IPHONE6_SCREEN_WIDTH == SCREEN_WIDTH) {
        bgImageView.image = [UIImage imageNamed:@"img_img_popup_giftbg_750"];
    } else if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH){
        bgImageView.image = [UIImage imageNamed:@"img_img_popup_giftbg_1242"];
    }
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.frame = _dimmingView.frame;
    [_dimmingView addSubview:bgImageView];
    
    UIImageView *mascotImageView = [UIImageView new];
    mascotImageView.contentMode = UIViewContentModeScaleAspectFit;
    [mascotImageView sd_setImageWithURL:[NSURL URLWithString:self.reward.pet.pet_gif]];
    [_dimmingView addSubview:mascotImageView];
    [mascotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH-32);
        make.height.mas_equalTo(SCREEN_WIDTH-32);
        make.top.equalTo(_dimmingView.mas_top).offset(94);
        make.centerX.equalTo(_dimmingView);
    }];
    
    UIImageView *contentImageView = [[UIImageView alloc] init];
    if ([self.reward.pet.fid integerValue]==0) {
        contentImageView.image = [UIImage imageNamed:@"img_popup_gifttext"];
        GET_NEW_MASCOT;
    } else {
        contentImageView.image = [UIImage imageNamed:@"img_popup_gifttext3"];
    }
    [contentImageView sizeToFit];
    [_dimmingView addSubview:contentImageView];
    [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mascotImageView.mas_bottom).offset(14);
        make.centerX.equalTo(_dimmingView);
    }];
    
    UILabel *bottomLabel = [UILabel new];
    bottomLabel.text = @"点击任意区域关闭";
    bottomLabel.textColor = [UIColor colorWithHex:0xa2a2a2];
    bottomLabel.font = PINGFANG_FONT_OF_SIZE(12);
    [bottomLabel sizeToFit];
    [_dimmingView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_dimmingView);
        make.bottom.equalTo(_dimmingView).offset(-16);
    }];
    
    if (self.reward.piece) {
        UITapGestureRecognizer *tap_showThing = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showThingViewWithReward:)];
        tap_showThing.numberOfTapsRequired = 1;
        [_dimmingView addGestureRecognizer:tap_showThing];
    } else {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
        tap.numberOfTapsRequired = 1;
        [_dimmingView addGestureRecognizer:tap];
    }
}

- (void)createThingRewardViewWithReward:(SKReward*)reward {
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0;
    [_dimmingView addSubview:alphaView];
    
    [UIView animateWithDuration:0.3 animations:^{
        alphaView.alpha = 0.9;
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_popup_giftbg"]];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.frame = _dimmingView.frame;
    bgImageView.top = _dimmingView.top-30;
    [_dimmingView addSubview:bgImageView];
    
    UIImageView *thingImageView = [UIImageView new];
    [thingImageView sd_setImageWithURL:[NSURL URLWithString:self.reward.piece.piece_describe_pic]];
    [_dimmingView addSubview:thingImageView];
    [thingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH-32);
        make.height.mas_equalTo(SCREEN_WIDTH-32);
        make.top.equalTo(_dimmingView.mas_top).offset(94);
        make.centerX.equalTo(_dimmingView);
    }];
    
    UIImageView *contentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_popup_gifttext2"]];
    [contentImageView sizeToFit];
    [_dimmingView addSubview:contentImageView];
    [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thingImageView.mas_bottom).offset(14);
        make.centerX.equalTo(_dimmingView);
    }];
    
    UILabel *bottomLabel = [UILabel new];
    bottomLabel.text = @"点击任意区域关闭";
    bottomLabel.textColor = [UIColor colorWithHex:0xa2a2a2];
    bottomLabel.font = PINGFANG_FONT_OF_SIZE(12);
    [bottomLabel sizeToFit];
    [_dimmingView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_dimmingView);
        make.bottom.equalTo(_dimmingView).offset(-16);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
    tap.numberOfTapsRequired = 1;
    [_dimmingView addGestureRecognizer:tap];
}

- (void)showMascotViewWithReward:(SKReward*)reward {
    [self removeDimmingView];
    [self createMascotRewardViewWithReward:reward];
}

- (void)showThingViewWithReward:(SKReward*)reward {
    [self removeDimmingView];
    [self createThingRewardViewWithReward:reward];
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
    [UIView animateWithDuration:0.3 animations:^{
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

- (void)setSoundHidden:(BOOL)soundHidden {
    self.soundImageView.hidden = soundHidden;
}

#pragma mark - Button Click

- (void)bottomButtonsClick:(UIButton *)sender {
    for (UIView *view in _dimmingView.subviews       ) {
        [view removeFromSuperview];
    }
    [_dimmingView removeFromSuperview];
    self.currentIndex = sender.tag - 200;
    switch (sender.tag) {
        case 200: {
            break;
        }
        case 201: {
            [self createAnswerViewWithButton:sender answer:nil];
            break;
        }
        case 202: {
            [self createRankViewWithButton:sender];
            break;
        }
        case 203: {
            [self createGiftViewWithButton:sender reward:nil ticket:nil];
            break;
        }
        case 204: {
            [self createToolsViewWithButton:sender];
            break;
        }
        default:
            break;
    }
}

- (void)removeDimmingView {
    [_dimmingView removeFromSuperview];
    _dimmingView = nil;
    self.currentIndex = 0;
}

- (void)removeDimmingView2 {
    [_dimmingView removeFromSuperview];
    _dimmingView = nil;
}

- (void)hintButtonClick:(UIButton *)sender {
    [self removeDimmingView];
    [self createHintView];
}

- (void)answerPropButtonClick:(UIButton *)sender {
    [self removeDimmingView];
    [self showAnswerPropAlertView];
}

- (void)answerButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"answer"];
    if (self.currentQuestion.base_type == 0) {
        _composeView = [[SKComposeView alloc] initWithQustionID:self.currentQuestion.qid frame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _composeView.associatedQuestion = self.currentQuestion;
        _composeView.delegate = self;
        _composeView.alpha = 0.0;
        [self.view addSubview:_composeView];
        [_composeView becomeFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            _composeView.alpha = 1.0;
            [self.view addSubview:_composeView];
        } completion:^(BOOL finished) {
            [self stop];
        }];
    } else {
        if (self.type == SKQuestionTypeHistoryLevel) {
            //往期关卡-线下题（地标已毁坏）
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_prompt_Invalid"]];
            [imageView sizeToFit];
            imageView.right = self.view.right-10;
            imageView.bottom = _answerButton.top -5;
            imageView.alpha = 0;
            [self.view addSubview:imageView];
            [UIView animateWithDuration:0.5 animations:^{
                imageView.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 delay:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    imageView.alpha = 0;
                } completion:^(BOOL finished) {
                    [imageView removeFromSuperview];
                }];
            }];
        } else if (self.type == SKQuestionTypeTimeLimitLevel){
            //限时关卡-线下题目
            if (self.currentQuestion.base_type == 1) {
                //LBS
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
                {
                    HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeCamera];
                    [alertView show];
                }else {
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

- (void)onClickReplayButton {
    //[MobClick event:@"replay"];
    [TalkingData trackEvent:@"replay"];
    [UIView animateWithDuration:0.3 animations:^{
        _replayBackView.alpha = 0.;
    }];
    [self play];
}

- (void)contentViewClick {
    [TalkingData trackEvent:@"chapterstory"];
    if (self.player.currentTime.value>0) {
        [self pause];
    }
    _descriptionView = [[SKDescriptionView alloc] initWithURLString:self.currentQuestion.description_url andType:SKDescriptionTypeQuestion andImageUrl:self.currentQuestion.description_pic];
    [self.view addSubview:_descriptionView];
    [_descriptionView showAnimated];
}

- (void)helpButtonClicked:(UIButton *)sender {
    [TalkingData trackEvent:@"noviceguide"];
    [self pause];
    SKHelperScrollView *helpView;
    if (self.currentQuestion.base_type == 2 || self.currentQuestion.base_type == 1) {
        helpView = [[SKHelperScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperScrollViewTypeAR];
    } else if (self.currentQuestion.base_type == 0){
        helpView = [[SKHelperScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperScrollViewTypeTimeLimitQuestion];
    }
    helpView.delegate = self;
    helpView.scrollView.frame = CGRectMake(SCREEN_WIDTH, -(SCREEN_HEIGHT-356)/2, 0, 0);
    helpView.dimmingView.alpha = 0;
    [self.view addSubview:helpView];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        helpView.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        helpView.dimmingView.alpha = 0.9;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showGuideviewWithType:(SKHelperGuideViewType)type {
    SKHelperGuideView *guideView = [[SKHelperGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:type];
    [KEY_WINDOW addSubview:guideView];
    [KEY_WINDOW bringSubviewToFront:guideView];
}

#pragma mark - HTARCaptureController Delegate

- (void)didClickBackButtonInARCaptureController:(HTARCaptureController *)controller reward:(SKReward *)reward{
    [controller dismissViewControllerAnimated:NO completion:^{
        [_composeView showAnswerCorrect:YES];
        self.isAnswered = YES;
        self.reward = reward;
        [_composeView endEditing:YES];
        [_composeView removeFromSuperview];
        [self removeDimmingView];
        [self showRewardViewWithReward:nil];
        
        [[[SKServiceManager sharedInstance] profileService] updateUserInfoFromServer];
        [[[SKServiceManager sharedInstance] questionService] getQuestionTop10WithQuestionID:self.currentQuestion.qid callback:^(BOOL success, NSArray<SKUserInfo *> *userRankList) {
            self.top10Array = userRankList;
        }];
        [[[SKServiceManager sharedInstance] questionService] getAllQuestionListCallback:^(BOOL success, NSInteger answeredQuestion_season1, NSInteger answeredQuestion_season2, NSArray<SKQuestion *> *questionList_season1, NSArray<SKQuestion *> *questionList_season2) {
            self.currentQuestion = [questionList_season2 lastObject];
        }];
    }];
}

#pragma mark - SKHelperScrollViewDelegate

- (void)didClickCompleteButton {
    [_helpButton setImage:[UIImage imageNamed:@"btn_levelpage_help_highlight"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.075 animations:^{
        _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.075 animations:^{
            _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.075 animations:^{
                _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.075 animations:^{
                    _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 0.9, 0.9);
                } completion:^(BOOL finished) {
                    [_helpButton setImage:[UIImage imageNamed:@"btn_levelpage_help"] forState:UIControlStateNormal];
                }];
            }];
        }];
    }];
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
    //显示GuideView
    if (FIRST_COACHMARK_TYPE_2 && [[UD dictionaryForKey:kQuestionWrongAnswerCountSeason1][self.currentQuestion.qid] integerValue]>2) {
        [self showGuideviewWithType:SKHelperGuideViewType2];
        [UD setBool:YES forKey:@"firstLaunchTypeThreeWrongAnswer"];
    }
}

#pragma mark - SKComposeView Delegate 答题

- (void)updateHintCount:(NSInteger)count {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[UD dictionaryForKey:kQuestionWrongAnswerCountSeason1]];
    [dict setObject:@(count) forKey:self.currentQuestion.qid];
    [UD setObject:dict forKey:kQuestionWrongAnswerCountSeason1];
}

- (void)composeView:(SKComposeView *)composeView didComposeWithAnswer:(NSString *)answer {
    if (_type == SKQuestionTypeTimeLimitLevel) {
        [[[SKServiceManager sharedInstance] answerService] answerTimeLimitTextQuestionWithAnswerText:answer callback:^(BOOL success, SKResponsePackage *response) {
            if (response.result == 0) {
                //回答正确
                [self.delegate answeredQuestionWithSerialNumber:self.currentQuestion.serial season:self.currentQuestion.level_type];
                self.currentQuestion.is_answer = YES;
                [_composeView showAnswerCorrect:YES];
                self.isAnswered = YES;
                
                self.rewardDict = response.data;
                self.reward = [SKReward objectWithKeyValues:self.rewardDict];
                [[[SKServiceManager sharedInstance] questionService] getQuestionTop10WithQuestionID:self.currentQuestion.qid callback:^(BOOL success, NSArray<SKUserInfo *> *userRankList) {
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
        [[[SKServiceManager sharedInstance] answerService] answerExpiredTextQuestionWithQuestionID:self.currentQuestion.qid answerText:answer callback:^(BOOL success, SKResponsePackage *response) {
            if (response.result == 0) {
                //回答正确
                [self.delegate answeredQuestionWithSerialNumber:self.currentQuestion.serial season:self.currentQuestion.level_type];
                self.currentQuestion.is_answer = YES;
                [_composeView showAnswerCorrect:YES];
                self.isAnswered = YES;
                
                self.rewardDict = response.data;
                self.reward = [SKReward objectWithKeyValues:self.rewardDict];
                [[[SKServiceManager sharedInstance] questionService] getQuestionTop10WithQuestionID:self.currentQuestion.qid callback:^(BOOL success, NSArray<SKUserInfo *> *userRankList) {
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

#pragma mark - 分享

- (void)onClickShareButton:sender {
    [self showShareView];
}

- (void)showShareView {
    if (_shareView == nil) {
        [self createShareView];
    }
    [UIView animateWithDuration:0.3 animations:^{
        _shareView.alpha = 0.9;
    }];
}

- (void)hideShareView {
    [UIView animateWithDuration:0.3 animations:^{
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
    
    [UIView animateWithDuration:0.3 animations:^{
        alphaView.alpha = 0.6;
    }];
    
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_popup_share"]];
    promptImageView.center = _dimmingView.center;
    [_dimmingView addSubview:promptImageView];
}

- (void)sharedQuestion {
    [[[SKServiceManager sharedInstance] questionService] shareQuestionWithQuestionID:self.currentQuestion.qid callback:^(BOOL success, SKResponsePackage *response) {
        if (response.result == 0) {
            [self showSharePromptView];
        }
    }];
}

- (void)shareWithThirdPlatform:(UIButton*)sender {
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
            NSArray* imageArray = @[self.currentQuestion.question_video_cover];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"你会是下一个被选召的人吗？不是所有人都能完成这道考验"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(AppDelegateInstance.cityCode, self.currentQuestion.qid)]
                                                  title:[NSString stringWithFormat:@"第%@章",self.currentQuestion.serial]
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    DLog(@"State -> %lu", (unsigned long)state);
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            [self hideShareView];
                            [self sharedQuestion];
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
            if (![WXApi isWXAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray* imageArray = @[self.currentQuestion.question_video_cover];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:self.currentQuestion.content
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(AppDelegateInstance.cityCode, self.currentQuestion.qid)]
                                                  title:@"你会是下一个被选召的人吗？不是所有人都能完成这道考验"
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            [self hideShareView];
                            [self sharedQuestion];
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
            if (![WeiboSDK isWeiboAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray* imageArray = @[self.currentQuestion.question_video_cover];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"你会是下一个被选召的人吗？不是所有人都能完成这道考验 %@ 来自@九零APP", SHARE_URL(AppDelegateInstance.cityCode, self.currentQuestion.qid)]
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(AppDelegateInstance.cityCode, self.currentQuestion.qid)]
                                                  title:self.currentQuestion.chapter
                                                   type:SSDKContentTypeImage];
                [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            [self hideShareView];
                            [self sharedQuestion];
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
            if (![QQApiInterface isQQInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray* imageArray = @[self.currentQuestion.question_video_cover];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"你会是下一个被选召的人吗？不是所有人都能完成这道考验"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(AppDelegateInstance.cityCode, self.currentQuestion.qid)]
                                                  title:[NSString stringWithFormat:@"第%@章",self.currentQuestion.serial]
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            [self hideShareView];
                            [self sharedQuestion];
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

#pragma mark - Notification

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentIndex"]) {
        if (self.currentIndex < 4) {
            if (self.currentIndex == 0) {
                //                [self createVideoOnView:_playBackView withFrame:CGRectMake(0, 0, _playBackView.width, _playBackView.height)];
            }
            [_triangleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_contentView.mas_bottom).offset(-1);
                make.left.equalTo(@(24+(ROUND_WIDTH_FLOAT(40)+PADDING)*self.currentIndex+ROUND_WIDTH_FLOAT(40)/2-9.5));
            }];
        } else if (self.currentIndex == 4) {
            [_triangleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_contentView.mas_bottom).offset(-1);
                make.left.equalTo(@(24+(ROUND_WIDTH_FLOAT(40)+PADDING)*1+ROUND_WIDTH_FLOAT(40)/2-9.5));
            }];
        }
        
        if (self.currentIndex == 1) {
            [TalkingData trackEvent:@"exanswer"];
        } else if (self.currentIndex == 3) {
            [TalkingData trackEvent:@"exgift"];
        }
    } else if ([keyPath isEqualToString:@"isAnswered"]) {
        if (self.isAnswered == YES) {
            [_timeView setQuestion:self.currentQuestion type:_type endTime:_endTime];
            self.answerButton.hidden = self.isAnswered;
            [self.view viewWithTag:201].hidden = NO;
            [self.view viewWithTag:202].hidden = NO;
            [self.view viewWithTag:203].hidden = NO;
            [self.view viewWithTag:204].hidden = YES;
        } else {
            [_timeView setQuestion:self.currentQuestion type:_type endTime:_endTime];
            [self.view viewWithTag:201].hidden = YES;
            [self.view viewWithTag:202].hidden = YES;
            [self.view viewWithTag:203].hidden = YES;
            [self.view viewWithTag:204].hidden = self.currentQuestion.base_type;
        }
    }
}

- (void)playItemDidPlayToEndTime:(NSNotification *)notification {
    if ([notification.object isEqual:self.playerItem]) {
//        [self stop];
        //显示分享界面
        [self showReplayAndShareButton];
        if (FIRST_COACHMARK_TYPE_1 && !self.currentQuestion.is_answer) {
            [self showGuideviewWithType:SKHelperGuideViewType1];
            [UD setBool:YES forKey:@"firstLaunchTypePlayToEnd"];
        }
    }
}

@end
