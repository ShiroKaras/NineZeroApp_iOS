//
//  SKMascotIndexViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/14.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKMascotIndexViewController.h"
#import "HTUIHeader.h"

#import "SKMascotView.h"

#define MASCOT_VIEW_DEFAULT 100

@interface SKMascotIndexViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UIButton *fightButton;        //战斗按钮
@property (nonatomic, strong) UIButton *mascotdexButton;    //图鉴按钮
@property (nonatomic, strong) UIButton *skillButton;        //技能按钮
@property (nonatomic, strong) UIButton *infoButton;         //信息按钮

@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, strong) NSArray *mascotNameArray;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray<SKPet*>   *mascotArray;
@end

@implementation SKMascotIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    //更新个人主页信息
    [[[SKServiceManager sharedInstance] profileService] getUserInfoDetailCallback:^(BOOL success, SKProfileInfo *response) { }];
    [[[SKServiceManager sharedInstance] mascotService] getMascotsCallback:^(BOOL success, NSArray<SKPet *> *mascotArray) {
        self.mascotArray = mascotArray;
    }];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    WS(weakSelf);
    
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mScrollView.delegate = self;
    _mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 7, SCREEN_HEIGHT);
    _mScrollView.pagingEnabled = YES;
    _mScrollView.showsHorizontalScrollIndicator = NO;
    _mScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mScrollView];
    
    _typeArray = @[@(SKMascotTypeDefault), @(SKMascotTypeSloth), @(SKMascotTypePride), @(SKMascotTypeWrath), @(SKMascotTypeGluttony), @(SKMascotTypeLust), @(SKMascotTypeEnvy)];
    _mascotNameArray = @[@"lingzai", @"sloth", @"pride", @"wrath", @"gluttony", @"lust", @"envy"];
    
    for (int i = 0; i<7; i++) {
        SKMascotView *mascotView = [[SKMascotView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Type:[_typeArray[i] integerValue]];
        mascotView.tag = 100+i;
        [_mScrollView addSubview:mascotView];
    }
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@4);
    }];
    
    //按钮组
    _fightButton = [UIButton new];
    _fightButton.hidden = YES;
    [self.view addSubview:_fightButton];
    [_fightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@70);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-30);
    }];
    
    _mascotdexButton = [UIButton new];
    [_mascotdexButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_albums"] forState:UIControlStateNormal];
    [_mascotdexButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_albums_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:_mascotdexButton];
    [_mascotdexButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@60);
        make.left.equalTo(@16);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-12);
    }];
    
    _skillButton = [UIButton new];
    [_skillButton addTarget:self action:@selector(skillButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_skillButton];
    [self updateButtonWithIndex:0];
    [_skillButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@60);
        make.right.equalTo(weakSelf.view.mas_right).offset(-16);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-12);
    }];
    
    _infoButton = [UIButton new];
    [_infoButton addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_infoButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_info"] forState:UIControlStateNormal];
    [_infoButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_info_highlight"] forState:UIControlStateHighlighted];
    [_infoButton sizeToFit];
    [self.view addSubview:_infoButton];
    [_infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.right.equalTo(weakSelf.view.mas_right).offset(-4);
    }];
}

- (void)skillButtonClick:(UIButton*)sender {
    SKMascotSkillView *skillView = [[SKMascotSkillView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Type:[_typeArray[_currentIndex] integerValue] isHad:self.mascotArray[_currentIndex].user_haved];
    [self.view addSubview:skillView];
}

- (void)infoButtonClick:(UIButton *)sender {
    SKMascotInfoView *infoView = [[SKMascotInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Type:[_typeArray[_currentIndex] integerValue]];
    [self.view addSubview:infoView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //得到图片移动相对原点的坐标
    CGPoint point=scrollView.contentOffset;
    //移动不能超过左边;
    //    if(point.x<0){
    //        point.x=0;
    //        scrollView.contentOffset=point;
    //    }
    //移动不能超过右边
    if(point.x>7*(SCREEN_WIDTH)){
        point.x=(SCREEN_WIDTH)*7;
        scrollView.contentOffset=point;
    }
    //根据图片坐标判断页数
    _currentIndex = round(point.x/(SCREEN_WIDTH));
    [self updateButtonWithIndex:_currentIndex];
}

- (void)updateButtonWithIndex:(NSInteger)index {
    if (index == SKMascotTypeDefault) {
        [((SKMascotView*)[self.view viewWithTag:MASCOT_VIEW_DEFAULT]) show];
        _fightButton.hidden = YES;
        [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_lingzaiskill"] forState:UIControlStateNormal];
        [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_lingzaiskill_highlight"] forState:UIControlStateHighlighted];
    } else {
        _fightButton.hidden = NO;
        [_fightButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_lingzaipage_%@fight", _mascotNameArray[index]]] forState:UIControlStateNormal];
        [_fightButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_lingzaipage_%@fight_highlight", _mascotNameArray[index]]] forState:UIControlStateHighlighted];
        [_skillButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_lingzaipage_%@skill", _mascotNameArray[index]]] forState:UIControlStateNormal];
        [_skillButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_lingzaipage_%@skill_highlight", _mascotNameArray[index]]] forState:UIControlStateHighlighted];
        if (self.mascotArray[index].user_haved) {
            [((SKMascotView*)[self.view viewWithTag:MASCOT_VIEW_DEFAULT+index]) show];
        }
    }
}

#pragma mark - Actions

- (void)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
