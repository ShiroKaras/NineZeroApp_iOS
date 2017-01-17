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
#import "SKActivityNotificationView.h"

@interface SKHomepageViewController ()

@property (nonatomic, strong)   HTImageView *headerImageView;
@property (nonatomic, strong)   UIView      *timeCountDownBackView;
@property (nonatomic, strong)   UILabel     *timeCountDownLabel;
@property (nonatomic, strong)   UIButton    *timeLimitLevelButton;
@property (nonatomic, strong)   UIImageView *timeCountDownBackView_isMonday;
@property (nonatomic, strong)   UILabel     *timeCountDownLabel_isMonday;
@property (nonatomic, strong)   UIView      *notificationRedFlag;

@property (nonatomic, strong)   SKActivityNotificationView  *activityNotificationView;  //活动通知

@property (nonatomic, assign)   uint64_t  endTime;
@property (nonatomic, assign)   BOOL    isMonday;

@property (nonatomic, strong)   SKIndexInfo *indexInfo;
@end

@implementation SKHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
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
            if (![_indexInfo.adv_pic isEqualToString:@""]) {
                [self judgementDate];
                [self judgeNotificationRedFlag];                
            }
        }
    }];
    
    [[[SKServiceManager sharedInstance] questionService] getAllQuestionListCallback:^(BOOL success, NSInteger answeredQuestion_season1, NSInteger answeredQuestion_season2, NSArray<SKQuestion *> *questionList_season1, NSArray<SKQuestion *> *questionList_season2) {
        
        if ([UD dictionaryForKey:kQuestionWrongAnswerCountSeason1]==nil || [[UD dictionaryForKey:kQuestionWrongAnswerCountSeason1] allKeys].count == 0) {
            NSMutableDictionary *hintDict = [NSMutableDictionary dictionary];
            for (SKQuestion *question in questionList_season1) {
                [hintDict setObject:@0 forKey:question.qid];
            }
            for (SKQuestion *question in questionList_season2) {
                [hintDict setObject:@0 forKey:question.qid];
            }
            
            [UD setObject:hintDict forKey:kQuestionWrongAnswerCountSeason1];
        } else {
            NSMutableDictionary *hintDict = [NSMutableDictionary dictionaryWithDictionary:[UD dictionaryForKey:kQuestionWrongAnswerCountSeason1]];
            for (SKQuestion *question in questionList_season1) {
                if (![[hintDict allKeys] containsObject:question.qid]) {
                    [hintDict setObject:@0 forKey:question.qid];
                }
            }
            for (SKQuestion *question in questionList_season2) {
                if (![[hintDict allKeys] containsObject:question.qid]) {
                    [hintDict setObject:@0 forKey:question.qid];
                }
            }
            [UD setObject:hintDict forKey:kQuestionWrongAnswerCountSeason1];
        }
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
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[UD objectForKey:kMascots_Dict]];
        if (![[dict allKeys] containsObject:[[SKStorageManager sharedInstance] getUserID]]) {
            NSArray *mascotArray = @[@0,@0,@0,@0,@0,@0,@0];
            [UD setObject:@{[[SKStorageManager sharedInstance] getUserID] :mascotArray} forKey:kMascots_Dict];
        }
    }
}

- (void)judgementDate {
    NSDate  *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    if (![locationString isEqualToString:[UD objectForKey:EVERYDAY_FIRST_ACTIVITY_NOTIFICATION]]) {
        _activityNotificationView.hidden = NO;
        [_activityNotificationView show];
        [_activityNotificationView.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.indexInfo.adv_pic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    } else {
        _activityNotificationView.hidden = YES;
    }
    [UD setObject:locationString forKey:EVERYDAY_FIRST_ACTIVITY_NOTIFICATION];
}

- (void)judgeNotificationRedFlag {
    if ([UD valueForKey:NOTIFICATION_COUNT] == nil) {
        [UD setValue:@(self.indexInfo.user_notice_count) forKey:NOTIFICATION_COUNT];
        self.notificationRedFlag.hidden = self.indexInfo.user_notice_count>0?NO:YES;
    } else {
        self.notificationRedFlag.hidden = self.indexInfo.user_notice_count>[[UD valueForKey:NOTIFICATION_COUNT] integerValue]?NO:YES;
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

- (void)createUI {
    __weak __typeof(self)weakSelf = self;
    
    self.view.backgroundColor = COMMON_BG_COLOR;
    
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
    [notificationButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
    [self.view addSubview:notificationButton];
    [notificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@55);
        make.height.equalTo(@30);
        make.top.equalTo(weakSelf.view).offset(14);
        make.right.equalTo(weakSelf.view).offset(15);
    }];
    
    self.notificationRedFlag = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    self.notificationRedFlag.layer.cornerRadius = 4;
    self.notificationRedFlag.backgroundColor = COMMON_RED_COLOR;
    self.notificationRedFlag.hidden = YES;
    [self.view addSubview:self.notificationRedFlag];
    [self.notificationRedFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 8));
        make.left.equalTo(notificationButton).offset(24);
        make.top.equalTo(notificationButton).offset(5);
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
        make.bottom.equalTo(_timeCountDownBackView_isMonday).offset(-6);
        make.centerX.equalTo(_timeCountDownBackView_isMonday);
    }];
    
    //活动通知
    _activityNotificationView = [[SKActivityNotificationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _activityNotificationView.hidden = YES;
    [self.view addSubview:_activityNotificationView];
}

#pragma mark - Actions
- (void)showRelaxDayTimeLabel:(UIButton *)sender {
    if (_isMonday) {
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
    SKQuestionViewController *controller = [[SKQuestionViewController alloc] initWithType:SKQuestionTypeTimeLimitLevel questionID:self.indexInfo.qid endTime:(time_t)_endTime];
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
    [UD setValue:@(self.indexInfo.user_notice_count) forKey:NOTIFICATION_COUNT];
    HTNotificationController *controller = [[HTNotificationController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
