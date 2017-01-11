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
#import "SKRankViewController.h"
#import "HTNotificationController.h"

@interface SKHomepageViewController ()

@property (nonatomic, strong)   HTImageView *headerImageView;
@property (nonatomic, strong)   UIView      *timeCountDownBackView;
@property (nonatomic, strong)   UILabel     *timeCountDownLabel;
@property (nonatomic, strong)   UIButton    *timeLimitLevelButton;
@property (nonatomic, strong)   UIImageView *timeCountDownBackView_isMonday;
@property (nonatomic, strong)   UILabel     *timeCountDownLabel_isMonday;

@property (nonatomic, assign)   uint64_t  endTime;
@property (nonatomic, assign)   BOOL    isMonday;

@property (nonatomic, strong)   SKIndexInfo *indexInfo;
@end

@implementation SKHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)loadData {
    [HTProgressHUD show];
    [[[SKServiceManager sharedInstance] commonService] getHomepageInfoCallBack:^(BOOL success, SKIndexInfo *indexInfo) {
        [HTProgressHUD dismiss];
        if (success) {
            _indexInfo = indexInfo;
            [_headerImageView sd_setImageWithURL:[NSURL URLWithString:indexInfo.index_gif] placeholderImage:[UIImage imageNamed:@"img_homepage_default"]];
            _isMonday = indexInfo.isMonday;
            _endTime = _isMonday==true? indexInfo.monday_end_time : indexInfo.question_end_time;
            _timeCountDownBackView_isMonday.alpha = 0;
            _timeCountDownBackView.alpha = 1-_isMonday;
            [self scheduleCountDownTimer];
            if (_isMonday) {
                [_timeLimitLevelButton addTarget:self action:@selector(showRelaxDayTimeLabel:) forControlEvents:UIControlEventTouchUpInside];
                [_timeLimitLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_locked"] forState:UIControlStateNormal];
            } else {
                [_timeLimitLevelButton addTarget:self action:@selector(timeLimitQuestionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [_timeLimitLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_timer"] forState:UIControlStateNormal];
                [_timeLimitLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_timer_highlight"] forState:UIControlStateHighlighted];
            }
        }
    }];
    
    [[[SKServiceManager sharedInstance] questionService] getAllQuestionListCallback:^(BOOL success, NSInteger answeredQuestion_season1, NSInteger answeredQuestion_season2, NSArray<SKQuestion *> *questionList_season1, NSArray<SKQuestion *> *questionList_season2) {
    }];
    
    //更新用户信息
    [[[SKServiceManager sharedInstance] profileService] getUserBaseInfoCallback:^(BOOL success, SKUserInfo *response) { }];
    [[[SKServiceManager sharedInstance] profileService] getUserInfoDetailCallback:^(BOOL success, SKProfileInfo *response) { }];
    
    if(![UD boolForKey:@"firstLaunch2"]){
        [UD setBool:YES forKey:@"firstLaunch2"];
        //第一次启动
        NSArray *mascotArray = @[@0,@0,@0,@0,@0,@0,@0];
        [UD setObject:@{[[SKStorageManager sharedInstance] getUserID] :mascotArray} forKey:kMascots_Dict];
    }else{
        //不是第一次启动了
    }
}

- (void)scheduleCountDownTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    [self performSelector:@selector(scheduleCountDownTimer) withObject:nil afterDelay:1.0];
    time_t delta = (time_t)_endTime - time(NULL);
    time_t oneHour = 3600;
    time_t hour = delta / oneHour;
    time_t minute = (delta % oneHour) / 60;
    time_t second = delta - hour * oneHour - minute * 60;
    
    if (delta > 0) {
        if (_isMonday) {
            _timeCountDownLabel_isMonday.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
        } else
            _timeCountDownLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
    } else {
        // 过去时间
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:@"homepage"];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
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

- (void)createUI {
    __weak __typeof(self)weakSelf = self;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _headerImageView = [[HTImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_default"]];
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
    [notificationButton addTarget:self action:@selector(notificationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    notificationButton.backgroundColor = COMMON_SEPARATOR_COLOR;
    notificationButton.layer.cornerRadius = 15;
    [notificationButton setImage:[UIImage imageNamed:@"btn_homepage_news"] forState:UIControlStateNormal];
    [notificationButton setImage:[UIImage imageNamed:@"btn_homepage_news_highlight"] forState:UIControlStateHighlighted];
    [notificationButton setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [self.view addSubview:notificationButton];
    [notificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@55);
        make.height.equalTo(@30);
        make.top.equalTo(weakSelf.view.mas_top).offset(14);
        make.left.equalTo(weakSelf.view.mas_left).offset(-15);
    }];
    
    //限时关卡
    _timeLimitLevelButton = [UIButton new];
    [_timeLimitLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_timer"] forState:UIControlStateNormal];
    [self.view addSubview:_timeLimitLevelButton];
    [_timeLimitLevelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(70));
        make.height.equalTo(ROUND_HEIGHT(93));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(_headerImageView.mas_bottom).offset(30);
    }];
    
    //全部关卡
    UIButton *allLevelButton = [UIButton new];
    [allLevelButton addTarget:self action:@selector(allLevelQuestionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [allLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_traditional"] forState:UIControlStateNormal];
    [allLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_traditional_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:allLevelButton];
    [allLevelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_timeLimitLevelButton);
        make.centerY.equalTo(_timeLimitLevelButton);
        make.right.equalTo(_timeLimitLevelButton.mas_left).offset(-25);
    }];
    
    //零仔
    UIButton *mascotButton = [UIButton new];
    [mascotButton addTarget:self action:@selector(mascotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [mascotButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_lingzai"] forState:UIControlStateNormal];
    [mascotButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_lingzai_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:mascotButton];
    [mascotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_timeLimitLevelButton);
        make.centerY.equalTo(_timeLimitLevelButton);
        make.left.equalTo(_timeLimitLevelButton.mas_right).offset(25);
    }];
    
    //排行榜
    UIButton *rankButton = [UIButton new];
    [rankButton addTarget:self action:@selector(rankButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rankButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_top"] forState:UIControlStateNormal];
    [rankButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_top_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:rankButton];
    [rankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_timeLimitLevelButton);
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
        make.size.equalTo(_timeLimitLevelButton);
        make.centerX.equalTo(_timeLimitLevelButton);
        make.centerY.equalTo(rankButton);
    }];
    
    //设置
    UIButton *settingButton = [UIButton new];
    [settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_setting"] forState:UIControlStateNormal];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_setting_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:settingButton];
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_timeLimitLevelButton);
        make.centerX.equalTo(mascotButton);
        make.centerY.equalTo(rankButton);
    }];
    
    //倒计时
    _timeCountDownBackView = [UIView new];
    _timeCountDownBackView.alpha = 0;
    _timeCountDownBackView.layer.cornerRadius = 3;
    _timeCountDownBackView.backgroundColor = [UIColor colorWithHex:0xFF063E];
    [self.view addSubview:_timeCountDownBackView];
    [_timeCountDownBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(60));
        make.height.equalTo(ROUND_HEIGHT(25));
        make.left.equalTo(_timeLimitLevelButton.mas_left).offset(ROUND_WIDTH_FLOAT(35));
        make.bottom.equalTo(_timeLimitLevelButton.mas_bottom).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    _timeCountDownLabel = [UILabel new];
    _timeCountDownLabel.font = MOON_FONT_OF_SIZE(14);
    _timeCountDownLabel.textColor = [UIColor whiteColor];
    _timeCountDownLabel.textAlignment = NSTextAlignmentCenter;
    _timeCountDownLabel.text = @"00:00:00";
    [_timeCountDownBackView addSubview:_timeCountDownLabel];
    [_timeCountDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_timeCountDownBackView);
        make.center.equalTo(_timeCountDownBackView);
    }];
    
    
    //休息日倒计时
    _timeCountDownBackView_isMonday = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_homepage_timer"]];
    _timeCountDownBackView_isMonday.alpha = 0;
    [self.view addSubview:_timeCountDownBackView_isMonday];
    [_timeCountDownBackView_isMonday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(67), ROUND_WIDTH_FLOAT(37)));
        make.left.equalTo(_timeLimitLevelButton);
        make.bottom.equalTo(_timeLimitLevelButton).offset(ROUND_HEIGHT_FLOAT(-84.5));
    }];
    
    _timeCountDownLabel_isMonday = [UILabel new];
    _timeCountDownLabel_isMonday.font = MOON_FONT_OF_SIZE(12);
    _timeCountDownLabel_isMonday.textColor = [UIColor whiteColor];
    _timeCountDownLabel_isMonday.textAlignment = NSTextAlignmentCenter;
    _timeCountDownLabel_isMonday.text = @"00:00:00";
    [_timeCountDownBackView_isMonday addSubview:_timeCountDownLabel_isMonday];
    [_timeCountDownLabel_isMonday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_timeCountDownBackView_isMonday);
        make.height.equalTo(@18);
        make.bottom.equalTo(_timeCountDownBackView_isMonday).offset(-8);
        make.centerX.equalTo(_timeCountDownBackView_isMonday);
    }];
}

