//
//  NZMascotMainViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/7.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZMascotMainViewController.h"
#import "HTUIHeader.h"

@interface NZMascotMainViewController ()
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *titleRightButton;
@end

@implementation NZMascotMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI{
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.currentIndex = 0;
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49)];
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundImageView.layer.masksToBounds = YES;
    _backgroundImageView.image = [UIImage imageNamed:@"img_lingzaipage_bg"];
    [self.view addSubview:_backgroundImageView];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    titleView.backgroundColor = COMMON_BG_COLOR;
    [self.view addSubview:titleView];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_title"]];
    [titleView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView);
        make.centerY.equalTo(titleView).offset(10);
    }];
    
    _titleRightButton = [UIButton new];
    [_titleRightButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzlepage_ranking"] forState:UIControlStateNormal];
    [_titleRightButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzlepage_ranking_highlight"] forState:UIControlStateHighlighted];
    [titleView addSubview:_titleRightButton];
    [_titleRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleImageView);
        make.right.equalTo(titleView).offset(-13.5);
    }];
}

@end
