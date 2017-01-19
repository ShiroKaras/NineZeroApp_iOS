//
//  SKMascotFightViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/1/4.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "SKMascotFightViewController.h"
#import "HTUIHeader.h"

#import "SKMascotFightManager.h"

@interface SKMascotFightViewController () <SKMascotFightManagerDelegate>
@property (nonatomic, strong) SKPet *mascot;
@property (nonatomic, strong) SKReward *reward;
@property (nonatomic, strong) SKMascotFightManager *fightManager;

@property (nonatomic, strong) UIImageView *monsterImageView;
@property (nonatomic, strong) UIImageView *fightImageView;

@property (nonatomic, strong) UIView    *dimmingView;
@property (nonatomic, strong) UIView *successBackgroundView;
@property (nonatomic, strong) NSString  *randomString;
@end

@implementation SKMascotFightViewController

- (instancetype)initWithMascot:(SKPet *)mascot {
    self = [super init];
    if (self) {
        _mascot = mascot;
        DLog(@"MascotName:%@", mascot.pet_name);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WS(weakSelf);
    
    self.fightManager = [[SKMascotFightManager alloc] initWithSize:self.view.size];
    self.fightManager.delegate = self;
    
    [self.fightManager startFight];
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@4);
    }];
    
    _fightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_00000", _mascot.pet_name]]];
    _fightImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_fightImageView];
    [_fightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_WIDTH/360*640);
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    
    if (!NO_NETWORK) {
        [[[SKServiceManager sharedInstance] mascotService] getRandomStringWithMascotID:[NSString stringWithFormat:@"%ld", _mascot.pet_id] callback:^(BOOL success, SKResponsePackage *response) {
            if (response.result == 0) {
                //出现怪物
                self.randomString = response.data[@"randomString"];
                [self createMonster];
            } else {
                //未出现
                [self showPromptWithText:nil];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createMonster {
    WS(weakSelf);
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    for (int i = 0; i <20; i++) {
        UIImage *animatedImage = [UIImage imageNamed:[NSString stringWithFormat:@"littlemonster_000%02d", i]];
        [images addObject:animatedImage];
    }
    self.monsterImageView = [[HTImageView alloc] init];
    self.monsterImageView.userInteractionEnabled = YES;
    self.monsterImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.monsterImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMonster:)];
    [self.monsterImageView addGestureRecognizer:tap];
    self.monsterImageView.animationImages = images;
    self.monsterImageView.animationDuration = 0.033 * images.count;
    self.monsterImageView.animationRepeatCount = 0;
    [self.monsterImageView startAnimating];
    [self.monsterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200*SCREEN_WIDTH/360, 200*SCREEN_WIDTH/360));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-360*SCREEN_WIDTH/360);
    }];
}

#pragma mark - Actions

