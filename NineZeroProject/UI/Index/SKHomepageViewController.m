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
		setStatusBarHidden:YES
		     withAnimation:UIStatusBarAnimationNone];
	[self.navigationController.navigationBar setHidden:YES];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
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
    
    //任务按钮
    UIButton *taskButton = [UIButton new];
    taskButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:taskButton];
    [taskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(@20);
        make.left.equalTo(@8);
    }];
    
    //切换城市按钮
    UIButton *changeCityButton = [UIButton new];
    changeCityButton.backgroundColor = [UIColor redColor];
    [changeCityButton addTarget:self action:@selector(didClickedChangeCityButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeCityButton];
    [changeCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(@20);
    }];
}

#pragma mark - Actions

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
            [cityView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(self.view.width, 60));
                make.top.mas_equalTo(80+60*i);
                make.left.equalTo(0);
            }];
            [cityView.superview layoutIfNeeded];//强制绘制
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

- (void)removeDimmingView {
    [UIView animateWithDuration:0.3 animations:^{
        _dimmingView.alpha = 0;
    } completion:^(BOOL finished) {
        [_dimmingView removeFromSuperview];
    }];
}

#pragma mark - panGestureRecognized

@end
