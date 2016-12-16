//
//  SKQuestionViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/7.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKQuestionViewController.h"
#import "HTUIHeader.h"

#import "SKTicketView.h"

#define PADDING (SCREEN_WIDTH-48-ROUND_WIDTH_FLOAT(200))/4

@interface SKQuestionViewController ()

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isAnswered;
@property (nonatomic, assign) SKQuestionType type;

@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UILabel *chapterNumberLabel;
@property (nonatomic, strong) UILabel *chapterTitleLabel;
@property (nonatomic, strong) UILabel *chapterSubTitleLabel;

@property (nonatomic, strong) UIView *playBackView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIImageView *triangleImageView;

@property (nonatomic, strong) UIButton *answerButton;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *toolsView;

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIView *progressBgView;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) SKReward *questionReward;
@property (nonatomic, strong) SKQuestion *currentQuestion;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.season = 1;
    [self createUI];
    [self loadData];
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"isAnswered" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
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
    [self removeObserver:self forKeyPath:@"currentIndex"];
    [self removeObserver:self forKeyPath:@"isAnswered"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] questionService] getQuestionDetailWithQuestionID:self.currentQuestion.qid callback:^(BOOL success, SKQuestion *question) {
        self.currentQuestion = question;
        self.chapterNumberLabel.text = question.serial;
        self.chapterTitleLabel.text = [[question.content componentsSeparatedByString:@"-"] objectAtIndex:0];
        self.chapterSubTitleLabel.text = [[question.content componentsSeparatedByString:@"-"] lastObject];
        NSLog(@"%@", question.question_video_url);
        [self createVideoOnView:_playBackView withFrame:CGRectMake(0, 0, _playBackView.width, _playBackView.height)];
    }];
    if (_type == SKQuestionTypeTimeLimitLevel) {
    } else if (_type == SKQuestionTypeHistoryLevel) {
        
    }
}

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    __weak __typeof(self)weakSelf = self;
    
    UIButton *helpButton = [UIButton new];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_help"] forState:UIControlStateNormal];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_help_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:helpButton];
    [helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(@12);
        make.right.equalTo(weakSelf.view.mas_right).offset(-4);
    }];
    
    _playBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 106, SCREEN_WIDTH-20, SCREEN_WIDTH-20)];
    _playBackView.layer.masksToBounds = YES;
    _playBackView.contentMode = UIViewContentModeScaleAspectFit;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_playBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _playBackView.bounds;
    maskLayer.path = maskPath.CGPath;
    _playBackView.layer.mask = maskLayer;
    [self.view addSubview:_playBackView];
    
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
    
    // 题目标题
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(10, _playBackView.bottom, _playBackView.width, 72)];
    _contentView.backgroundColor = COMMON_SEPARATOR_COLOR;
    [self.view addSubview:_contentView];
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _contentView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    _contentView.layer.mask = maskLayer2;
    
    UIImageView *chapterImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detailspage_chapter"]];
    [self.view addSubview:chapterImageView];
    chapterImageView.left = 10;
    chapterImageView.top = 106-6-27;
    
    _chapterNumberLabel = [UILabel new];
    _chapterNumberLabel.textColor = COMMON_PINK_COLOR;
    _chapterNumberLabel.text = @"01";
    _chapterNumberLabel.font = MOON_FONT_OF_SIZE(13);
    [_chapterNumberLabel sizeToFit];
    _chapterNumberLabel.center = chapterImageView.center;
    [self.view addSubview:_chapterNumberLabel];
    
    _chapterTitleLabel = [UILabel new];
    _chapterTitleLabel.textColor = COMMON_PINK_COLOR;
    _chapterTitleLabel.font = PINGFANG_FONT_OF_SIZE(14);
    [self.view addSubview:_chapterTitleLabel];
    [_chapterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView.mas_left).offset(12);
        make.top.equalTo(_contentView.mas_top).offset(13);
        make.right.equalTo(_contentView.mas_right).offset(-12);
    }];
    
    _chapterSubTitleLabel = [UILabel new];
    _chapterSubTitleLabel.textColor = COMMON_GREEN_COLOR;
    _chapterSubTitleLabel.font = PINGFANG_FONT_OF_SIZE(15);
    [self.view addSubview:_chapterSubTitleLabel];
    [_chapterSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView.mas_left).offset(12);
        make.top.equalTo(_chapterTitleLabel.mas_bottom).offset(5);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detailspage_arrow"]];
    [self.view addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_chapterSubTitleLabel.mas_right).offset(6);
        make.centerY.equalTo(_chapterSubTitleLabel.mas_centerY);
    }];
    
    _answerButton = [UIButton new];
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
                make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-(SCREEN_HEIGHT-106-SCREEN_WIDTH+20-72-12-ROUND_WIDTH_FLOAT(40))/2);
                make.left.equalTo(@(24+(ROUND_WIDTH_FLOAT(40)+PADDING)*i));
            }];
            if (i==0) {
                btn.hidden = NO;
                [_triangleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_contentView.mas_bottom);
//                    make.left.equalTo(contentView.mas_left).offset(20);
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
                    make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-(SCREEN_HEIGHT-106-SCREEN_WIDTH+20-72-12-ROUND_WIDTH_FLOAT(40))/2);
                    make.left.equalTo(@(24+(ROUND_WIDTH_FLOAT(40)+PADDING)*1));
                }];
            }
        }
    }
}

