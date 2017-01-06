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
@property (nonatomic, strong) SKMascotFightManager *fightManager;

@property (nonatomic, strong) UIImageView *monsterImageView;
@property (nonatomic, strong) UIImageView *fightImageView;

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
    
    [[[SKServiceManager sharedInstance] mascotService] getRandomStringWithMascotID:[NSString stringWithFormat:@"%ld", _mascot.pet_id] callback:^(BOOL success, SKResponsePackage *response) {
        if (response.result == 0) {
            //出现怪物
            [self createMonster];
        } else {
            //未出现
            
        }
    }];
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
    [self.view addSubview:self.monsterImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMonster:)];
    [self.monsterImageView addGestureRecognizer:tap];
    self.monsterImageView.animationImages = images;
    self.monsterImageView.animationDuration = 0.033 * images.count;
    self.monsterImageView.animationRepeatCount = 0;
    [self.monsterImageView startAnimating];
    [self.monsterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 200));
        make.center.equalTo(weakSelf.view);
    }];
}

#pragma mark - Actions

- (void)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickMonster:(UITapGestureRecognizer *)sender {
    NSDictionary *imageFramesCount = @{
                                       @"sloth"      :   @174,
                                       @"gluttony"   :   @60,
                                       @"envy"       :   @115,
                                       @"lust"       :   @87,
                                       @"pride"      :   @45,
                                       @"warth"      :   @45
                                       };
    
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    for (int i = 0; i <[imageFramesCount[_mascot.pet_name] intValue]; i++) {
        NSLog(@"%@",[NSString stringWithFormat:@"%@_00%03d", _mascot.pet_name,i]);
        UIImage *animatedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_00%03d", _mascot.pet_name,i]];
        [images addObject:animatedImage];
    }
    
    self.fightImageView.animationImages = images;
    self.fightImageView.animationDuration = 0.033 * images.count;
    self.fightImageView.animationRepeatCount = 1;
    [self.fightImageView startAnimating];
    
    
}

#pragma mark - SKMascotFightManagerDelegate

- (void)setupMascotFightViewWithCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer {
    [self.view.layer addSublayer:cameraLayer];
}

@end
