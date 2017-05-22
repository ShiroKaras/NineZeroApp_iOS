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
#import "NZLabTableViewCell.h"
#import "NZLabDetailViewController.h"
#import "SKProfileSettingViewController.h"
#import "NZNotificationViewController.h"
#import "NZBadgesView.h"
#import "SKTicketView.h"
#import "SKDescriptionView.h"

@interface NZUserProfileViewController () <UIScrollViewDelegate, NZTopRankListViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *mainInfoView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UILabel *gemLabel;
@property (nonatomic, strong) UIImageView *indicatorLine;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView_badge;
@property (nonatomic, strong) UITableView  *contentTableView_tickets;
@property (nonatomic, strong) UIScrollView *contentScrollView_rank;
@property (nonatomic, strong) UITableView  *contentTableView_topic;

@property (nonatomic, strong) NZTopRankListView *topRankersListView;

@property (nonatomic, strong) NSArray<SKTicket*> *ticketArray;
@property (nonatomic, strong) NSArray<SKTopic*>  *topicArray;
@property (nonatomic, strong) NSArray<SKRanker *> *rankerList;
@property (nonatomic, strong) NSArray<SKRanker *> *hunterRankerList;

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
    _avatarImageView.layer.cornerRadius = ROUND_WIDTH_FLOAT(64)/2;
    _avatarImageView.layer.masksToBounds = YES;
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
        [button addTarget:self action:@selector(didClickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
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
        label.tag = 200+i;
        label.text = @"99999";
        label.textColor = i==0?COMMON_GREEN_COLOR:COMMON_TEXT_3_COLOR;
        label.font = MOON_FONT_OF_SIZE(12);
        label.textAlignment = NSTextAlignmentCenter;
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
    
    //指示线
    _indicatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userpage_choose"]];
    _indicatorLine.centerX = [self.view viewWithTag:100].centerX;
    [underLine addSubview:_indicatorLine];
    
    //内容栏
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _mainInfoView.bottom, self.view.width, self.view.height-20-48-49)];
    _contentScrollView.delegate = self;
    _contentScrollView.bounces = NO;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.backgroundColor = [UIColor clearColor];
    _contentScrollView.contentSize = CGSizeMake(self.view.width*4, _contentScrollView.height);
    [_scrollView addSubview:_contentScrollView];
    
    //勋章
    _contentScrollView_badge = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _contentScrollView.width, _contentScrollView.height)];
    _contentScrollView_badge.delegate = self;
    _contentScrollView_badge.bounces = NO;
    _contentScrollView_badge.contentSize = CGSizeMake(self.view.width, _contentScrollView.height*2);
    [_contentScrollView addSubview:_contentScrollView_badge];
    
    NZBadgesView *badgeView = [[NZBadgesView alloc] initWithFrame:CGRectMake(0, 0, _contentScrollView_badge.width, 1220) badges:nil];
    [_contentScrollView_badge addSubview:badgeView];
    _contentScrollView_badge.contentSize = CGSizeMake(_contentScrollView_badge.width, 1220);

    //礼券
    UIView *ticketHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    UIImageView *ticketTitleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userpage_gift"]];
    [ticketHeaderView addSubview:ticketTitleImageView];
    ticketTitleImageView.left = 16;
    ticketTitleImageView.centerY = ticketHeaderView.centerY;
    
    _contentTableView_tickets = [[UITableView alloc] initWithFrame:CGRectMake(_contentScrollView.width, 0, _contentScrollView.width, _contentScrollView.height) style:UITableViewStylePlain];
    _contentTableView_tickets.backgroundColor = [UIColor clearColor];
    _contentTableView_tickets.delegate = self;
    _contentTableView_tickets.dataSource = self;
    _contentTableView_tickets.bounces = NO;
    _contentTableView_tickets.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentTableView_tickets registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    _contentTableView_tickets.tableHeaderView = ticketHeaderView;
    [_contentScrollView addSubview:_contentTableView_tickets];
    
    //排名
    _contentScrollView_rank = [[UIScrollView alloc] initWithFrame:CGRectMake(_contentScrollView.width*2, 0, _contentScrollView.width, _contentScrollView.height)];
    _contentScrollView_rank.delegate = self;
    _contentScrollView_rank.bounces = NO;
    _contentScrollView_rank.contentSize = CGSizeMake(self.view.width, _contentScrollView.height*2);
    [_contentScrollView addSubview:_contentScrollView_rank];
    
    _topRankersListView = [[NZTopRankListView alloc] initWithFrame:CGRectMake(0, 0, _contentScrollView_rank.width, 636) withRankers:nil];
    _topRankersListView.delegate = self;
    [_contentScrollView_rank addSubview:_topRankersListView];
    _contentScrollView_rank.contentSize = CGSizeMake(_contentScrollView_rank.width, 700);
    
    //参与的话题
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 52)];
    UIImageView *titleImageView_topic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userpage_partake"]];
    titleImageView_topic.left = 16;
    titleImageView_topic.centerY = headerView.centerY;
    [headerView addSubview:titleImageView_topic];
    
    _contentTableView_topic = [[UITableView alloc] initWithFrame:CGRectMake(_contentScrollView.width*3, 0, _contentScrollView.width, _contentScrollView.height) style:UITableViewStylePlain];
    _contentTableView_topic.delegate = self;
    _contentTableView_topic.dataSource = self;
    _contentTableView_topic.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView_topic.backgroundColor = [UIColor clearColor];
    _contentTableView_topic.showsVerticalScrollIndicator = NO;
    _contentTableView_topic.showsHorizontalScrollIndicator = NO;
    _contentTableView_topic.bounces = NO;
    _contentTableView_topic.tableHeaderView = headerView;
    [_contentTableView_topic registerClass:[NZLabTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NZLabTableViewCell class])];
    [_contentScrollView addSubview:_contentTableView_topic];
    
    [self loadData];
}