- (void)createVideoOnView:(UIView *)backView withFrame:(CGRect)frame {
    _playerItem = nil;
    _player = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    
    NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:self.currentQuestion.question_video];
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
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
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
    
    //[_coverImageView sd_setImageWithURL:[NSURL URLWithString:_question.question_video_cover] placeholderImage:[UIImage imageNamed:@"img_chap_video_cover_default"]];
    
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

- (void)createToolsViewWithButton:(UIButton *)button {
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor colorWithHex:0x0e0e0e];
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
    int hintPropCount = 0;
    
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
    tap.numberOfTapsRequired = 1;
    [_dimmingView addGestureRecognizer:tap];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor colorWithHex:0x0e0e0e];
    alphaView.alpha = 0.9;
    [_dimmingView addSubview:alphaView];
    
    UIView *rightCornerBackView = [UIView new];
    rightCornerBackView.layer.cornerRadius = 15;
    rightCornerBackView.layer.masksToBounds = YES;
    rightCornerBackView.backgroundColor = [UIColor blackColor];
    [_dimmingView addSubview:rightCornerBackView];
    [rightCornerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(97+15));
        make.height.equalTo(@30);
        make.right.equalTo(_dimmingView).offset(15);
        make.top.equalTo(@13);
    }];
    
    UIButton *addButton = [UIButton new];
    if (hintPropCount==0) {
        [addButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_clue_add"] forState:UIControlStateNormal];
    } else {
        [addButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_detailspage_clue_season%lu",(unsigned long)_season]] forState:UIControlStateNormal];
    }
    [rightCornerBackView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.left.equalTo(rightCornerBackView).offset(2.5);
        make.centerY.equalTo(rightCornerBackView);
    }];
    
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_popup_solution_text"]];
    [textImageView sizeToFit];
    [rightCornerBackView addSubview:textImageView];
    [textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addButton.mas_right).offset(6);
        make.centerY.equalTo(addButton);
    }];
    
    UILabel *propCountLabel = [UILabel new];
    propCountLabel.text = [NSString stringWithFormat:@"%d",hintPropCount];
    propCountLabel.textColor = [UIColor whiteColor];
    propCountLabel.font = MOON_FONT_OF_SIZE(18);
    [propCountLabel sizeToFit];
    [rightCornerBackView addSubview:propCountLabel];
    [propCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textImageView.mas_right).offset(4);
        make.centerY.equalTo(textImageView);
    }];
    
    for (int i = 0; i<3; i++) {
        UIImageView *hintBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detailspage_cluebg"]];
        [_dimmingView addSubview:hintBackgroundView];
        [hintBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@260);
            make.height.equalTo(@75);
            make.top.equalTo(@(ROUND_HEIGHT_FLOAT(132) + (75+ROUND_HEIGHT_FLOAT(70))*i));
            make.centerX.equalTo(_dimmingView);
        }];
        
        UIButton *hintButton = [UIButton new];
        [hintButton addTarget:self action:@selector(getHintButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [hintButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_detailspage_season%lu",(unsigned long)_season]] forState:UIControlStateNormal];
        [_dimmingView addSubview:hintButton];
        [hintButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(hintBackgroundView);
            make.center.equalTo(hintBackgroundView);
        }];
    }
}

