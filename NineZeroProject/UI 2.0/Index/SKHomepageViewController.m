//
//  SKHomepageViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/11.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKHomepageViewController.h"
#import "HTUIHeader.h"

#import "SKAllQuestionViewController.h"
#import "SKMascotIndexViewController.h"
#import "SKLoginRootViewController.h"
#import "SKQuestionViewController.h"
#import "SKProfileIndexViewController.h"
#import "SKProfileSettingViewController.h"

@interface SKHomepageViewController ()

@property (nonatomic, strong)   HTImageView *headerImageView;
@property (nonatomic, strong)   UILabel   *timeCountDownLabel;

@property (nonatomic, assign)   time_t  endTime;
@property (nonatomic, assign)   BOOL    isMonday;

@end

@implementation SKHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] commonService] getHomepageInfoCallBack:^(SKIndexInfo *indexInfo) {
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:indexInfo.index_gif]];
        _isMonday = indexInfo.isMonday;
        _endTime = _isMonday==true? indexInfo.monday_end_time : indexInfo.question_end_time;
        [self scheduleCountDownTimer];
    }];
}

- (void)scheduleCountDownTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    [self performSelector:@selector(scheduleCountDownTimer) withObject:nil afterDelay:1.0];
    time_t delta = _endTime - time(NULL);
    time_t oneHour = 3600;
    time_t hour = delta / oneHour;
    time_t minute = (delta % oneHour) / 60;
    time_t second = delta - hour * oneHour - minute * 60;
    
    if (delta > 0) {
        if (_isMonday) {
            _timeCountDownLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
        } else
            _timeCountDownLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
    } else {
        // 过去时间
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    __weak __typeof(self)weakSelf = self;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _headerImageView = [[HTImageView alloc] init];
    _headerImageView.backgroundColor = [UIColor redColor];
    //[headerImageView setAnimatedImageWithName:@"img_homepage_gif"];
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_headerImageView];
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.equalTo(weakSelf.view.mas_width).offset(4);
    }];
    
    UIButton *notificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [notificationButton setImage:[UIImage imageNamed:@"btn_homepage_news"] forState:UIControlStateNormal];
    [notificationButton setImage:[UIImage imageNamed:@"btn_homepage_news_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:notificationButton];
    [notificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@30);
        make.top.equalTo(weakSelf.view.mas_top).offset(14);
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    
    //限时关卡
    UIButton *timeLimitLevelButton = [UIButton new];
    [timeLimitLevelButton addTarget:self action:@selector(timeLimitQuestionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [timeLimitLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_timer"] forState:UIControlStateNormal];
    [timeLimitLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_timer_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:timeLimitLevelButton];
    [timeLimitLevelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(70));
        make.height.equalTo(ROUND_HEIGHT(93));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(_headerImageView.mas_bottom).offset(30);
    }];
    
    //全部关卡
    UIButton *allLevelButton = [UIButton new];
    [allLevelButton addTarget:self action:@selector(allLevelQuestionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [allLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_traditional_level"] forState:UIControlStateNormal];
    [allLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_traditional_level_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:allLevelButton];
    [allLevelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(timeLimitLevelButton);
        make.centerY.equalTo(timeLimitLevelButton);
        make.right.equalTo(timeLimitLevelButton.mas_left).offset(-25);
    }];
    
    //零仔
    UIButton *mascotButton = [UIButton new];
    [mascotButton addTarget:self action:@selector(mascotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [mascotButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_lingzai"] forState:UIControlStateNormal];
    [mascotButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_lingzai_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:mascotButton];
    [mascotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(timeLimitLevelButton);
        make.centerY.equalTo(timeLimitLevelButton);
        make.left.equalTo(timeLimitLevelButton.mas_right).offset(25);
    }];
    
    //排行榜
    UIButton *rankButton = [UIButton new];
    [rankButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_top"] forState:UIControlStateNormal];
    [rankButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_top_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:rankButton];
    [rankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(timeLimitLevelButton);
        make.top.equalTo(allLevelButton.mas_bottom).offset(16);
        make.centerX.equalTo(allLevelButton);
    }];
    
    //我
    UIButton *meButton = [UIButton new];
    [meButton addTarget:self action:@selector(meButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [meButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_me"] forState:UIControlStateNormal];
    [meButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_me_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:meButton];
    [meButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(timeLimitLevelButton);
        make.centerX.equalTo(timeLimitLevelButton);
        make.centerY.equalTo(rankButton);
    }];
    
    //设置
    UIButton *settingButton = [UIButton new];
    [settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_setting"] forState:UIControlStateNormal];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_setting_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:settingButton];
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(timeLimitLevelButton);
        make.centerX.equalTo(mascotButton);
        make.centerY.equalTo(rankButton);
    }];
    
    //倒计时
    UIView *timeCountDownBackView = [UIView new];
    timeCountDownBackView.layer.cornerRadius = 3;
    timeCountDownBackView.backgroundColor = [UIColor colorWithHex:0xFF063E];
    [self.view addSubview:timeCountDownBackView];
    [timeCountDownBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(60));
        make.height.equalTo(ROUND_HEIGHT(25));
        make.left.equalTo(timeLimitLevelButton.mas_left).offset(ROUND_WIDTH_FLOAT(35));
        make.bottom.equalTo(timeLimitLevelButton.mas_bottom).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    _timeCountDownLabel = [UILabel new];
    _timeCountDownLabel.font = MOON_FONT_OF_SIZE(14);
    _timeCountDownLabel.textColor = [UIColor whiteColor];
    _timeCountDownLabel.textAlignment = NSTextAlignmentCenter;
    _timeCountDownLabel.text = @"12:00:00";
    [self.view addSubview:_timeCountDownLabel];
    [_timeCountDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(timeCountDownBackView);
        make.center.equalTo(timeCountDownBackView);
    }];
    
}

#pragma mark - Actions

- (void)timeLimitQuestionButtonClick:(UIButton *)sender {
    SKQuestionViewController *controller = [[SKQuestionViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)allLevelQuestionButtonClick:(UIButton*)sender {
    SKAllQuestionViewController *controller = [[SKAllQuestionViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)mascotButtonClick:(UIButton*)sender {
    SKMascotIndexViewController *controller = [[SKMascotIndexViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)meButtonClick:(UIButton*)sender {
    SKProfileIndexViewController *controller = [[SKProfileIndexViewController alloc] init];
    HTNavigationController *rootController = [[HTNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:rootController animated:YES completion:nil];
}

- (void)settingButtonClick:(UIButton*)sender {
    SKProfileSettingViewController *controller = [[SKProfileSettingViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
