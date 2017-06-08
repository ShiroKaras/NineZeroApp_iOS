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
@property (nonatomic, assign) NSInteger currentIndexTemp;

@property (nonatomic, strong) UIButton *titleRightButton;
@property (nonatomic, strong) UIScrollView *mScrollView;

@property (nonatomic, strong) NSArray<SKMascot*> *mascotArray;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation NZMascotMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self createUI];
}

- (void)dealloc {
//    [self removeObserver:self forKeyPath:@"currentIndex"];
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
    
    NSArray *mascotNameArray = @[@"", @"lingzai", @"sloth", @"pride", @"wrath", @"envy", @"lust", @"gluttony"];
    
    for (int i=1; i<=7; i++) {
        SKMascot *mascot = [SKMascot new];
        mascot.pet_id = [NSString stringWithFormat:@"%i", i];
        mascot.pet_name = mascotNameArray[i];
        NZMascotView *mascotView = [[NZMascotView alloc] initWithFrame:CGRectMake(_mScrollView.width * (i-1), 0, _mScrollView.width, _mScrollView.height) withMascot:mascot];
        mascotView.tag = 100+i-1;
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
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = 7;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0x004d40];
    _pageControl.currentPageIndicatorTintColor = COMMON_GREEN_COLOR;
    _pageControl.userInteractionEnabled = NO;
    [self.view addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(4+64);
        make.height.equalTo(@(8));
    }];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] mascotService] getAllPetsCoopTimeCallback:^(BOOL success, NSArray<SKMascot *> *mascots) {
        _mascotArray = mascots;
        for (int i=0; i<mascots.count; i++) {
            ((NZMascotView*)[self.view viewWithTag:100+i]).deltaTime = mascots[i].last_coop_time == nil? 0:[mascots[i].last_coop_time integerValue];
        }
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
    self.currentIndex = round(point.x/(SCREEN_WIDTH))+1;
    [self updateButtonWithIndex:_currentIndex];
    NSInteger index = round(point.x / (SCREEN_WIDTH));
    _pageControl.currentPage = index;
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGPoint point=scrollView.contentOffset;
//    [((NZMascotView*)[self.view viewWithTag:100+round(point.x/(SCREEN_WIDTH))]) tapMascot];
//}

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
    NZMascotCrimeFileViewController *controller = [[NZMascotCrimeFileViewController alloc] initWithMascot:_mascotArray[_currentIndex-1]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickRankListButton:(UIButton*)sender {
    NZRankViewController *viewController = [[NZRankViewController alloc] initWithType:NZRankListTypeHunter];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Notification

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"currentIndex"]) {
//        NSLog(@"%ld", _currentIndex);
//        if (_currentIndex!=_currentIndexTemp) {
//            [((NZMascotView*)[self.view viewWithTag:100+_currentIndex-1]) tapMascot];
//            _currentIndexTemp = _currentIndex;
//        }
//    }
//}


@end
