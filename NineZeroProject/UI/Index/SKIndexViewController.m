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
#import "SKSwipeViewController.h"
#import "HTAlertView.h"

#import "HTUIHeader.h"

#define EVERYDAY_FIRST_ACTIVITY_NOTIFICATION @"EVERYDAY_FIRST_ACTIVITY_NOTIFICATION"

#define minTranslateYToSkip 0.25
#define animationTime 0.25f
#define translationAccelerate 1.f

typedef enum {
    BSScrollDirectionUnknown,
    BSScrollDirectionFromBottomToTop,
    BSScrollDirectionFromTopToBottom
} BSScrollDirection;

@interface SKIndexViewController () <HTPreviewCardControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton  *timerLevelButton;
@property (nonatomic, strong) UIView    *timerLevelCountView;
@property (nonatomic, strong) UIView    *relaxDayCountView;
@property (nonatomic, strong) SKActivityNotificationView    *activityNotificationView;
@property (nonatomic, strong) UIImageView *notificationFlag;

@property (nonatomic, strong) UIImageView *scanningMascotImageView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIView    *swipeView;
@property (nonatomic, strong) UIImageView *cameraImageView;

@property (nonatomic, strong) NSArray<HTQuestion*>  *questionList;
@property (nonatomic, strong) NSArray<HTMascot *>   *mascots;
@property (nonatomic, strong) HTQuestionInfo        *questionInfo;
@property (nonatomic, strong) HTUserInfo            *userInfo;
@property (nonatomic, strong) UILabel   *timeLabel;
@property (nonatomic, strong) UILabel   *relaxDayTimeLabel;
@property (nonatomic, assign) uint64_t  endTime;
@property (nonatomic, assign) BOOL  isMonday;

@property (nonatomic, strong) NSArray<HTScanning *> *scanningList;
@end

