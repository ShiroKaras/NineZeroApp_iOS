//
//  SKIndexViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/9/2.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKIndexViewController.h"
#import "SKQuestionPageViewController.h"
#import "HTPreviewCardController.h"
#import "HTMascotDisplayController.h"
#import "HTProfileRootController.h"
#import "HTProfileSettingController.h"
#import "HTNotificationController.h"
#import "HTProfileRankController.h"
#import "SKActivityNotificationView.h"

#import "HTUIHeader.h"

#define EVERYDAY_FIRST_ACTIVITY_NOTIFICATION @"EVERYDAY_FIRST_ACTIVITY_NOTIFICATION"

@interface SKIndexViewController () <HTPreviewCardControllerDelegate>

@property (nonatomic, strong) UIButton *timerLevelButton;
@property (nonatomic, strong) UIView   *timerLevelCountView;
@property (nonatomic, strong) UIView   *relaxDayCountView;

@property (nonatomic, strong) NSArray<HTQuestion*>* questionList;
@property (nonatomic, strong) HTQuestionInfo *questionInfo;
@property (nonatomic, strong) HTUserInfo *userInfo;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) uint64_t endTime;
@end

@implementation SKIndexViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [HTProgressHUD show];
    [self createUI];
    [self loadData];
    [self judgementDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Create UI
- (void)loadData {
    [[[HTServiceManager sharedInstance] questionService] getQuestionInfoWithCallback:^(BOOL success, HTQuestionInfo *questionInfo) {
        [self setQuestionInfo:questionInfo];
        time_t delta = questionInfo.endTime - time(NULL);
        time_t oneHour = 3600;
        time_t hour = delta / oneHour;
        time_t minute = (delta % oneHour) / 60;
        time_t second = delta - hour * oneHour - minute * 60;
        
        //TODO: 更改TimeView
        if (delta > 0) {
            _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
        }
        _questionInfo = questionInfo;
    }];
    
    [[[HTServiceManager sharedInstance] questionService] getQuestionListWithPage:0 count:0 callback:^(BOOL success, NSArray<HTQuestion *> *questionList) {
        self.questionList = questionList;
        for (HTQuestion *q in questionList) {
            DLog(@"%ld", q.rewardID);
            DLog(@"%i", q.isPassed);
        }
    }];
    
    [[[HTServiceManager sharedInstance] profileService] getUserInfo:^(BOOL success, HTUserInfo *userInfo) {
        if (success) {
            _userInfo = userInfo;
            [[HTStorageManager sharedInstance] setUserInfo:userInfo];
        }
    }];
    
    [[[HTServiceManager sharedInstance] questionService] getIsRelaxDay:^(BOOL success, HTResponsePackage *response) {
        NSString *dictData = [NSString stringWithFormat:@"%@", response.data];
        if (success && response.resultCode == 0) {
            if ([dictData isEqualToString:@"1"]) {
                [HTProgressHUD dismiss];
                [[[HTServiceManager sharedInstance] questionService] getRelaxDayInfo:^(BOOL success, HTResponsePackage *response) {
                    if (success && response.resultCode == 0) {
                        NSDictionary *dataDict = response.data;
                        _endTime = (time_t)[dataDict[@"end_time"] integerValue];
                        [self scheduleCountDownTimer];
                        _relaxDayCountView.alpha = 1;
                    }
                }];
                
                [_timerLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_locked"] forState:UIControlStateNormal];
                [_timerLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_locked"] forState:UIControlStateHighlighted];

            } else if ([dictData isEqualToString:@"0"]) {
                [HTProgressHUD dismiss];
                _timerLevelCountView.alpha = 1;
                
                [_timerLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_timer_level"] forState:UIControlStateNormal];
                [_timerLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_timer_level_highlight"] forState:UIControlStateHighlighted];
                
            } else {
//                [HTProgressHUD dismiss];
            }
        }
    }];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor colorWithHex:0x0E0E0E];
    __weak __typeof(self)weakSelf = self;
    
    //通知按钮
    UIButton *notificationButton = [UIButton new];
    [notificationButton setImage:[UIImage imageNamed:@"btn_homepage_notification"] forState:UIControlStateNormal];
    [notificationButton setImage:[UIImage imageNamed:@"btn_homepage_notification_highlight"] forState:UIControlStateHighlighted];
    [notificationButton sizeToFit];
    [notificationButton addTarget:self action:@selector(notificationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notificationButton];
    
    [notificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(10);
        make.right.equalTo(weakSelf.view).offset(-10);
    }];
    
    //底部Banner图
    UIImageView *bannerImageView = [UIImageView new];
    bannerImageView.image = [UIImage imageNamed:@"banner_homepage"];
    bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bannerImageView sizeToFit];
    [self.view addSubview:bannerImageView];
    
    [bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(SCREEN_WIDTH/320*173);
    }];

    //排行榜按钮
    UIButton *rankButton = [UIButton new];
    [rankButton setImage:[UIImage imageNamed:@"btn_homepage_top"] forState:UIControlStateNormal];
    [rankButton setImage:[UIImage imageNamed:@"btn_homepage_top_highlight"] forState:UIControlStateHighlighted];
    [rankButton sizeToFit];
    [rankButton addTarget:self action:@selector(rankButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rankButton];
    
    [rankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.bottom.equalTo(weakSelf.view).offset(-10);
    }];
    
    //设置按钮
    UIButton *settingButton = [UIButton new];
    [settingButton setImage:[UIImage imageNamed:@"btn_homepage_setting"] forState:UIControlStateNormal];
    [settingButton setImage:[UIImage imageNamed:@"btn_homepage_setting_highlight"] forState:UIControlStateHighlighted];
    [settingButton sizeToFit];
    [settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];
    
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.bottom.equalTo(weakSelf.view).offset(-10);
    }];
    
    //主功能按钮
    UIView *dimmingView = [UIView new];
    dimmingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:dimmingView];
    
    UIButton *allLevelButton = [UIButton new];
    [allLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_traditional_level"] forState:UIControlStateNormal];
    [allLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_traditional_level_highlight"] forState:UIControlStateHighlighted];
//    [allLevelButton sizeToFit];
    [allLevelButton addTarget:self  action:@selector(allLevelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [dimmingView addSubview:allLevelButton];
    
    _timerLevelButton = [UIButton new];
    [_timerLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_timer_level"] forState:UIControlStateNormal];
    [_timerLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_timer_level_highlight"] forState:UIControlStateHighlighted];
//    [timerLevelButton sizeToFit];
    [_timerLevelButton addTarget:self action:@selector(timerLevelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [dimmingView addSubview:_timerLevelButton];
    
    UIButton *mascotButton = [UIButton new];
    [mascotButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_lingzai"] forState:UIControlStateNormal];
    [mascotButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_lingzai_highlight"] forState:UIControlStateHighlighted];
//    [mascotButton sizeToFit];
    [mascotButton addTarget:self action:@selector(mascotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [dimmingView addSubview:mascotButton];
    
    UIButton *meButton = [UIButton new];
    [meButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_me"] forState:UIControlStateNormal];
    [meButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_me_highlight"] forState:UIControlStateHighlighted];
//    [meButton sizeToFit];
    [meButton addTarget:self action:@selector(meButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [dimmingView addSubview:meButton];
    
    [dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.bottom.equalTo(weakSelf.view).offset(-180);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
    }];
    
    [allLevelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(100));
        make.height.equalTo(ROUND_HEIGHT(130));
        make.bottom.equalTo(dimmingView.mas_centerY).offset(-18);
        make.right.equalTo(dimmingView.mas_centerX).offset(-20);
    }];
    
    [_timerLevelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(100));
        make.height.equalTo(ROUND_HEIGHT(130));
        make.top.equalTo(allLevelButton);
        make.left.equalTo(dimmingView.mas_centerX).offset(20);
    }];
    
    [mascotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(100));
        make.height.equalTo(ROUND_HEIGHT(130));
        make.top.equalTo(dimmingView.mas_centerY).offset(18);
        make.centerX.equalTo(allLevelButton);
    }];
    
    [meButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(100));
        make.height.equalTo(ROUND_HEIGHT(130));
        make.top.equalTo(mascotButton);
        make.centerX.equalTo(_timerLevelButton);
    }];
    
    //休息日倒计时
    _relaxDayCountView = [UIView new];
    _relaxDayCountView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_relaxDayCountView];
    
    UIImageView *countDownImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_homepage_timer"]];
    [_relaxDayCountView sizeToFit];
    [_relaxDayCountView addSubview:countDownImageView];
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"00:00:00";
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = MOON_FONT_OF_SIZE(16);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_relaxDayCountView addSubview:_timeLabel];
    
    _relaxDayCountView.alpha = 0;
    
    [_relaxDayCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(80));
        make.height.equalTo(ROUND_HEIGHT(41));
        make.right.equalTo(_timerLevelButton.mas_right).offset(-20);
        make.bottom.equalTo(_timerLevelButton.mas_top).offset(9);
    }];
    
    [countDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_relaxDayCountView);
        make.height.equalTo(_relaxDayCountView);
        make.center.equalTo(_relaxDayCountView);
    }];

    
    //限时关卡倒计时
    _timerLevelCountView = [UIView new];
    _timerLevelCountView.backgroundColor = [UIColor colorWithHex:0xFF063E];
    _timerLevelCountView.layer.cornerRadius = 5;
    [self.view addSubview:_timerLevelCountView];
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"00:00:00";
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = MOON_FONT_OF_SIZE(16);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_timerLevelCountView addSubview:_timeLabel];
    
    _timerLevelCountView.alpha = 0;
    
    [_timerLevelCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(72));
        make.height.equalTo(ROUND_HEIGHT(29));
        make.left.equalTo(_timerLevelButton.mas_centerX);
        make.centerY.equalTo(_timerLevelButton.mas_top);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_timerLevelCountView);
        make.height.equalTo(_timerLevelCountView);
        make.center.equalTo(_timerLevelCountView);
    }];
}

