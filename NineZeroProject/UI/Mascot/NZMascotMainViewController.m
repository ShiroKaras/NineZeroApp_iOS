//
//  NZMascotMainViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/7.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZMascotMainViewController.h"
#import "HTUIHeader.h"

#import "NZMascotView.h"
#import "NZMascotCrimeFileViewController.h"
#import "NZRankViewController.h"

@interface NZMascotMainViewController () <UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIButton *titleRightButton;
@property (nonatomic, strong) UIScrollView *mScrollView;

@property (nonatomic, strong) NSArray<SKMascot*> *mascotArray;

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.currentIndex = 0;
    
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, self.view.width, self.view.height+20-49)];
    _mScrollView.contentSize = CGSizeMake(self.view.width*7, self.view.height-49);
    _mScrollView.showsHorizontalScrollIndicator = NO;
    _mScrollView.showsVerticalScrollIndicator = NO;
    _mScrollView.bounces = NO;
    _mScrollView.pagingEnabled = YES;
    _mScrollView.delegate = self;
    [self.view addSubview:_mScrollView];
    
    for (int i = 0; i<7; i++) {
        NZMascotView *mascotView = [[NZMascotView alloc] initWithFrame:CGRectMake(_mScrollView.width * i, 0, _mScrollView.width, _mScrollView.height) withMascot:nil];
        mascotView.tag = 100+i;
        [_mScrollView addSubview:mascotView];
    }
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    titleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleView];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_title"]];
    [titleView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView);
        make.centerY.equalTo(titleView).offset(10);
    }];
    
    _titleRightButton = [UIButton new];
    [_titleRightButton addTarget:self action:@selector(didClickTopRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [_titleRightButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzlepage_ranking"] forState:UIControlStateNormal];
    [_titleRightButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzlepage_ranking_highlight"] forState:UIControlStateHighlighted];
    [titleView addSubview:_titleRightButton];
    [_titleRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleImageView);
        make.right.equalTo(titleView).offset(-13.5);
    }];
    
    [self loadData];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] mascotService] getAllPetsCoopTimeCallback:^(BOOL success, NSArray<SKMascot *> *mascots) {
        _mascotArray = mascots;
        //NSLog(@"%@", mascots[0].pet_last_coop_time);
    }];
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
    _currentIndex = round(point.x/(SCREEN_WIDTH))+1;
    [self updateButtonWithIndex:_currentIndex];
}

- (void)updateButtonWithIndex:(NSInteger)index {
    if (index == SKMascotTypeDefault) {
        [_titleRightButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzlepage_ranking"] forState:UIControlStateNormal];
        [_titleRightButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzlepage_ranking_highlight"] forState:UIControlStateHighlighted];
    } else {
        [_titleRightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_archives"] forState:UIControlStateNormal];
        [_titleRightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_archives_highlight"] forState:UIControlStateHighlighted];
    }
}

- (void)didClickTopRightButton:(UIButton *)sender {
    if (self.currentIndex == SKMascotTypeDefault) {
        [self didClickRankListButton:sender];
    } else {
        [self didClickMascotCrimeFileButton:sender];
    }
}

- (void)didClickMascotCrimeFileButton:(UIButton*)sender {
    NZMascotCrimeFileViewController *controller = [[NZMascotCrimeFileViewController alloc] initWithMascot:_mascotArray[_currentIndex]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickRankListButton:(UIButton*)sender {
    NZRankViewController *viewController = [[NZRankViewController alloc] initWithType:NZRankListTypeHunter];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