- (void)showAnswerPropAlertView {
    int propCount = 0;

    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
    tap.numberOfTapsRequired = 1;
    [_dimmingView addGestureRecognizer:tap];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor colorWithHex:0x0e0e0e];
    alphaView.alpha = 0.9;
    [_dimmingView addSubview:alphaView];
    
    UIView *alertBackView = [UIView new];
    alertBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    [_dimmingView addSubview:alertBackView];
    [alertBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@270);
        make.height.equalTo(@146);
        make.center.equalTo(_dimmingView);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"确定要使用答案道具通过本关吗？";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = PINGFANG_FONT_OF_SIZE(14);
    [titleLabel sizeToFit];
    [alertBackView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertBackView);
        make.top.equalTo(alertBackView).offset(17);
    }];
    
    UIImageView *iconImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_popup_solution_season1"]];
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
    propCountLabel.text = [NSString stringWithFormat:@"%d",propCount];
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
 
    if (propCount>0) {
        //使用道具
        UIButton *usePropButton = [UIButton new];
        [usePropButton addTarget:self action:@selector(usePropButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [usePropButton addTarget:self action:@selector(usePropButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [usePropButton addTarget:self action:@selector(usePropButtonTouchExit:) forControlEvents:UIControlEventTouchDragExit];
        usePropButton.layer.cornerRadius = 3;
        usePropButton.titleLabel.font = PINGFANG_FONT_OF_SIZE(14);
        [usePropButton setTitle:@"使用道具" forState:UIControlStateNormal];
        [usePropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [usePropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (_season == 1)       usePropButton.backgroundColor = COMMON_GREEN_COLOR;
        else if (_season == 2)  usePropButton.backgroundColor = COMMON_PINK_COLOR;
        [alertBackView addSubview:usePropButton];
        [usePropButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(120, 42));
            make.right.equalTo(alertBackView).offset(-10);
            make.bottom.equalTo(alertBackView).offset(-10);
        }];
    } else {
        //购买道具
        UIButton *purchPropButton = [UIButton new];
        [purchPropButton addTarget:self action:@selector(purchasePropButtonOnClickPropButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [purchPropButton addTarget:self action:@selector(purchasePropButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [purchPropButton addTarget:self action:@selector(purchasePropButtonOnClickPropButtonTouchExit:) forControlEvents:UIControlEventTouchDragExit];
        purchPropButton.layer.cornerRadius = 3;
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

//使用道具
- (void)usePropButtonOnClick:(UIButton*)sender {
    [self removeDimmingView];
}

- (void)usePropButtonTouchDown:(UIButton*)sender {
    switch (_season) {
        case 1:
            sender.backgroundColor = COMMON_PINK_COLOR;
            break;
        case 2:
            sender.backgroundColor = COMMON_GREEN_COLOR;
            break;
        default:
            break;
    }
}

- (void)usePropButtonTouchExit:(UIButton*)sender {
    switch (_season) {
        case 1:
            sender.backgroundColor = COMMON_GREEN_COLOR;
            break;
        case 2:
            sender.backgroundColor = COMMON_PINK_COLOR;
            break;
        default:
            break;
    }
}

//购买道具
- (void)purchasePropButtonOnClick:(UIButton*)sender {
    [self removeDimmingView];
}

- (void)purchasePropButtonOnClickPropButtonTouchDown:(UIButton*)sender {
    sender.backgroundColor = COMMON_GREEN_COLOR;
}

- (void)purchasePropButtonOnClickPropButtonTouchExit:(UIButton*)sender {
    sender.backgroundColor = [UIColor colorWithHex:0xed203b];
}

#pragma mark - Answer View

- (void)createAnswerViewWithButton:(UIButton*)button answer:(NSDictionary *)answer {
    _dimmingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _contentView.bottom)];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UIView *answerBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, _contentView.bottom-10)];
    answerBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    answerBackView.layer.cornerRadius = 5;
    [_dimmingView addSubview:answerBackView];
    
    UIImageView *answerButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_key_highlight"]];
    [_dimmingView addSubview:answerButtonImageView];
    answerButtonImageView.frame = button.frame;
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    titleImageView.backgroundColor = [UIColor redColor];
    [_dimmingView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(answerBackView);
        make.right.equalTo(answerBackView);
        make.top.equalTo(answerBackView);
        make.height.equalTo(ROUND_HEIGHT(108));
    }];
    
    //视频
    UIImageView *playBackView = [[UIImageView alloc] initWithFrame:CGRectMake(10, ROUND_HEIGHT_FLOAT(108)+12, answerBackView.width-20, ROUND_HEIGHT_FLOAT(157.6))];
    playBackView.layer.masksToBounds = YES;
    playBackView.contentMode = UIViewContentModeScaleAspectFit;
    [answerBackView addSubview:playBackView];
    
    _playerItem = nil;
    _player = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    
    NSURL *localUrl = [[NSBundle mainBundle] URLForResource:@"trailer_video" withExtension:@"mp4"];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:localUrl options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _playerLayer.frame = CGRectMake(0, 0, playBackView.width, playBackView.height);
    [playBackView.layer addSublayer:_playerLayer];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_play"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_play_highlight" ] forState:UIControlStateHighlighted];
    [_playButton sizeToFit];
    _playButton.center = playBackView.center;
    _playButton.hidden = NO;
    [answerBackView addSubview:_playButton];
    
    //文本
    //TODO 答案页
    UITextView *textView = [UITextView new];
    
}

#pragma mark - Rank View

- (void)createRankViewWithButton:(UIButton*)button {
    int rankers = 10;
    
    _dimmingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _contentView.bottom)];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UIView *rankBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, _contentView.bottom-10)];
    rankBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    rankBackView.layer.cornerRadius = 5;
    [_dimmingView addSubview:rankBackView];
    
    UIImageView *rankImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_top_highlight"]];
    [_dimmingView addSubview:rankImageView];
    rankImageView.frame = button.frame;

    UIScrollView *rankScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rankBackView.width, rankBackView.height)];
    float height = 21+ROUND_WIDTH_FLOAT(160)/160.*29.+22+ROUND_HEIGHT_FLOAT(114)+12+1+76*(rankers-3)+20;
    rankScrollView.contentSize = CGSizeMake(rankBackView.width, height);
    [rankBackView addSubview:rankScrollView];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_chapter_leaderboard"]];
    [rankScrollView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(160));
        make.height.equalTo(@(ROUND_WIDTH_FLOAT(160)/160.*29.));
        make.top.equalTo(@21);
        make.centerX.equalTo(rankScrollView);
    }];
    
    // 1-3
    UIView *top13View = [UIView new];
    [rankScrollView addSubview:top13View];
    [top13View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleImageView.mas_bottom).offset(22);
        make.width.equalTo(ROUND_WIDTH(268));
        make.height.equalTo(@114);
        make.centerX.equalTo(rankScrollView);
    }];
    
    // top1
    UIImageView *avatarImageView_top1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    [top13View addSubview:avatarImageView_top1];
    [avatarImageView_top1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@72);
        make.height.equalTo(@72);
        make.centerX.equalTo(top13View);
        make.top.equalTo(top13View);
    }];
    
    UILabel *nameLabel_top1 = [UILabel new];
    nameLabel_top1.text = @"Top1";
    nameLabel_top1.textAlignment = NSTextAlignmentCenter;
    nameLabel_top1.textColor = [UIColor whiteColor];
    nameLabel_top1.font = PINGFANG_FONT_OF_SIZE(14);
    [top13View addSubview:nameLabel_top1];
    [nameLabel_top1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(avatarImageView_top1);
        make.top.equalTo(avatarImageView_top1.mas_bottom).offset(14);
        make.width.equalTo(@80);
    }];
    
    // top2
    UIImageView *avatarImageView_top2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    [top13View addSubview:avatarImageView_top2];
    [avatarImageView_top2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@56);
        make.height.equalTo(@56);
        make.top.equalTo(top13View).offset(16);
        make.centerX.equalTo(top13View.mas_left).offset(ROUND_WIDTH_FLOAT(268/6));
    }];
    
    UILabel *nameLabel_top2 = [UILabel new];
    nameLabel_top2.text = @"Top2";
    nameLabel_top2.textAlignment = NSTextAlignmentCenter;
    nameLabel_top2.textColor = [UIColor whiteColor];
    nameLabel_top2.font = PINGFANG_FONT_OF_SIZE(14);
    [top13View addSubview:nameLabel_top2];
    [nameLabel_top2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(avatarImageView_top2);
        make.top.equalTo(avatarImageView_top2.mas_bottom).offset(14);
        make.width.equalTo(@80);
    }];

    // top3
    UIImageView *avatarImageView_top3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    [top13View addSubview:avatarImageView_top3];
    [avatarImageView_top3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@56);
        make.height.equalTo(@56);
        make.top.equalTo(top13View).offset(16);
        make.centerX.equalTo(top13View.mas_right).offset(-ROUND_WIDTH_FLOAT(268/6));
    }];
    
    UILabel *nameLabel_top3 = [UILabel new];
    nameLabel_top3.text = @"Top3";
    nameLabel_top3.textAlignment = NSTextAlignmentCenter;
    nameLabel_top3.textColor = [UIColor whiteColor];
    nameLabel_top3.font = PINGFANG_FONT_OF_SIZE(14);
    [top13View addSubview:nameLabel_top3];
    [nameLabel_top3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(avatarImageView_top3);
        make.top.equalTo(avatarImageView_top3.mas_bottom).offset(14);
        make.width.equalTo(@80);
    }];
    
    UIView *splitLine = [UIView new];
    splitLine.backgroundColor = [UIColor colorWithHex:0x303030];
    [rankScrollView addSubview:splitLine];
    [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(top13View);
        make.height.equalTo(@1);
        make.top.equalTo(top13View.mas_bottom).offset(12);
        make.centerX.equalTo(top13View);
    }];
    
    // 4-10
    for (int i=0; i<rankers-3; i++) {
        UIView *top410ViewCell = [UIView new];
        top410ViewCell.backgroundColor = [UIColor clearColor];
        [rankScrollView addSubview:top410ViewCell];
        [top410ViewCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(ROUND_WIDTH(268));
            make.height.equalTo(@56);
            make.top.equalTo(splitLine.mas_bottom).offset(20+76*i);
            make.centerX.equalTo(rankScrollView);
        }];
        
        UILabel *orderLabel = [UILabel new];
        orderLabel.textColor = COMMON_RED_COLOR;
        orderLabel.text = [NSString stringWithFormat:@"%d", i+4];
        orderLabel.font = MOON_FONT_OF_SIZE(18);
        [orderLabel sizeToFit];
        [top410ViewCell addSubview:orderLabel];
        [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@32);
            make.centerY.equalTo(top410ViewCell);
        }];
        
        UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        [top410ViewCell addSubview:avatarImageView];
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@56);
            make.height.equalTo(@56);
            make.centerY.equalTo(top410ViewCell);
            make.centerX.equalTo(top410ViewCell.mas_centerX).offset(-22);
        }];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text = @"小冉";
        nameLabel.font = PINGFANG_FONT_OF_SIZE(14);
        [nameLabel sizeToFit];
        [top410ViewCell addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(avatarImageView.mas_right).offset(16);
            make.centerY.equalTo(avatarImageView);
        }];
    }
}

