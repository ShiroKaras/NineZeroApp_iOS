//
//  NZUserProfileViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/27.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZUserProfileViewController.h"
#import "HTUIHeader.h"
#import "NZTicketListView.h"
#import "NZTopRankListView.h"
#import "NZRankViewController.h"

@interface NZUserProfileViewController () <UIScrollViewDelegate, NZTopRankListViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *mainInfoView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UILabel *gemLabel;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView0;
@property (nonatomic, strong) UIScrollView *contentScrollView1;
@property (nonatomic, strong) UIScrollView *contentScrollView2;
@property (nonatomic, strong) UIScrollView *contentScrollView3;
@end

@implementation NZUserProfileViewController {
    BOOL _scrollFlag;
    float _startY;
    float _otherPageStartY;
    BOOL _shoudCheckDirection;
    CGPoint _contentOffset;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollFlag = YES;
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
    NSLog(@"%lf", buttonsBackView.top);
    
//    [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(buttonsBackView.mas_bottom);
//        make.centerX.equalTo(_mainInfoView);
//        make.width.equalTo(_mainInfoView);
//        make.height.equalTo(@1);
//    }];
    
//    UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(0, _mainInfoView.bottom, self.view.width, self.view.height-20-49-49)];
//    cView.backgroundColor = COMMON_GREEN_COLOR;
//    [_scrollView addSubview:cView];
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _mainInfoView.bottom, self.view.width, self.view.height-20-48-49)];
    _contentScrollView.delegate = self;
    _contentScrollView.bounces = NO;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.backgroundColor = [UIColor clearColor];
    _contentScrollView.contentSize = CGSizeMake(self.view.width*4, _contentScrollView.height);
    [_scrollView addSubview:_contentScrollView];
    
    //
    _contentScrollView0 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _contentScrollView.width, _contentScrollView.height)];
    _contentScrollView0.delegate = self;
    _contentScrollView0.bounces = NO;
    _contentScrollView0.backgroundColor = COMMON_RED_COLOR;
    _contentScrollView0.contentSize = CGSizeMake(self.view.width, _contentScrollView.height*2);
    [_contentScrollView addSubview:_contentScrollView0];
    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    testView.backgroundColor = COMMON_GREEN_COLOR;
    [_contentScrollView0 addSubview:testView];

    //礼券
    _contentScrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(_contentScrollView.width, 0, _contentScrollView.width, _contentScrollView.height)];
    _contentScrollView1.delegate = self;
    _contentScrollView1.bounces = NO;
    _contentScrollView1.contentSize = CGSizeMake(self.view.width, _contentScrollView.height*2);
    [_contentScrollView addSubview:_contentScrollView1];
    
    NZTicketListView *ticketListView = [[NZTicketListView alloc] initWithFrame:CGRectMake(0, 0, _contentScrollView1.width, 0) withTickets:nil];
    [_contentScrollView1 addSubview:ticketListView];
    _contentScrollView1.contentSize = CGSizeMake(_contentScrollView1.width, ticketListView.viewHeight);
    
    //排名
    _contentScrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(_contentScrollView.width*2, 0, _contentScrollView.width, _contentScrollView.height)];
    _contentScrollView2.delegate = self;
    _contentScrollView2.bounces = NO;
    _contentScrollView2.contentSize = CGSizeMake(self.view.width, _contentScrollView.height*2);
    [_contentScrollView addSubview:_contentScrollView2];
    
    NZTopRankListView *topRankersListView = [[NZTopRankListView alloc] initWithFrame:CGRectMake(0, 0, _contentScrollView2.width, 0) withRankers:nil];
    topRankersListView.delegate = self;
    [_contentScrollView2 addSubview:topRankersListView];
    _contentScrollView2.contentSize = CGSizeMake(_contentScrollView2.width, topRankersListView.height);
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _contentScrollView0||scrollView == _contentScrollView1) {
        //得到图片移动相对原点的坐标
        CGPoint point = scrollView.contentOffset;
        NSLog(@"%lf", point.y);
        if (point.y > 50) {
            if (_scrollFlag) {
                _scrollFlag = NO;
                [self scrollView:_scrollView scrollToPoint:CGPointMake(0, 182)];
            }
        }
        if (point.y == 0) {
            _scrollFlag = YES;
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

- (void)scrollView:(UIScrollView*)scrollView scrollToPoint:(CGPoint)point {
    [scrollView setContentOffset:point animated:YES];
}

#pragma mark - NZTopRankListViewDelegate

- (void)didClickHunterRankButton {
    NZRankViewController *controller = [[NZRankViewController alloc] initWithType:NZRankListTypeHunter];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Actions

- (void)notificationButtonClick:(UIButton *)sender {
    
}

- (void)settingButtonClick:(UIButton*)sender {
    
}

@end