- (void)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickMonster:(UITapGestureRecognizer *)sender {
    self.monsterImageView.hidden = YES;
    //捕捉怪物序列帧
    NSDictionary *imageFramesCount = @{
                                       @"sloth"      :   @100,
                                       @"gluttony"   :   @38,
                                       @"envy"       :   @100,
                                       @"lust"       :   @87,
                                       @"pride"      :   @45,
                                       @"wrath"      :   @45
                                       };
    
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    for (int i = 0; i <[imageFramesCount[_mascot.pet_name] intValue]; i++) {
        UIImage *animatedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_00%03d", _mascot.pet_name,i]];
        [images addObject:animatedImage];
    }
    
    self.fightImageView.animationImages = images;
    self.fightImageView.animationDuration = 0.033 * images.count;
    self.fightImageView.animationRepeatCount = 1;
    [self.fightImageView startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.033 * images.count * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[SKServiceManager sharedInstance] mascotService] mascotBattleWithMascotID:[NSString stringWithFormat:@"%ld", _mascot.pet_id] randomString:self.randomString callback:^(BOOL success, SKResponsePackage *response) {
            if (response.result == 0) {
                //战斗胜利序列帧
                self.successBackgroundView = [[UIView alloc] init];
                self.successBackgroundView.backgroundColor = [UIColor colorWithHex:0x1f1f1f alpha:0.8];
                self.successBackgroundView.layer.cornerRadius = 5.0f;
                [self.view addSubview:self.successBackgroundView];
                [self.view bringSubviewToFront:self.successBackgroundView];
                
                [self.successBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view);
                    make.top.equalTo(@161);
                    make.width.equalTo(@165);
                    make.height.equalTo(@165);
                }];
                
                NSMutableArray<UIImage *> *images = [NSMutableArray array];
                for (int i = 0; i <22; i++) {
                    UIImage *animatedImage = [UIImage imageNamed:[NSString stringWithFormat:@"right_answer_gif%04d",i]];
                    [images addObject:animatedImage];
                }
                UIImageView *fightSuccessImageView = [[UIImageView alloc] init];
                [self.successBackgroundView addSubview:fightSuccessImageView];
                [fightSuccessImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@4);
                    make.top.equalTo(@4);
                    make.width.equalTo(@165);
                    make.height.equalTo(@165);
                }];
                fightSuccessImageView.animationImages = images;
                fightSuccessImageView.animationDuration = 0.05*22;
                fightSuccessImageView.animationRepeatCount = 1;
                [fightSuccessImageView startAnimating];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * 22 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _reward = [SKReward objectWithKeyValues:response.data];
                    if (_reward.gold != nil || _reward.experience_value !=nil || _reward.gemstone!=nil) {
                        [self createBaseRewardViewWithReward:_reward];
                    } else if (_reward.pet){
                        [self createMascotRewardViewWithReward:_reward];
                    }
                });
            } else {
                
            }
        }];
    });
}

#pragma mark - Reward

- (void)createBaseRewardViewWithReward:(SKReward*)reward{
    float height = 192+11;
    
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
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
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_AR_win"]];
    [_dimmingView addSubview:titleImageView];
    
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
    
    //奖励 - 金币、宝石、经验值
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_AR_text"]];
    [_dimmingView addSubview:textImageView];
    [textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleImageView);
        make.top.equalTo(titleImageView.mas_bottom).offset(20);
    }];
    
    UIImageView *coinImageView;
    UIImageView *expImageView;
    UIImageView *gemImageView;
    
    //根据是否存在奖励初始化
    if (reward.gold) {
        height+=28;
        coinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_AR_gold"]];
        [_dimmingView addSubview:coinImageView];
        [coinImageView sizeToFit];
        
        UILabel *coinCountLabel = [UILabel new];
        coinCountLabel.text = reward.gold;
        coinCountLabel.font = MOON_FONT_OF_SIZE(19);
        coinCountLabel.textColor = COMMON_RED_COLOR;
        [coinCountLabel sizeToFit];
        [_dimmingView addSubview:coinCountLabel];
        [coinCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coinImageView.mas_right).offset(6);
            make.centerY.equalTo(coinImageView);
        }];
        
        UIImageView *coinTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_goldtext"]];
        [_dimmingView addSubview:coinTextImageView];
        [coinTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coinCountLabel.mas_right).offset(6);
            make.centerY.equalTo(coinCountLabel);
        }];
    }
    if(reward.experience_value) {
        height+=28;
        expImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_exp"]];
        [_dimmingView addSubview:expImageView];
        [expImageView sizeToFit];
        
        UILabel *expCountLabel = [UILabel new];
        expCountLabel.text = reward.experience_value;
        expCountLabel.font = MOON_FONT_OF_SIZE(19);
        expCountLabel.textColor = COMMON_RED_COLOR;
        [expCountLabel sizeToFit];
        [_dimmingView addSubview:expCountLabel];
        [expCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(expImageView.mas_right).offset(6);
            make.centerY.equalTo(expImageView);
        }];
        
        UIImageView *expTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_exptext"]];
        [_dimmingView addSubview:expTextImageView];
        [expTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(expCountLabel.mas_right).offset(6);
            make.centerY.equalTo(expCountLabel);
        }];
    }
    if(reward.gemstone) {
        height+=28;
        gemImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_monds"]];
        [_dimmingView addSubview:gemImageView];
        [gemImageView sizeToFit];
        
        UILabel *gemCountLabel = [UILabel new];
        gemCountLabel.text = reward.gemstone;
        gemCountLabel.font = MOON_FONT_OF_SIZE(19);
        gemCountLabel.textColor = COMMON_RED_COLOR;
        [gemCountLabel sizeToFit];
        [_dimmingView addSubview:gemCountLabel];
        [gemCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(gemImageView.mas_right).offset(6);
            make.centerY.equalTo(gemImageView);
        }];
        
        UIImageView *gemTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_mondstext"]];
        [_dimmingView addSubview:gemTextImageView];
        [gemTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(gemCountLabel.mas_right).offset(6);
            make.centerY.equalTo(gemCountLabel);
        }];
    }
    
    //布局UI
    if (reward.gold) {
        [coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textImageView.mas_right).offset(6);
            make.centerY.equalTo(textImageView);
        }];
        if (reward.experience_value) {
            [expImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(coinImageView.mas_bottom).offset(9);
                make.left.equalTo(coinImageView);
            }];
            if (reward.gemstone) {
                [gemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(expImageView.mas_bottom).offset(9);
                    make.left.equalTo(expImageView);
                }];
            }
        } else if (reward.gemstone){
            [gemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(coinImageView.mas_bottom).offset(9);
                make.left.equalTo(coinImageView);
            }];
        } else {
            //No reward
        }
    } else if (reward.experience_value) {
        [expImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textImageView.mas_right).offset(6);
            make.centerY.equalTo(textImageView);
        }];
        if (reward.gemstone) {
            [gemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(expImageView.mas_bottom).offset(9);
                make.left.equalTo(expImageView);
            }];
        }
    } else if (reward.gemstone) {
        [gemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textImageView.mas_right).offset(6);
            make.centerY.equalTo(textImageView);
        }];
    }
    
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@248);
        make.height.equalTo(@192);
        make.centerX.equalTo(_dimmingView);
        make.top.equalTo(_dimmingView).offset((SCREEN_HEIGHT-height)/2);
    }];
    
    if (self.reward.pet) {
        [_dimmingView removeGestureRecognizer:tap];
        UITapGestureRecognizer *tap_showMascot = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMascotViewWithReward:)];
        tap_showMascot.numberOfTapsRequired = 1;
        [_dimmingView addGestureRecognizer:tap_showMascot];
        GET_NEW_MASCOT;
    }
}

