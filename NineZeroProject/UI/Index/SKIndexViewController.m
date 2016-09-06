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

#import "HTUIHeader.h"

@interface SKIndexViewController () <HTPreviewCardControllerDelegate>

@property (nonatomic, strong) NSArray<HTQuestion*>* questionList;
@property (nonatomic, strong) HTUserInfo *userInfo;
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
    [self createUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Create UI
- (void)loadData {
    [[[HTServiceManager sharedInstance] questionService] getQuestionListWithPage:0 count:0 callback:^(BOOL success, NSArray<HTQuestion *> *questionList) {
        self.questionList = questionList;
    }];
    
    [[[HTServiceManager sharedInstance] profileService] getUserInfo:^(BOOL success, HTUserInfo *userInfo) {
        if (success) {
            _userInfo = userInfo;
            [[HTStorageManager sharedInstance] setUserInfo:userInfo];
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
    [allLevelButton setImage:[UIImage imageNamed:@"btn_homepage_traditional_level"] forState:UIControlStateNormal];
    [allLevelButton setImage:[UIImage imageNamed:@"btn_homepage_traditional_level_highlight"] forState:UIControlStateHighlighted];
    [allLevelButton sizeToFit];
    [allLevelButton addTarget:self  action:@selector(allLevelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [dimmingView addSubview:allLevelButton];
    
    UIButton *timerLevelButton = [UIButton new];
    [timerLevelButton setImage:[UIImage imageNamed:@"btn_homepage_timer_level"] forState:UIControlStateNormal];
    [timerLevelButton setImage:[UIImage imageNamed:@"btn_homepage_timer_level_highlight"] forState:UIControlStateHighlighted];
    [timerLevelButton sizeToFit];
    [timerLevelButton addTarget:self action:@selector(timerLevelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [dimmingView addSubview:timerLevelButton];
    
    UIButton *mascotButton = [UIButton new];
    [mascotButton setImage:[UIImage imageNamed:@"btn_homepage_lingzai"] forState:UIControlStateNormal];
    [mascotButton setImage:[UIImage imageNamed:@"btn_homepage_lingzai_highlight"] forState:UIControlStateHighlighted];
    [mascotButton sizeToFit];
    [mascotButton addTarget:self action:@selector(mascotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [dimmingView addSubview:mascotButton];
    
    UIButton *meButton = [UIButton new];
    [meButton setImage:[UIImage imageNamed:@"btn_homepage_me"] forState:UIControlStateNormal];
    [meButton setImage:[UIImage imageNamed:@"btn_homepage_me_highlight"] forState:UIControlStateHighlighted];
    [meButton sizeToFit];
    [meButton addTarget:self action:@selector(meButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [dimmingView addSubview:meButton];
    
    [dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.bottom.equalTo(weakSelf.view).offset(-180);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
    }];
    
    [allLevelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(dimmingView.mas_centerY).offset(-18);
        make.right.equalTo(dimmingView.mas_centerX).offset(-20);
    }];
    
    [timerLevelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allLevelButton);
        make.left.equalTo(dimmingView.mas_centerX).offset(20);
    }];
    
    [mascotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dimmingView.mas_centerY).offset(18);
        make.centerX.equalTo(allLevelButton);
    }];
    
    [meButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mascotButton);
        make.centerX.equalTo(timerLevelButton);
    }];
    
    //倒计时
    //非休息日
    BOOL isRestDay = YES;
    if (isRestDay) {
        [timerLevelButton setImage:[UIImage imageNamed:@"btn_homepage_locked"] forState:UIControlStateNormal];
        [timerLevelButton setImage:[UIImage imageNamed:@"btn_homepage_locked"] forState:UIControlStateHighlighted];
        
        UIView *countDownView = [UIView new];
        countDownView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:countDownView];
        
        UIImageView *countDownImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_homepage_timer"]];
        [countDownView sizeToFit];
        [countDownView addSubview:countDownImageView];
        
        UILabel *timeLabel = [UILabel new];
        timeLabel.text = @"00:00:00";
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = MOON_FONT_OF_SIZE(12);
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [countDownView addSubview:timeLabel];
        
        [countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(80));
            make.height.equalTo(@(41));
            make.right.equalTo(timerLevelButton.mas_right).offset(-20);
            make.bottom.equalTo(timerLevelButton.mas_top).offset(9);
        }];
        
        [countDownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(countDownView);
            make.height.equalTo(countDownView);
            make.center.equalTo(countDownView);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(countDownView);
            make.bottom.equalTo(countDownView.mas_bottom).offset(-9);
        }];
    } else {
        UIView *countDownView = [UIView new];
        countDownView.backgroundColor = [UIColor colorWithHex:0xFF063E];
        countDownView.layer.cornerRadius = 5;
        [self.view addSubview:countDownView];
        
        UILabel *timeLabel = [UILabel new];
        timeLabel.text = @"00:00:00";
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = MOON_FONT_OF_SIZE(16);
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [countDownView addSubview:timeLabel];
        
        [countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(72));
            make.height.equalTo(@(29));
            make.left.equalTo(timerLevelButton.mas_centerX);
            make.centerY.equalTo(timerLevelButton.mas_top);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(countDownView);
            make.height.equalTo(countDownView);
            make.center.equalTo(countDownView);
        }];
    }
}

#pragma mark - Actions

- (void)allLevelButtonClick:(UIButton *)sender{
    SKQuestionPageViewController *controller = [[SKQuestionPageViewController alloc] init];
    controller.questionList = self.questionList;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)timerLevelButtonClick:(UIButton *)sender {
    HTPreviewCardController *cardController = [[HTPreviewCardController alloc] initWithType:HTPreviewCardTypeIndexRecord andQuestList:@[self.questionList.lastObject]];
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
