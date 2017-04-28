//
//  SKHomepageViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/11.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKHomepageViewController.h"
#import "HTUIHeader.h"

#import "JPUSHService.h"
#import "SKSwipeViewController.h"
#import "NZTaskViewController.h"
#import "SKSwipeViewController.h"

@interface SKHomepageViewController ()
@property (nonatomic, strong) UIView *dimmingView;
@end

@implementation SKHomepageViewController {
    UIButton *_selectedButton;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[TalkingData trackPageBegin:@"homepage"];
	[[UIApplication sharedApplication]
		setStatusBarHidden:NO
		     withAnimation:UIStatusBarAnimationNone];
	[self.navigationController.navigationBar setHidden:YES];
	//[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[TalkingData trackPageEnd:@"homepage"];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)loadData {
    
}

- (void)createUI {
	__weak __typeof(self) weakSelf = self;
	self.view.backgroundColor = COMMON_BG_COLOR;
    
    //切换城市按钮
    UIButton *changeCityButton = [UIButton new];
    [changeCityButton setBackgroundImage:[UIImage imageNamed:@"btn_local_beijing"] forState:UIControlStateNormal];
    [changeCityButton addTarget:self action:@selector(didClickedChangeCityButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeCityButton];
    [changeCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(82, 34));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(@25);
    }];
    
    //任务按钮
    UIButton *taskButton = [UIButton new];
    [taskButton addTarget:self action:@selector(didClickTaskButton:) forControlEvents:UIControlEventTouchUpInside];
    [taskButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_taskbook"] forState:UIControlStateNormal];
    [taskButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_taskbook_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:taskButton];
    [taskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 27));
        make.centerY.equalTo(changeCityButton);
        make.left.equalTo(@13.5);
    }];
    
    //扫一扫按钮
    UIButton *swipeButton = [UIButton new];
    [swipeButton addTarget:self action:@selector(didClickSwipeButton:) forControlEvents:UIControlEventTouchUpInside];
    [swipeButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_scanning"] forState:UIControlStateNormal];
    [self.view addSubview:swipeButton];
    [swipeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(72, 72));
        make.bottom.equalTo(@(-68));
        make.centerX.equalTo(weakSelf.view);
    }];
}

#pragma mark - Actions

- (void)removeDimmingView {
    [UIView animateWithDuration:0.3 animations:^{
        _dimmingView.alpha = 0;
    } completion:^(BOOL finished) {
        [_dimmingView removeFromSuperview];
    }];
}

- (void)didClickedChangeCityButton:(UIButton *)sender {
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    _dimmingView.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:_dimmingView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
    [_dimmingView addGestureRecognizer:tap];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _dimmingView.width, _dimmingView.height)];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.8;
    [_dimmingView addSubview:alphaView];
    
    //Cities
    for (int i=0; i<6; i++) {
        UIButton *cityView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
        cityView.tag = 100+i;
        [cityView setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        cityView.backgroundColor = [UIColor grayColor];
        [_dimmingView addSubview:cityView];
        
        [UIView animateWithDuration:0.3 animations:^{
            cityView.top = 80+60*i;
        }];
    }
    
    _selectedButton = [self.view viewWithTag:100];
    [_selectedButton setBackgroundColor:COMMON_GREEN_COLOR];
    [_selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //TitleView
    UIView *changeCityTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    changeCityTitleView.backgroundColor = [UIColor blackColor];
    [_dimmingView addSubview:changeCityTitleView];
}

- (void)didClickTaskButton:(UIButton*)sender {
    NZTaskViewController *controller = [[NZTaskViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickSwipeButton:(UIButton *)sender {
    SKSwipeViewController *controller = [[SKSwipeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - panGestureRecognized

@end
