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

@interface SKMascotIndexViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *iconBackView;
@property (nonatomic, strong) UIView *diamondBackView;

@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UIButton *fightButton;        //战斗按钮
@property (nonatomic, strong) UIButton *mascotdexButton;    //图鉴按钮
@property (nonatomic, strong) UIButton *skillButton;        //技能按钮
@property (nonatomic, strong) UIButton *infoButton;         //信息按钮

@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, strong) NSArray *mascotNameArray;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation SKMascotIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    WS(weakSelf);
    
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mScrollView.delegate = self;
    _mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 8, SCREEN_HEIGHT);
    _mScrollView.pagingEnabled = YES;
    _mScrollView.showsHorizontalScrollIndicator = NO;
    _mScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mScrollView];
    
    _typeArray = @[@(SKMascotTypeDefault), @(SKMascotTypeEnvy), @(SKMascotTypeGluttony), @(SKMascotTypeGreed), @(SKMascotTypePride), @(SKMascotTypeSloth), @(SKMascotTypeWrath), @(SKMascotTypeLust)];
    _mascotNameArray = @[@"lingzai", @"envy", @"gluttony", @"greed", @"pride", @"sloth", @"wrath", @"lust"];
    
    for (int i = 0; i<8; i++) {
        SKMascotView *mascotView = [[SKMascotView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Type:[_typeArray[i] integerValue]];
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
    
    [self createResourceInfoUI];
    
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
    _infoButton.hidden = YES;
    [_infoButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_info"] forState:UIControlStateNormal];
    [_infoButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_info_highlight"] forState:UIControlStateHighlighted];
    [_infoButton sizeToFit];
    [self.view addSubview:_infoButton];
    [_infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.right.equalTo(weakSelf.view.mas_right).offset(-4);
    }];
}

- (void)createResourceInfoUI {
    //右上角
    _iconBackView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-83.5, 14, 83.5, 30)];
    _iconBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    [self.view addSubview:_iconBackView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_iconBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _iconBackView.bounds;
    maskLayer.path = maskPath.CGPath;
    _iconBackView.layer.mask = maskLayer;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_gold"]];
    [iconImageView sizeToFit];
    [_iconBackView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconBackView.mas_centerY);
        make.right.equalTo(_iconBackView.mas_right).offset(-8);
    }];
    
    UILabel *iconCountLabel = [[UILabel alloc] init];
    iconCountLabel.font = MOON_FONT_OF_SIZE(18);
    iconCountLabel.textColor = [UIColor whiteColor];
    iconCountLabel.text = @"9999";
    [iconCountLabel sizeToFit];
    [_iconBackView addSubview:iconCountLabel];
    [iconCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconBackView);
        make.right.equalTo(iconImageView.mas_left).offset(-6);
    }];
    
    _diamondBackView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-83.5, 14+30+6, 83.5, 30)];
    _diamondBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    [self.view addSubview:_diamondBackView];
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_diamondBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _diamondBackView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    _diamondBackView.layer.mask = maskLayer2;
    
    UIImageView *diamondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_diamonds"]];
    [diamondImageView sizeToFit];
    [_diamondBackView addSubview:diamondImageView];
    [diamondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_diamondBackView.mas_centerY);
        make.right.equalTo(_diamondBackView.mas_right).offset(-8);
    }];
    
    UILabel *diamondCountLabel = [[UILabel alloc] init];
    diamondCountLabel.font = MOON_FONT_OF_SIZE(18);
    diamondCountLabel.textColor = [UIColor whiteColor];
    diamondCountLabel.text = @"9999";
    [diamondCountLabel sizeToFit];
    [_diamondBackView addSubview:diamondCountLabel];
    [diamondCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_diamondBackView);
        make.right.equalTo(diamondImageView.mas_left).offset(-6);
    }];
}

- (void)skillButtonClick:(UIButton*)sender {
    SKMascotSkillView *skillView = [[SKMascotSkillView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Type:[_typeArray[_currentIndex] integerValue]];
    [KEY_WINDOW addSubview:skillView];
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
    if(point.x>8*(SCREEN_WIDTH)){
        point.x=(SCREEN_WIDTH)*8;
        scrollView.contentOffset=point;
    }
    //根据图片坐标判断页数
    _currentIndex = round(point.x/(SCREEN_WIDTH));
    [self updateButtonWithIndex:_currentIndex];
}

- (void)updateButtonWithIndex:(NSInteger)index {
    if (index == SKMascotTypeDefault) {
        _iconBackView.hidden = NO;
        _diamondBackView.hidden = NO;
        _infoButton.hidden = YES;
        _fightButton.hidden = YES;
        [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_lingzaiskill"] forState:UIControlStateNormal];
        [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_lingzaiskill_highlight"] forState:UIControlStateHighlighted];
    } else {
        _iconBackView.hidden = YES;
        _diamondBackView.hidden = YES;
        _infoButton.hidden = NO;
        _fightButton.hidden = NO;
        [_fightButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_lingzaipage_%@fight", _mascotNameArray[index]]] forState:UIControlStateNormal];
        [_fightButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_lingzaipage_%@fight_highlight", _mascotNameArray[index]]] forState:UIControlStateHighlighted];
        [_skillButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_lingzaipage_%@skill", _mascotNameArray[index]]] forState:UIControlStateNormal];
        [_skillButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_lingzaipage_%@skill_highlight", _mascotNameArray[index]]] forState:UIControlStateHighlighted];
    }
}

#pragma mark - Actions

- (void)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