#pragma mark - Actions
- (void)showRelaxDayTimeLabel:(UIButton *)sender {
    if (!_isMonday) {
        [UIView animateWithDuration:0.3 animations:^{
            _timeCountDownBackView_isMonday.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _timeCountDownBackView_isMonday.alpha = 0;
            } completion:^(BOOL finished) {
                
            }];
        }];

    } else {
        [UIView animateWithDuration:0.3 animations:^{
            _timeCountDownBackView.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _timeCountDownBackView.alpha = 0;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

- (void)timeLimitQuestionButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"timelimit"];
    SKQuestionViewController *controller = [[SKQuestionViewController alloc] initWithType:SKQuestionTypeTimeLimitLevel questionID:self.indexInfo.qid endTime:_endTime];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)allLevelQuestionButtonClick:(UIButton*)sender {
    [TalkingData trackEvent:@"alllevels"];
    SKAllQuestionViewController *controller = [[SKAllQuestionViewController alloc] init];
    controller.indexInfo = self.indexInfo;
    controller.isMonday = self.isMonday;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)mascotButtonClick:(UIButton*)sender {
    [TalkingData trackEvent:@"lingzai"];
    SKMascotIndexViewController *controller = [[SKMascotIndexViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)rankButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"rankinglist"];
    SKRankViewController *controller = [[SKRankViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)meButtonClick:(UIButton*)sender {
    [TalkingData trackEvent:@"myhomepage"];
    SKProfileIndexViewController *controller = [[SKProfileIndexViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)settingButtonClick:(UIButton*)sender {
    [TalkingData trackEvent:@"setting"];
    SKProfileSettingViewController *controller = [[SKProfileSettingViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)notificationButtonClick:(UIButton*)sender {
    HTNotificationController *controller = [[HTNotificationController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