#pragma mark - Gift View

- (void)createGiftViewWithButton:(UIButton*)button reward:(NSDictionary*)reward ticket:(NSDictionary*)ticket {
    BOOL isTicket = YES;
    
    _dimmingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _contentView.bottom)];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    //rewardBackView
    UIView *rewardBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, _contentView.bottom-10)];
    rewardBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    rewardBackView.layer.cornerRadius = 5;
    [_dimmingView addSubview:rewardBackView];
    
    UIImageView *giftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_gift_highlight"]];
    [_dimmingView addSubview:giftImageView];
    giftImageView.frame = button.frame;
    
    UIView *rewardBaseInfoView = [UIView new];
    rewardBaseInfoView.backgroundColor = [UIColor clearColor];
    [rewardBackView addSubview:rewardBaseInfoView];
    [rewardBaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@248);
        make.height.equalTo(@294);
        make.centerX.equalTo(rewardBackView);
        if (isTicket)   make.top.equalTo(@16);
        else            make.top.equalTo(@86);
    }];
    
    [self createRewardBaseInfoWithBaseInfoView:rewardBaseInfoView];
    
    //Ticket
    if (isTicket) {
        SKTicketView *card = [[SKTicketView alloc] initWithFrame:CGRectZero];
        [rewardBaseInfoView addSubview:card];
        [card mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@280);
            make.height.equalTo(@108);
            make.centerX.equalTo(rewardBaseInfoView);
            make.bottom.equalTo(rewardBackView.mas_bottom).offset(-(_dimmingView.height-320-108)/2);
        }];
    }
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
    
    UIImageView *rewardImageView_txt_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_1"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_1];
    [rewardImageView_txt_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@105);
        make.height.equalTo(@60);
        make.top.equalTo(rewardBaseInfoView).offset(121);
        make.left.equalTo(rewardBaseInfoView);
    }];
    
    UIImageView *rewardImageView_txt_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_2"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_2];
    [rewardImageView_txt_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@111);
        make.height.equalTo(@24);
        make.left.equalTo(rewardBaseInfoView).offset(106);
        make.top.equalTo(rewardBaseInfoView).offset(217-24);
    }];
    
    UILabel *percentLabel = [UILabel new];
    percentLabel.font = MOON_FONT_OF_SIZE(32.5);
    percentLabel.textColor = COMMON_GREEN_COLOR;
    percentLabel.text = @"99.9%";
    [percentLabel sizeToFit];
    [rewardBaseInfoView addSubview:percentLabel];
    [percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardImageView_txt_1.mas_right).offset(4);
        make.top.equalTo(rewardImageView_mascot.mas_bottom).offset(8);
    }];
    
    //金币行
    UIImageView *rewardImageView_txt_3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_3"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_3];
    [rewardImageView_txt_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@19);
        make.top.equalTo(rewardImageView_txt_2.mas_bottom).offset(10);
        make.left.equalTo(rewardBaseInfoView);
    }];
    
    UILabel *iconCountLabel = [UILabel new];
    iconCountLabel.textColor = COMMON_RED_COLOR;
    iconCountLabel.text = @"5";
    iconCountLabel.font = MOON_FONT_OF_SIZE(19);
    [iconCountLabel sizeToFit];
    [rewardBaseInfoView addSubview:iconCountLabel];
    [iconCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardImageView_txt_3.mas_right).offset(6);
        make.centerY.equalTo(rewardImageView_txt_3);
    }];
    
    UIImageView *rewardImageView_txt_gold = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_goldtext"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_gold];
    [rewardImageView_txt_gold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@37);
        make.height.equalTo(@19);
        make.left.equalTo(iconCountLabel.mas_right).offset(6);
        make.centerY.equalTo(iconCountLabel);
    }];
    
    //经验值行
    UIImageView *rewardImageView_exp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_exp"]];
    [rewardBaseInfoView addSubview:rewardImageView_exp];
    [rewardImageView_exp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@18);
        make.height.equalTo(@18);
        make.top.equalTo(rewardImageView_txt_3.mas_bottom).offset(6);
        make.right.equalTo(rewardImageView_txt_3);
    }];
    
    UILabel *expCountLabel = [UILabel new];
    expCountLabel.textColor = COMMON_RED_COLOR;
    expCountLabel.text = @"5";
    expCountLabel.font = MOON_FONT_OF_SIZE(19);
    [expCountLabel sizeToFit];
    [rewardBaseInfoView addSubview:expCountLabel];
    [expCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardImageView_exp.mas_right).offset(6);
        make.centerY.equalTo(rewardImageView_exp);
    }];
    
    UIImageView *rewardImageView_txt_exp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_exptext"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_exp];
    [rewardImageView_txt_exp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@56);
        make.height.equalTo(@19);
        make.left.equalTo(expCountLabel.mas_right).offset(6);
        make.centerY.equalTo(expCountLabel);
    }];
    
    //宝石行
    UIImageView *rewardImageView_diamond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_monds"]];
    [rewardBaseInfoView addSubview:rewardImageView_diamond];
    [rewardImageView_diamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@18);
        make.height.equalTo(@18);
        make.top.equalTo(rewardImageView_exp.mas_bottom).offset(6);
        make.right.equalTo(rewardImageView_exp);
    }];
    
    UILabel *diamondCountLabel = [UILabel new];
    diamondCountLabel.textColor = COMMON_RED_COLOR;
    diamondCountLabel.text = @"5";
    diamondCountLabel.font = MOON_FONT_OF_SIZE(19);
    [diamondCountLabel sizeToFit];
    [rewardBaseInfoView addSubview:diamondCountLabel];
    [diamondCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardImageView_diamond.mas_right).offset(6);
        make.centerY.equalTo(rewardImageView_diamond);
    }];
    
    UIImageView *rewardImageView_txt_diamond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_mondstext"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_diamond];
    [rewardImageView_txt_diamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@38);
        make.height.equalTo(@19);
        make.left.equalTo(diamondCountLabel.mas_right).offset(6);
        make.centerY.equalTo(diamondCountLabel);
    }];
}

