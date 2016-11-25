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

@property (nonatomic, strong) UIImageView *playBackView;
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
    NSArray *buttonsNameArray = @[@"puzzle", @"key", @"top", @"gift", @"article", @"tools"];
    self.currentIndex = 0;
    for (int i = 0; i<6; i++) {
        UIButton *btn = [UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_detailspage_%@", buttonsNameArray[i]]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_detailspage_%@_highlight", buttonsNameArray[i]]] forState:UIControlStateHighlighted];
        btn.tag = 200+i;
        btn.hidden = YES;
        [btn addTarget:self action:@selector(bottomButtonsClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if (i<5) {
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
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_play"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_detailspage_play_highlight" ] forState:UIControlStateHighlighted];
    [_playButton sizeToFit];
    _playButton.center = _playBackView.center;
    [self.view addSubview:_playButton];
    [_playButton addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
    _playButton.hidden = NO;
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

#pragma mark - Gift View

- (void)createGiftViewWithRewardInfo:(NSDictionary*)reward ticket:(NSDictionary*)ticket {
    BOOL isTicket = YES;
    
    [self.view addSubview:_dimmingView];
    _dimmingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _contentView.bottom);
    
    UIView *rewardBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, _contentView.bottom-10)];
    rewardBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    rewardBackView.layer.cornerRadius = 5;
    [_dimmingView addSubview:rewardBackView];
    
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
            make.bottom.equalTo(rewardBackView).offset(-10);
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
    [_dimmingView removeFromSuperview];
    self.currentIndex = sender.tag - 200;
    switch (sender.tag) {
        case 200: {
            break;
        }
        case 201: {
            
            break;
        }
        case 202: {
            break;
        }
        case 203: {
            [self createGiftViewWithRewardInfo:nil ticket:nil];
            break;
        }
        case 204: {
            break;
        }
        case 205: {
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
            [self.view viewWithTag:204].hidden = NO;
            [self.view viewWithTag:205].hidden = YES;
        } else {
            [self.view viewWithTag:201].hidden = YES;
            [self.view viewWithTag:202].hidden = YES;
            [self.view viewWithTag:203].hidden = YES;
            [self.view viewWithTag:204].hidden = YES;
            [self.view viewWithTag:205].hidden = NO;
        }
    }
}

@end
