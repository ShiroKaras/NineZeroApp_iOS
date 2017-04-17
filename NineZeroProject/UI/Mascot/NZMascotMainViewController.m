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

@interface NZMascotMainViewController () <UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIButton *titleRightButton;
@property (nonatomic, strong) UIScrollView *mScrollView;

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
    
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height-20-49)];
    _mScrollView.contentSize = CGSizeMake(_mScrollView.width*7, _mScrollView.height);
    _mScrollView.delegate = self;
    _mScrollView.pagingEnabled = YES;
    _mScrollView.bounces = NO;
    _mScrollView.showsHorizontalScrollIndicator = NO;
    _mScrollView.showsVerticalScrollIndicator = NO;
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
    [_titleRightButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzlepage_ranking"] forState:UIControlStateNormal];
    [_titleRightButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzlepage_ranking_highlight"] forState:UIControlStateHighlighted];
    [titleView addSubview:_titleRightButton];
    [_titleRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleImageView);
        make.right.equalTo(titleView).offset(-13.5);
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
    self.currentIndex = round(point.x/(SCREEN_WIDTH));
    [self updateButtonWithIndex:self.currentIndex];
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

@end