- (void)showRewardViewWithReward:(SKReward*)reward {
    BOOL isTicket = YES;
    BOOL isMascot = YES;
    BOOL isThing  = YES;
    
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor blackColor];
    _dimmingView.alpha = 0;
    [self.view addSubview:_dimmingView];
    [UIView animateWithDuration:0.3 animations:^{
        _dimmingView.alpha = 0.9;
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
    
    if (isTicket) {
        [rewardBaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@248);
            make.height.equalTo(@294);
            make.centerX.equalTo(_dimmingView);
            make.top.equalTo(@54);
        }];
        
        [self createRewardBaseInfoWithBaseInfoView:rewardBaseInfoView];
        
        SKTicketView *card = [[SKTicketView alloc] initWithFrame:CGRectZero];
        [rewardBaseInfoView addSubview:card];
        [card mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@280);
            make.height.equalTo(@108);
            make.centerX.equalTo(rewardBaseInfoView);
            make.bottom.equalTo(_dimmingView.mas_bottom).offset(-(_dimmingView.height-320-108)/2);
        }];
    } else {
        [rewardBaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@248);
            make.height.equalTo(@294);
            make.centerX.equalTo(_dimmingView);
            make.centerY.equalTo(_dimmingView);
        }];
        
        [self createRewardBaseInfoWithBaseInfoView:rewardBaseInfoView];
    }
    
    if (isMascot) {
        [_dimmingView removeGestureRecognizer:tap];
        UITapGestureRecognizer *tap_showMascot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMascotViewWithReward:)];
        tap_showMascot.numberOfTapsRequired = 1;
        [_dimmingView addGestureRecognizer:tap_showMascot];
    } else {
        if (isThing) {
            [_dimmingView removeGestureRecognizer:tap];
            UITapGestureRecognizer *tap_showThing = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showThingViewWithReward:)];
            tap_showThing.numberOfTapsRequired = 1;
            [_dimmingView addGestureRecognizer:tap_showThing];
        }
    }
}