#pragma mark - Time

- (void)setQuestionInfo:(HTQuestionInfo *)questionInfo {
    _endTime = (time_t)questionInfo.endTime;
    [self scheduleCountDownTimer];
}

- (void)scheduleCountDownTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    [self performSelector:@selector(scheduleCountDownTimer) withObject:nil afterDelay:1.0];
    time_t delta = _endTime - time(NULL);
    time_t oneHour = 3600;
    time_t hour = delta / oneHour;
    time_t minute = (delta % oneHour) / 60;
    time_t second = delta - hour * oneHour - minute * 60;
    
    //TODO: 更改TimeView
    if (delta > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
    } else {
        // 过去时间
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scheduleCountDownTimer) object:nil];
    }
}

- (void)judgementDate {
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    if (![locationString isEqualToString:[UD objectForKey:EVERYDAY_FIRST_ACTIVITY_NOTIFICATION]]) {
        [[[HTServiceManager sharedInstance] profileService] getActivityNotification:^(BOOL success, HTResponsePackage *response) {
            if (success) {
                if (response.resultCode == 0) {
                    SKActivityNotificationView *view = [[SKActivityNotificationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    [view.contentImageView sd_setImageWithURL:[NSURL URLWithString:response.data[@"adv_pic"]]];
                    [self.view addSubview:view];
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timerLevelButtonClick:)];
                    [view addGestureRecognizer:tap];
                }
            }
        }];
        
    }
    [UD setObject:locationString forKey:EVERYDAY_FIRST_ACTIVITY_NOTIFICATION];
}

