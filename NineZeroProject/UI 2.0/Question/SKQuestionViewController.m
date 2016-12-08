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

@property (nonatomic, strong) UIView *dimmingView;

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIImageView *triangleImageView;

@property (nonatomic, strong) UIButton *answerButton;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *toolsView;

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@end

@implementation SKQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
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
    
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor clearColor];
    
    UIImageView *playBackView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 106, SCREEN_WIDTH-20, SCREEN_WIDTH-20)];
    playBackView.layer.masksToBounds = YES;
    playBackView.contentMode = UIViewContentModeScaleAspectFit;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:playBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = playBackView.bounds;
    maskLayer.path = maskPath.CGPath;
    playBackView.layer.mask = maskLayer;
    [self.view addSubview:playBackView];
    [self createVideoOnView:playBackView withFrame:CGRectMake(0, 0, playBackView.width, playBackView.height)];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(10, playBackView.bottom, playBackView.width, 72)];
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
    
    UILabel *chapterNumberLabel = [UILabel new];
    chapterNumberLabel.textColor = COMMON_PINK_COLOR;
    chapterNumberLabel.text = @"01";
    chapterNumberLabel.font = MOON_FONT_OF_SIZE(13);
    [chapterNumberLabel sizeToFit];
    chapterNumberLabel.center = chapterImageView.center;
    [self.view addSubview:chapterNumberLabel];
    
    UILabel *chapterTitleLabel = [UILabel new];
    chapterTitleLabel.textColor = COMMON_PINK_COLOR;
    chapterTitleLabel.text = @"#我是异类";
    chapterTitleLabel.font = PINGFANG_FONT_OF_SIZE(14);
    [self.view addSubview:chapterTitleLabel];
    [chapterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView.mas_left).offset(12);
        make.top.equalTo(_contentView.mas_top).offset(13);
        make.right.equalTo(_contentView.mas_right).offset(-12);
    }];
    
    UILabel *chapterSubTitleLabel = [UILabel new];
    chapterSubTitleLabel.textColor = COMMON_GREEN_COLOR;
    chapterSubTitleLabel.text = @"帮助零仔解除炸弹";
    chapterSubTitleLabel.font = PINGFANG_FONT_OF_SIZE(15);
    [self.view addSubview:chapterSubTitleLabel];
    [chapterSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView.mas_left).offset(12);
        make.top.equalTo(chapterTitleLabel.mas_bottom).offset(5);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detailspage_arrow"]];
    [self.view addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chapterSubTitleLabel.mas_right).offset(6);
        make.centerY.equalTo(chapterSubTitleLabel.mas_centerY);
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

- (void)createVideoOnView:(UIView *)backView withFrame:(CGRect)frame {
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
    _playerLayer.frame = frame;
    [backView.layer addSublayer:_playerLayer];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_play"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_play_highlight" ] forState:UIControlStateHighlighted];
    [_playButton sizeToFit];
    _playButton.center = backView.center;
    _playButton.hidden = NO;
    [self.view addSubview:_playButton];
//    _playButton.frame = CGRectMake(backView.width/2-_playButton.width/2, backView.height/2-_playButton.height/2, 70, 70);
}

#pragma mark - Tools View

- (void)createToolsViewWithButton:(UIButton *)button {
    [self.view addSubview:_dimmingView];
    _dimmingView.frame = self.view.bounds;
    
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
    [toolAnswerButton addTarget:self action:@selector(hintButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolAnswerButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_solution"] forState:UIControlStateNormal];
    [toolAnswerButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_solution_highlight"] forState:UIControlStateHighlighted];
    [toolBackView addSubview:toolAnswerButton];
    [toolAnswerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-27));
        make.top.equalTo(@18);
    }];
}

- (void)createHintView {
    [self.view addSubview:_dimmingView];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor colorWithHex:0x0e0e0e];
    alphaView.alpha = 0.6;
    [_dimmingView addSubview:alphaView];
    
    for (int i = 0; i<3; i++) {
        UIImageView *hintBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detailspage_cluebg"]];
        [_dimmingView addSubview:hintBackgroundView];
        [hintBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@260);
            make.height.equalTo(@75);
            make.top.equalTo(@(ROUND_HEIGHT_FLOAT(132) + (75+ROUND_HEIGHT_FLOAT(70))*i));
            make.centerX.equalTo(_dimmingView);
        }];
    }
}

#pragma mark - Answer View

- (void)createAnswerViewWithButton:(UIButton*)button answer:(NSDictionary *)answer {
    [self.view addSubview:_dimmingView];
    _dimmingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _contentView.bottom);
    
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
    
    [self.view addSubview:_dimmingView];
    _dimmingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _contentView.bottom);
    
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
    
    [self.view addSubview:_dimmingView];
    _dimmingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _contentView.bottom);
    
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

#pragma mark - Report View 

- (void)createReportViewWithButton:(UIButton*)button articles:(NSArray *)articlesArray {
    [self.view addSubview:_dimmingView];
    _dimmingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _contentView.bottom);
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor colorWithHex:0x0e0e0e];
    alphaView.alpha = 0.6;
    [_dimmingView addSubview:alphaView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
    tap.numberOfTapsRequired = 1;
    [_dimmingView addGestureRecognizer:tap];
    
    UIImageView *reportImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_article_highlight"]];
    [_dimmingView addSubview:reportImageView];
    reportImageView.frame = button.frame;
    
    [self.view bringSubviewToFront:_triangleImageView];
    
    UIView *reportBackView = [[UIView alloc] initWithFrame:CGRectMake(10, _contentView.bottom-(10+120*articlesArray.count), SCREEN_WIDTH-20, 10+120*articlesArray.count)];
    reportBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    reportBackView.layer.cornerRadius = 5;
    [_dimmingView addSubview:reportBackView];
    
    for (int i = 0; i<articlesArray.count; i++) {
        UIImageView *articleCover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        articleCover.backgroundColor = [UIColor redColor];
        [reportBackView addSubview:articleCover];
        [articleCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(10+120*i));
            make.left.equalTo(@10);
            make.right.equalTo(reportBackView.mas_right).offset(-10);
            make.height.equalTo(@110);
        }];
        
        UILabel *articleTitleLabel = [UILabel new];
        articleTitleLabel.textColor = [UIColor whiteColor];
        articleTitleLabel.text = @"#TestTestTestTestTest";
        articleTitleLabel.font = PINGFANG_FONT_OF_SIZE(12);
        [reportBackView addSubview:articleTitleLabel];
        [articleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(articleCover);
            make.bottom.equalTo(articleCover.mas_bottom).offset(-4);
            make.width.equalTo(articleCover);
        }];
    }
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
    for (UIView *view in _dimmingView.subviews) {
        [view removeFromSuperview];
    }
    [_dimmingView removeFromSuperview];
    self.currentIndex = 0;
}

- (void)hintButtonClick:(UIButton *)sender {
    [self removeDimmingView];
    [self createHintView];
}

- (void)answerButtonClick:(UIButton *)sender {
    self.isAnswered = YES;
    self.answerButton.hidden = self.isAnswered;
}

#pragma mark - Notification

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentIndex"]) {
        NSLog(@"%ld", self.currentIndex);
        if (self.currentIndex < 5) {
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
