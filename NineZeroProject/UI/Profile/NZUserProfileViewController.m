//
//  NZUserProfileViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/27.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZUserProfileViewController.h"
#import "HTUIHeader.h"

@interface NZUserProfileViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *mainInfoView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UILabel *gemLabel;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@end

@implementation NZUserProfileViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    float height = 44+ROUND_HEIGHT_FLOAT(64)+10+20+33+48+1;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height-20-44)];
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(self.view.width, self.view.height-49-20-49+height+5);
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    _mainInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, height)];
    [_scrollView addSubview:_mainInfoView];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    [_mainInfoView addSubview:titleView];
    
    UIButton *notificationButton = [[UIButton alloc] initWithFrame:CGRectMake(13.5, (44-27)/2, 27, 27)];
    [notificationButton addTarget:self action:@selector(notificationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [notificationButton setBackgroundImage:[UIImage imageNamed:@"btn_userpage_news"] forState:UIControlStateNormal];
    [notificationButton setBackgroundImage:[UIImage imageNamed:@"btn_userpage_news_highlight"] forState:UIControlStateHighlighted];
    [titleView addSubview:notificationButton];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.right-13.5-27, notificationButton.frame.origin.y, 27, 27)];
    [settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_userpage_setting"] forState:UIControlStateNormal];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_userpage_setting_highlight"] forState:UIControlStateHighlighted];
    [titleView addSubview:settingButton];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userpage_title"]];
    titleImageView.centerX = titleView.centerX;
    titleImageView.centerY = notificationButton.centerY;
    [titleView addSubview:titleImageView];
    
    _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    _avatarImageView.size = CGSizeMake(ROUND_WIDTH_FLOAT(64), ROUND_WIDTH_FLOAT(64));
    _avatarImageView.centerX = titleView.centerX;
    _avatarImageView.top = titleView.bottom;
    [_mainInfoView addSubview:_avatarImageView];
    
    _userNameLabel = [UILabel new];
    _userNameLabel.text = @"我是零仔";
    _userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.font = PINGFANG_FONT_OF_SIZE(14);
    [_userNameLabel sizeToFit];
    [_mainInfoView addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_bottom).offset(10);
        make.centerX.equalTo(_avatarImageView);
    }];
    
    UIView *buttonsBackView = [UIView new];
    [_mainInfoView addSubview:buttonsBackView];
    [buttonsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameLabel.mas_bottom).offset(33);
        make.centerX.equalTo(_mainInfoView);
        make.width.equalTo(_mainInfoView);
        make.height.equalTo(@48);
    }];
    
    [self.view layoutIfNeeded];
    
    float padding = (self.view.width - 200)/5;
    NSArray *buttonImageNameArray = @[@"btn_userpage_achievement", @"btn_userpage_gift", @"btn_userpage_ranking", @"btn_userpage_partake"];
    for (int i=0; i<4; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(padding+(padding+50)*i, 0, 50, 48)];
        if (i==0) {
            [button setImage:[UIImage imageNamed:[buttonImageNameArray[i] stringByAppendingString:@"_highlight"]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:buttonImageNameArray[i]]  forState:UIControlStateHighlighted];
        } else {
            [button setImage:[UIImage imageNamed:buttonImageNameArray[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[buttonImageNameArray[i] stringByAppendingString:@"_highlight"]]  forState:UIControlStateHighlighted];
        }
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 21, 0)];
        [buttonsBackView addSubview:button];
        
        UILabel *label = [UILabel new];
        label.text = @"999";
        label.textColor = i==0?COMMON_GREEN_COLOR:COMMON_TEXT_3_COLOR;
        label.font = MOON_FONT_OF_SIZE(12);
        [label sizeToFit];
        [buttonsBackView addSubview:label];
        label.centerX = button.centerX;
        label.bottom = button.bottom-3;
    }
    
    UIView *underLine = [UIView new];
    underLine.backgroundColor = COMMON_SEPARATOR_COLOR;
    [_mainInfoView addSubview:underLine];
    underLine.top = buttonsBackView.bottom;
    underLine.centerX = 0;
    underLine.width = self.view.width;
    underLine.height = 1;
    
    _mainInfoView.height = underLine.bottom;
    
//    [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(buttonsBackView.mas_bottom);
//        make.centerX.equalTo(_mainInfoView);
//        make.width.equalTo(_mainInfoView);
//        make.height.equalTo(@1);
//    }];
    
//    UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(0, _mainInfoView.bottom, self.view.width, self.view.height-20-49-49)];
//    cView.backgroundColor = COMMON_GREEN_COLOR;
//    [_scrollView addSubview:cView];
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _mainInfoView.bottom-20, self.view.width, self.view.height-20-48-49)];
    _contentScrollView.delegate = self;
    _contentScrollView.bounces = NO;
    _contentScrollView.backgroundColor = COMMON_GREEN_COLOR;
    _contentScrollView.contentSize = CGSizeMake(self.view.width, 2000);
    [_scrollView addSubview:_contentScrollView];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%lf", scrollView.contentOffset.y);
}

#pragma mark - Actions

- (void)notificationButtonClick:(UIButton *)sender {
    
}

- (void)settingButtonClick:(UIButton*)sender {
    
}

@end