#pragma mark - Actions

- (void)allLevelButtonClick:(UIButton *)sender{
    SKQuestionPageViewController *controller = [[SKQuestionPageViewController alloc] init];
    NSMutableArray *list = [NSMutableArray arrayWithArray:self.questionList];
    [list removeLastObject];
    controller.questionList = list;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)timerLevelButtonClick:(UIButton *)sender {
    HTPreviewCardController *cardController = [[HTPreviewCardController alloc] initWithType:HTPreviewCardTypeTimeLevel andQuestList:@[self.questionList.lastObject] questionInfo:_questionInfo];
    cardController.delegate = self;
    [self.navigationController pushViewController:cardController animated:YES];
}

- (void)mascotButtonClick:(UIButton *)sender {
    HTMascotDisplayController *mascotController = [[HTMascotDisplayController alloc] init];
    [self.navigationController pushViewController:mascotController animated:YES];
}

- (void)meButtonClick:(UIButton *)sender {
    HTProfileRootController *rootController = [[HTProfileRootController alloc] init];
    [self.navigationController pushViewController:rootController animated:YES];
}

- (void)rankButtonClick:(UIButton *)sender {
    HTProfileRankController *rankController = [[HTProfileRankController alloc] init];
    [self.navigationController pushViewController:rankController animated:YES];
}

- (void)settingButtonClick:(UIButton *)sender {
    HTProfileSettingController *settingController = [[HTProfileSettingController alloc] initWithUserInfo:_userInfo];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (void)notificationButtonClick:(UIButton *)sender {
    HTNotificationController *controller = [[HTNotificationController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - HTPreviewCardController

- (void)didClickCloseButtonInController:(HTPreviewCardController *)controller {
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