- (void)createMascotRewardViewWithReward:(SKReward*)reward {
    BOOL isThing  = YES;
    
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_dimmingView];
    _dimmingView.backgroundColor = [UIColor blackColor];
    _dimmingView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _dimmingView.alpha = 0.9;
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_popup_giftbg"]];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.frame = _dimmingView.frame;
    [_dimmingView addSubview:bgImageView];
    
    UIImageView *mascotImageView = [UIImageView new];
    [_dimmingView addSubview:mascotImageView];
    [mascotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH-32);
        make.height.mas_equalTo(SCREEN_WIDTH-32);
        make.top.equalTo(_dimmingView.mas_top).offset(94);
        make.centerX.equalTo(_dimmingView);
    }];
    
    UIImageView *contentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_popup_gifttext"]];
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
    
    if (isThing) {
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
    _dimmingView = [UIView new];
    [self.view addSubview:_dimmingView];
    _dimmingView.backgroundColor = [UIColor blackColor];
    _dimmingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _dimmingView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _dimmingView.alpha = 0.9;
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_popup_giftbg"]];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.frame = _dimmingView.frame;
    [_dimmingView addSubview:bgImageView];
    
    UIImageView *mascotImageView = [UIImageView new];
    [_dimmingView addSubview:mascotImageView];
    [mascotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH-32);
        make.height.mas_equalTo(SCREEN_WIDTH-32);
        make.top.equalTo(_dimmingView.mas_top).offset(94);
        make.centerX.equalTo(_dimmingView);
    }];
    
    UIImageView *contentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_popup_gifttext2"]];
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