- (void)loadData {
    _userNameLabel.text = [[SKStorageManager sharedInstance] userInfo].user_name;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[[SKStorageManager sharedInstance] userInfo].user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    
    [[[SKServiceManager sharedInstance] profileService] getUserInfoDetailCallback:^(BOOL success, SKProfileInfo *response) {
//        ((UILabel*)[self.view viewWithTag:200]).text = response.achievement_num;
        ((UILabel*)[self.view viewWithTag:201]).text = response.ticket_num;
        ((UILabel*)[self.view viewWithTag:202]).text = [response.rank integerValue]>999? @"1K+":response.rank;
//        ((UILabel*)[self.view viewWithTag:203]).text = response.join_num;
    }];
    
    [[[SKServiceManager sharedInstance] profileService] getUserTicketsCallbackCallback:^(BOOL suceese, NSArray<SKTicket *> *tickets) {
        self.ticketArray = tickets;
        [_contentTableView_tickets reloadData];
        if (self.ticketArray.count == 0) {
            HTBlankView *blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_gift"] text:@"参加官方活动，凭券获得神秘礼物"];
            [blankView setOffset:10];
            [_contentScrollView addSubview:blankView];
            blankView.centerX = _contentScrollView.width*1.5;
            blankView.top = 100;
        }
    }];
    
    [[[SKServiceManager sharedInstance] profileService] getSeason2RankListCallback:^(BOOL success, NSArray<SKRanker *> *rankerList) {
        if (success) {
            _topRankersListView.rankerArray = rankerList;
            _rankerList = rankerList;
            [HTProgressHUD dismiss];
        } else {
            [HTProgressHUD dismiss];
        }
    }];
    
    [[[SKServiceManager sharedInstance] mascotService] getMascotCoopTimeRankListCallback:^(BOOL success, NSArray<SKRanker *> *rankerList) {
        if (success) {
            _hunterRankerList = rankerList;            
            [HTProgressHUD dismiss];
        } else {
            [HTProgressHUD dismiss];
        }
    }];
    
    //勋章数量
    [[[SKServiceManager sharedInstance] profileService] getUserAchievement:^(BOOL success, NSInteger exp, NSInteger coopTime, NSArray<SKBadge *> *badges, NSArray<SKBadge*> *medals) {
        NSInteger _badgeLevel = 0;
        for (int i=0; i<badges.count; i++) {
            if (exp >= [badges[i].medal_level integerValue])    _badgeLevel++;
        }
        for (int i=0; i<medals.count; i++) {
            if (coopTime >= [medals[i].medal_level integerValue])   _badgeLevel++;
        }
        ((UILabel*)[self.view viewWithTag:200]).text = [NSString stringWithFormat:@"%ld", _badgeLevel];
    }];

    //参与话题
    [[[SKServiceManager sharedInstance] profileService] getJoinTopicListCallback:^(BOOL success, NSArray<SKTopic *> *topicList) {
        _topicArray = topicList;
        ((UILabel*)[self.view viewWithTag:203]).text = [NSString stringWithFormat:@"%ld", topicList.count];
        [_contentTableView_topic reloadData];
        if (topicList.count == 0) {
            HTBlankView *blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_topic"] text:@"脑洞大不大，参与话题多说话"];
            [blankView setOffset:10];
            [_contentScrollView addSubview:blankView];
            blankView.top = 100;
            blankView.centerX = _contentScrollView.width*3.5;
        }
    }];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _contentScrollView_badge||
        scrollView == _contentTableView_tickets||
        scrollView == _contentScrollView_rank||
        scrollView == _contentTableView_topic) {
        //得到图片移动相对原点的坐标
        CGPoint point = scrollView.contentOffset;
        if (point.y > 30) {
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
    if (scrollView == _contentScrollView) {
        //得到图片移动相对原点的坐标
        CGPoint point = scrollView.contentOffset;
        
        //根据图片坐标判断页数
        int index = round(point.x / (SCREEN_WIDTH));
        [self scrollToIndex:index];
    }
}

- (void)scrollView:(UIScrollView*)scrollView scrollToPoint:(CGPoint)point {
    [scrollView setContentOffset:point animated:YES];
}

- (void)scrollToIndex:(int)index {
    NSArray *imageNameArray = @[@"btn_userpage_achievement", @"btn_userpage_gift", @"btn_userpage_ranking", @"btn_userpage_partake"];
    for (int i = 0; i<4; i++) {
        [((UIButton*)[self.view viewWithTag:100+i]) setImage:[UIImage imageNamed:i==index?
                                                              [NSString stringWithFormat:@"%@_highlight",imageNameArray[i]]:
                                                              [NSString stringWithFormat:@"%@",imageNameArray[i]]]
                                                    forState:UIControlStateNormal];
        ((UILabel*)[self.view viewWithTag:200+i]).textColor = i==index?COMMON_GREEN_COLOR:COMMON_TEXT_3_COLOR;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _indicatorLine.centerX = [self.view viewWithTag:100+index].centerX;
    }];
}