@implementation SKIndexViewController {
    UIPanGestureRecognizer *_panGesture;
    BOOL _isOnTop;
    
    BSScrollDirection _scrollDirection;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [HTProgressHUD show];
    [self loadData];
    [self judgementDate];
    if (_swipeView != nil) {
        [self removeSnapshotViewFromSuperView];
    }
    [TalkingData trackPageBegin:@"homepage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"homepage"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![UD boolForKey:@"everLaunched"]) {
        [UD setBool:YES forKey:@"everLaunched"];
        [UD setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [UD setBool:NO forKey:@"firstLaunch"];
    }
    
    [HTProgressHUD show];
    [self createUI];
    
    [[[HTServiceManager sharedInstance] questionService] getScanning:^(BOOL success, NSArray<HTScanning *> *scanningList) {
        _scanningList = scanningList;
        
        _headerLabel.hidden = ![_scanningList[0].status integerValue];
        _scanningMascotImageView.hidden = ![_scanningList[0].status integerValue];
        if ([_scanningList[0].status integerValue] == 1) {
            _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
            [_panGesture setDelegate:self];
            [self.view addGestureRecognizer:_panGesture];
        }
        // 本地沙盒目录
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //清除缓存
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            NSArray *childerFiles=[fileManager subpathsAtPath:path];
            for (NSString *fileName in childerFiles) {
                //如有需要，加入条件，过滤掉不想删除的文件
                if ([fileName containsString:@"swipeTargetImage"]) {
                    NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                    [fileManager removeItemAtPath:absolutePath error:nil];
                }
            }
        }
        
        for (int i = 0; i<scanningList.count; i++) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:scanningList[i].file_url_true]];
            UIImage *image = [UIImage imageWithData:data]; // 取得图片
            
            // 得到本地沙盒路径，"swipeTargetImage_x"是保存的图片名
            NSString *imageFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"swipeTargetImage_%d.jpg",i]];
            // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
            BOOL imageDownloadSuccess = [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath  atomically:YES];
            if (imageDownloadSuccess){
                NSLog(@"写入本地成功");
            }
        }
        
    }];
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
        
        if (delta > 0) {
            _timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
        }
        _questionInfo = questionInfo;
    }];
    
    [[[HTServiceManager sharedInstance] questionService] getQuestionListWithPage:0 count:0 callback:^(BOOL success, NSArray<HTQuestion *> *questionList) {
        self.questionList = questionList;
        
        if ([UD mutableArrayValueForKey:kQuestionHintArray]==nil || [UD mutableArrayValueForKey:kQuestionHintArray].count==0) {
            NSMutableArray *hintArray = [NSMutableArray array];
            for (int i = 0; i<questionList.count; i++) {
                [hintArray addObject:@0];
            }
            [UD setObject:hintArray forKey:kQuestionHintArray];
        } else {
            if ([UD mutableArrayValueForKey:kQuestionHintArray].count < questionList.count) {
                do {
                    [[UD mutableArrayValueForKey:kQuestionHintArray] addObject:@0];
                } while ([UD mutableArrayValueForKey:kQuestionHintArray].count == questionList.count);
            }
        }
        
        // 本地沙盒目录
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //清除缓存
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            NSArray *childerFiles=[fileManager subpathsAtPath:path];
            for (NSString *fileName in childerFiles) {
                //如有需要，加入条件，过滤掉不想删除的文件
                if ([fileName isEqualToString:@"lbsTargetImage"]) {
                    NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                    [fileManager removeItemAtPath:absolutePath error:nil];
                }
            }
        }
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:[questionList lastObject].checkpoint_pic]];
        UIImage *image = [UIImage imageWithData:data]; // 取得图片
        
        // 得到本地沙盒路径，"targetImage_x"是保存的图片名
        NSString *imageFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"lbsTargetImage.jpg"]];
        // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
        BOOL imageDownloadSuccess = [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath  atomically:YES];
        if (imageDownloadSuccess){
            NSLog(@"LBS图片写入本地成功");
        }
    }];
    
    [[[HTServiceManager sharedInstance] profileService] getUserInfo:^(BOOL success, HTUserInfo *userInfo) {
        if (success) {
            _userInfo = userInfo;
            [[HTStorageManager sharedInstance] setUserInfo:userInfo];
        }
    }];
    
    [[[HTServiceManager sharedInstance] profileService] getProfileInfo:^(BOOL success, HTProfileInfo *profileInfo) {
        if (success) {
            if([profileInfo.notice integerValue]+1 - [UD integerForKey:@"notificationsHasReadKey"]>0)
                self.notificationFlag.hidden = NO;
            else
                self.notificationFlag.hidden = YES;
        }
    }];
    
    [[[HTServiceManager sharedInstance] mascotService] getUserMascots:^(BOOL success, NSArray<HTMascot *> *mascots) {
        if (success) {
            self.mascots = mascots;
        } else {
            
        }
    }];
    
    [[[HTServiceManager sharedInstance] profileService] getBadges:^(BOOL success, NSArray<HTBadge *> *badges) {
        [HTProgressHUD dismiss];
        if (success) {
            NSMutableArray *badgeLevels = [NSMutableArray array];
            for (HTBadge *badge in badges) {
                [badgeLevels addObject:[NSNumber numberWithInteger:[badge.medal_level integerValue]]];
            }
            [UD setObject:[badgeLevels copy] forKey:kBadgeLevels];
        }
    }];
    
    [[[HTServiceManager sharedInstance] questionService] getIsRelaxDay:^(BOOL success, HTResponsePackage *response) {
        NSString *dictData = [NSString stringWithFormat:@"%@", response.data];
        if (success && response.resultCode == 0) {
            if ([dictData isEqualToString:@"1"]) {
                [HTProgressHUD dismiss];
                _isMonday = YES;
                [[[HTServiceManager sharedInstance] questionService] getRelaxDayInfo:^(BOOL success, HTResponsePackage *response) {
                    if (success && response.resultCode == 0) {
                        NSDictionary *dataDict = response.data;
                        _endTime = (time_t)[dataDict[@"end_time"] integerValue];
                        [self scheduleCountDownTimer];
                        _relaxDayCountView.alpha = 0;
                    }
                }];
                [_timerLevelButton addTarget:self action:@selector(showRelaxDayTimeLabel:) forControlEvents:UIControlEventTouchUpInside];
                [_timerLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_locked"] forState:UIControlStateNormal];
                [_timerLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_locked"] forState:UIControlStateHighlighted];

            } else if ([dictData isEqualToString:@"0"]) {
                _isMonday = NO;
                [HTProgressHUD dismiss];
                _timerLevelCountView.alpha = 1;
                [_timerLevelButton addTarget:self action:@selector(timerLevelButtonClick) forControlEvents:UIControlEventTouchUpInside];
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
    [HTProgressHUD show];
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
    
    _headerLabel = [UILabel new];
    _headerLabel.text = @"下划开启扫一扫";
    _headerLabel.font = [UIFont systemFontOfSize:14];
    _headerLabel.textColor = [UIColor colorWithHex:0x00DFB4];
    [_headerLabel sizeToFit];
    _headerLabel.hidden = YES;
    [self.view addSubview:_headerLabel];
    
    _scanningMascotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_scanning"]];
    [_scanningMascotImageView sizeToFit];
    _scanningMascotImageView.hidden = YES;
    [self.view addSubview:_scanningMascotImageView];
    
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(8);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    [_scanningMascotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.right.equalTo(_headerLabel.mas_left).offset(-5);
    }];
    
    //通知标记
    _notificationFlag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_profile_notification_number"]];
    [self.view addSubview:_notificationFlag];
    [_notificationFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@14);
        make.height.equalTo(@14);
        make.top.equalTo(notificationButton.mas_top).offset(2);
        make.right.equalTo(notificationButton.mas_right).offset(-2);
    }];
    [self.view addSubview:_notificationFlag];
    
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
    [allLevelButton addTarget:self  action:@selector(allLevelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [dimmingView addSubview:allLevelButton];
    
    _timerLevelButton = [UIButton new];
    [_timerLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_timer_level"] forState:UIControlStateNormal];
    [_timerLevelButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_timer_level_highlight"] forState:UIControlStateHighlighted];
    [dimmingView addSubview:_timerLevelButton];
    
    UIButton *mascotButton = [UIButton new];
    [mascotButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_lingzai"] forState:UIControlStateNormal];
    [mascotButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_lingzai_highlight"] forState:UIControlStateHighlighted];
    [mascotButton addTarget:self action:@selector(mascotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [dimmingView addSubview:mascotButton];
    
    UIButton *meButton = [UIButton new];
    [meButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_me"] forState:UIControlStateNormal];
    [meButton setBackgroundImage:[UIImage imageNamed:@"btn_homepage_me_highlight"] forState:UIControlStateHighlighted];
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
    
    _relaxDayTimeLabel = [UILabel new];
    _relaxDayTimeLabel.text = @"00:00:00";
    _relaxDayTimeLabel.textColor = [UIColor whiteColor];
    _relaxDayTimeLabel.font = MOON_FONT_OF_SIZE(16);
    _relaxDayTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_relaxDayCountView addSubview:_relaxDayTimeLabel];
    
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

    [_relaxDayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_relaxDayCountView);
        make.right.equalTo(_relaxDayCountView);
        make.bottom.equalTo(_relaxDayCountView).offset(-9);
    }];
    
    //限时关卡倒计时
    _timerLevelCountView = [UIView new];
    _timerLevelCountView.backgroundColor = [UIColor colorWithHex:0xFF063E];
    _timerLevelCountView.layer.cornerRadius = 5;
    [self.view addSubview:_timerLevelCountView];
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"00:00:00";
    _timeLabel.textColor = [UIColor whiteColor];
    if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH)  _timeLabel.font = MOON_FONT_OF_SIZE(19);
    else                                            _timeLabel.font = MOON_FONT_OF_SIZE(16);
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
    
    //活动通知
    _activityNotificationView = [[SKActivityNotificationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _activityNotificationView.hidden = YES;
    [self.view addSubview:_activityNotificationView];
    
    [_activityNotificationView.adButton addTarget:self action:@selector(timerLevelButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Time

- (void)setQuestionInfo:(HTQuestionInfo *)questionInfo {
    _endTime = questionInfo.endTime;
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
    
    if (delta > 0) {
        if (_isMonday) {
            _relaxDayTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hour, minute, second];
        } else
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
                    _activityNotificationView.hidden = NO;
                    [_activityNotificationView show];
                    [_activityNotificationView.contentImageView sd_setImageWithURL:[NSURL URLWithString:response.data[@"adv_pic"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [HTProgressHUD dismiss];
                    }];
                } else {
                    _activityNotificationView.hidden = YES;
                }
            }
        }];
    } else {
        _activityNotificationView.hidden = YES;
    }
    [UD setObject:locationString forKey:EVERYDAY_FIRST_ACTIVITY_NOTIFICATION];
}

#pragma mark - Actions

- (void)allLevelButtonClick:(UIButton *)sender{
    [TalkingData trackEvent:@"alllevels"];
    if (self.questionList.count != 0) {
        SKQuestionPageViewController *controller = [[SKQuestionPageViewController alloc] init];
        NSMutableArray *list = [self.questionList mutableCopy];
        if (!_isMonday) {
            [list removeLastObject];
        }
        controller.questionList = list;
        controller.isMonday = _isMonday;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)timerLevelButtonClick {
    [TalkingData trackEvent:@"timelimit"];
    if (self.questionList.count != 0) {
        HTPreviewCardController *cardController = [[HTPreviewCardController alloc] initWithType:HTPreviewCardTypeTimeLevel andQuestList:@[self.questionList.lastObject] questionInfo:_questionInfo];
        cardController.delegate = self;
        [self.navigationController pushViewController:cardController animated:YES];
    }
}

- (void)showRelaxDayTimeLabel:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _relaxDayCountView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _relaxDayCountView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}

- (void)mascotButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"lingzai"];
    HTMascotDisplayController *mascotController = [[HTMascotDisplayController alloc] init];
    mascotController.mascots = [[[[HTServiceManager sharedInstance] mascotService] mascotsArray] mutableCopy];
    [self.navigationController pushViewController:mascotController animated:YES];
}

- (void)meButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"myhomepage"];
    HTProfileRootController *rootController = [[HTProfileRootController alloc] init];
    [self.navigationController pushViewController:rootController animated:YES];
}

- (void)rankButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"rankinglist"];
    HTProfileRankController *rankController = [[HTProfileRankController alloc] init];
    [self.navigationController pushViewController:rankController animated:YES];
}

- (void)settingButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"setting"];
    HTProfileSettingController *settingController = [[HTProfileSettingController alloc] initWithUserInfo:_userInfo];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (void)notificationButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"push"];
    HTNotificationController *controller = [[HTNotificationController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - panGestureRecognized
//轻扫手势触发方法
-(void)swipeGesture:(id)sender
{
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        //向下轻扫
        [UIView animateWithDuration:animationTime animations:^{
            _swipeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            _cameraImageView.centerX = _swipeView.centerX;
            _cameraImageView.centerY = _swipeView.centerY;
        } completion:^(BOOL finished) {

        }];
    }
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender {
    CGPoint translate = [sender translationInView:self.view];
    translate.y = translate.y * translationAccelerate;
    CGFloat boundsW = CGRectGetWidth(self.view.bounds);
    CGFloat boundsH = CGRectGetHeight(self.view.bounds);
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            // reset all values
            _scrollDirection = BSScrollDirectionUnknown;
            _isOnTop = NO;
            _cameraImageView.centerX = _swipeView.centerX;
            _cameraImageView.centerY = _swipeView.centerY;
            break;
            
        case UIGestureRecognizerStateChanged: {
            
            // Determinate Scroll Direction
            if (_scrollDirection == BSScrollDirectionUnknown) {
                _scrollDirection = translate.y < 0 ? BSScrollDirectionFromBottomToTop : BSScrollDirectionFromTopToBottom;
                // add snapshot on top
                [self addSnapshotViewOnTopWithDirection:_scrollDirection];
            }
            
            _swipeView.alpha = 0.7 * translate.y/SCREEN_HEIGHT;
            _cameraImageView.centerX = self.view.centerX;
            _cameraImageView.centerY = -_cameraImageView.height/2 + translate.y/2;
            
            // If snapshot doesnt exist -> set isOnTop
            if (!_swipeView) {
                _isOnTop = YES;
            }
            
            // Is on top and pulling to from top to bottom, gesture is driven by handlePanGestureToPullToRefresh
            if (_isOnTop && _scrollDirection == BSScrollDirectionFromTopToBottom) {
                return;
            }
            
            break;
        }
        case UIGestureRecognizerStateCancelled : {
            // gesture was canceled - snapshot view backs to start position
            // collection view has no more items to show, pangesture is available only for 50px
            [UIView animateWithDuration:animationTime animations:^{
                if (_scrollDirection == BSScrollDirectionFromBottomToTop) {
                    CGRect endRect = CGRectMake(0, 0, boundsW, boundsH);
                    [_swipeView setFrame:endRect];
                } else {
                    _swipeView.alpha = 0.7;
                    _cameraImageView.centerX = self.view.centerX;
                    _cameraImageView.centerY = self.view.centerY;
                }
            } completion:^(BOOL finished) {
                [self removeSnapshotViewFromSuperView];
            }];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            // pull to refresh dragging, handled by handlePanGestureToPullToRefresh
            if (_isOnTop && _scrollDirection == BSScrollDirectionFromTopToBottom) {
                return;
            }
            
            if (_scrollDirection == BSScrollDirectionFromTopToBottom && translate.y > minTranslateYToSkip * boundsH) {
                [UIView animateWithDuration:animationTime animations:^{
                    _swipeView.alpha = 0.7;
                    _cameraImageView.centerX = self.view.centerX;
                    _cameraImageView.centerY = self.view.centerY;
                } completion:^(BOOL finished) {
                    //判断相机是否开启
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
                    {
                        HTAlertView *alertView = [[HTAlertView alloc] initWithType:HTAlertViewTypeCamera];
                        [alertView show];
                        [UIView animateWithDuration:animationTime animations:^{
                            _swipeView.alpha = 0;
                            _cameraImageView.centerX = self.view.centerX;
                            _cameraImageView.bottom = self.view.top;
                        } completion:^(BOOL finished) {
                            [self removeSnapshotViewFromSuperView];
                        }];
                    }else {
                        SKSwipeViewController *swipeViewController = [[SKSwipeViewController alloc] initWithScanningList:_scanningList];
                        [self.navigationController pushViewController:swipeViewController animated:NO];
                    }
                }];
            } else {
                [UIView animateWithDuration:animationTime animations:^{
                    _swipeView.alpha = 0;
                    _cameraImageView.centerX = self.view.centerX;
                    _cameraImageView.bottom = self.view.top;
                } completion:^(BOOL finished) {
                    [self removeSnapshotViewFromSuperView];
                }];
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)removeSnapshotViewFromSuperView {
    [_swipeView removeFromSuperview];
    _swipeView = nil;
    [_cameraImageView removeFromSuperview];
    _cameraImageView = nil;
}


- (void)addSnapshotViewOnTopWithDirection:(BSScrollDirection)direction{
    [self removeSnapshotViewFromSuperView];
    
    switch (direction) {
        case BSScrollDirectionFromBottomToTop:
            //下滑扫一扫
            _swipeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _swipeView.backgroundColor = [UIColor blackColor];
            _swipeView.alpha = 0;
            [self.view addSubview:_swipeView];
            
            _cameraImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_camera"]];
            [_cameraImageView sizeToFit];
            _cameraImageView.centerX = self.view.centerX;
            _cameraImageView.bottom = self.view.top;
            [self.view addSubview:_cameraImageView];

            break;
        case BSScrollDirectionFromTopToBottom:
            //下滑扫一扫
            _swipeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _swipeView.backgroundColor = [UIColor blackColor];
            _swipeView.alpha = 0;
            [self.view addSubview:_swipeView];
            
            _cameraImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_camera"]];
            [_cameraImageView sizeToFit];
            _cameraImageView.centerX = self.view.centerX;
            _cameraImageView.bottom = self.view.top;
            [self.view addSubview:_cameraImageView];
            
            break;
        default:
            break;
    }
}
#pragma mark - Util

- (void)showFlag:(NSInteger)unreadCount {
    if (unreadCount>0) {
        [self showUnreadArticleFlag];
    }else {
        [self removeUnreadArticleFlag];
    }
}

- (void)showUnreadArticleFlag {
    self.notificationFlag.alpha = 1;
}

- (void)removeUnreadArticleFlag {
    self.notificationFlag.alpha = 0;
}

#pragma mark - HTPreviewCardController

- (void)didClickCloseButtonInController:(HTPreviewCardController *)controller {
    [controller.navigationController popViewControllerAnimated:YES];
}

@end