- (void)getHintButtonClick:(UIButton *)sender {
    UIView *alertViewBackView = [[UIView alloc] initWithFrame:self.view.bounds];
    alertViewBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:alertViewBackView];
    
    UIImageView *propmtImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_article_prompt"]];
    [propmtImageView sizeToFit];
    [alertViewBackView addSubview:propmtImageView];
    [propmtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(alertViewBackView);
    }];
    
    [UIView animateWithDuration:0.5 delay:3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        alertViewBackView.alpha = 0;
    } completion:^(BOOL finished) {
        [alertViewBackView removeFromSuperview];
    }];
}

- (void)answerPropButtonClick:(UIButton *)sender {
    [self removeDimmingView];
    [self showAnswerPropAlertView];
}

- (void)answerButtonClick:(UIButton *)sender {
    self.isAnswered = YES;
    self.answerButton.hidden = self.isAnswered;
    [self showRewardViewWithReward:nil];
}

#pragma mark - Notification

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentIndex"]) {
        NSLog(@"%ld", self.currentIndex);
        if (self.currentIndex < 5) {
            if (self.currentIndex == 0) {
                [self createVideoOnView:_playBackView withFrame:CGRectMake(0, 0, _playBackView.width, _playBackView.height)];
            }
            [_triangleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_contentView.mas_bottom);
                make.left.equalTo(@(24+(ROUND_WIDTH_FLOAT(40)+PADDING)*self.currentIndex+ROUND_WIDTH_FLOAT(40)/2-9.5));
            }];
        } else if (self.currentIndex == 5) {
            [_triangleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_contentView.mas_bottom);
                make.left.equalTo(@(24+(ROUND_WIDTH_FLOAT(40)+PADDING)*1+ROUND_WIDTH_FLOAT(40)/2-9.5));
            }];
        }
    } else if ([keyPath isEqualToString:@"isAnswered"]) {
        if (self.isAnswered == YES) {
            [self.view viewWithTag:201].hidden = NO;
            [self.view viewWithTag:202].hidden = NO;
            [self.view viewWithTag:203].hidden = NO;
            [self.view viewWithTag:204].hidden = YES;
        } else {
            [self.view viewWithTag:201].hidden = YES;
            [self.view viewWithTag:202].hidden = YES;
            [self.view viewWithTag:203].hidden = YES;
            [self.view viewWithTag:204].hidden = NO;
        }
    }
}



@end