- (void)createMascotRewardViewWithReward:(SKReward *)reward {
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
    tap.numberOfTapsRequired = 1;
    [_dimmingView addGestureRecognizer:tap];
    
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
}

- (void)showPromptWithText:(NSString*)text {
    [[self.view viewWithTag:9002] removeFromSuperview];
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_ARpage_prompt"]];
    [promptImageView sizeToFit];
    
    UIView *promptView = [UIView new];
    promptView.tag = 9002;
    promptView.size = promptImageView.size;
    promptView.center = self.view.center;
    promptView.alpha = 0;
    [self.view addSubview:promptView];
    
    promptImageView.frame = CGRectMake(0, 0, promptView.width, promptView.height);
    [promptView addSubview:promptImageView];
    
    UILabel *promptLabel = [UILabel new];
    promptLabel.text = text;
    promptLabel.textColor = [UIColor colorWithHex:0xD9D9D9];
    promptLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [promptLabel sizeToFit];
    [promptView addSubview:promptLabel];
    promptLabel.frame = CGRectMake(8.5, 11, promptView.width-17, 57);
    
    promptView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        promptView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:1.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            promptView.alpha = 0;
        } completion:^(BOOL finished) {
            [promptView removeFromSuperview];
        }];
    }];
}

#pragma mark - Action

- (void)removeDimmingView {
    [_dimmingView removeFromSuperview];
    _dimmingView = nil;
    if ([_delegate respondsToSelector:@selector(didDismissMascotFightViewController:)]) {
        [_delegate didDismissMascotFightViewController:self];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showMascotViewWithReward:(SKReward*)reward {
    [self removeDimmingView];
    [self createMascotRewardViewWithReward:reward];
}

#pragma mark - SKMascotFightManagerDelegate

- (void)setupMascotFightViewWithCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer {
    [self.view.layer addSublayer:cameraLayer];
}

@end