#pragma mark - NZTopRankListViewDelegate

- (void)didClickRankButton {
    _topRankersListView.rankerArray = _rankerList;
}

- (void)didClickHunterRankButton {
    _topRankersListView.rankerArray = _hunterRankerList;
}

#pragma mark - Actions

- (void)notificationButtonClick:(UIButton *)sender {
    NZNotificationViewController *controller = [[NZNotificationViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)settingButtonClick:(UIButton*)sender {
    SKProfileSettingViewController *controller = [[SKProfileSettingViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickTitleButton:(UIButton *)sender {
    int index = (int)sender.tag -100;
    [self scrollToIndex:index];
    CGPoint point = _contentScrollView.contentOffset;
    point.x = self.view.width*index;
    [UIView animateWithDuration:0.3 animations:^{
        _contentScrollView.contentOffset = point;
    }];
}
#pragma mark - TableView Delegate 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _contentTableView_topic) {
        NZLabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NZLabTableViewCell class])];
        if (cell==nil) {
            cell = [[NZLabTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NZLabTableViewCell class])];
        }
        [cell.thumbImageView sd_setImageWithURL:[NSURL URLWithString:_topicArray[indexPath.row].topic_list_pic]];
        cell.titleLabel.text = [_topicArray[indexPath.row].topic_title stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        
        return cell;
    } else if (tableView == _contentTableView_tickets) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        SKTicketView *ticketView = [[SKTicketView alloc] initWithFrame:CGRectMake(16, 16, self.view.width-32, (self.view.width-32)/288*111) reward:self.ticketArray[indexPath.row]];
        [cell.contentView addSubview:ticketView];
        [ticketView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.view.width-32));
            make.height.equalTo(@((self.view.width-32)/288*111));
            make.top.equalTo(cell);
            make.centerX.equalTo(cell);
        }];
        return cell;
    } else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _contentTableView_topic) {
        NZLabTableViewCell *cell = (NZLabTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    } else if(tableView == _contentTableView_tickets) {
        return (self.view.width-32)/288*111+6;
    } else
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _contentTableView_topic) {
        self.hidesBottomBarWhenPushed=YES;
        NZLabDetailViewController *controller = [[NZLabDetailViewController alloc] initWithTopicID:_topicArray[indexPath.row].id];
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    } else if (tableView == _contentTableView_tickets) {
        SKDescriptionView *descriptionView = [[SKDescriptionView alloc] initWithURLString:self.ticketArray[indexPath.row].address andType:SKDescriptionTypeReward andImageUrl:self.ticketArray[indexPath.row].pic];
        [descriptionView setReward:self.ticketArray[indexPath.row]];
        [self.view addSubview:descriptionView];
        [descriptionView showAnimated];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _contentTableView_topic) {
        return _topicArray.count;
    } else
        return _ticketArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
