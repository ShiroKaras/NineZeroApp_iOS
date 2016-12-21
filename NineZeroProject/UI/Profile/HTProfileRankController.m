//
//  HTProfileRankController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/2.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTProfileRankController.h"
#import "HTProfileRankCell.h"
#import "HTUIHeader.h"

#define REGISTER_CLASS(clazz)  [self.tableView registerClass:[clazz class] forCellReuseIdentifier:NSStringFromClass([clazz class])];

@interface HTProfileRankController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign)   SKRankViewType  type;
@property (nonatomic, strong)   NSArray<SKRanker *> *rankerList;
@property (nonatomic, strong)   SKRanker *myRank;
@property (nonatomic, strong)   HTBlankView *blankView;
@property (nonatomic, strong)   UITableView *tableView;
@end

@implementation HTProfileRankController

- (instancetype)initWithSeason:(SKRankViewType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@4);
    }];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    REGISTER_CLASS(HTProfileRankCell);

    self.rankerList = [NSArray array];
    _myRank = [[SKRanker alloc] init];
    [HTProgressHUD show];
    
    [[[SKServiceManager sharedInstance] profileService] getSeason2RankListCallback:^(BOOL success, NSArray<SKRanker *> *rankerList) {
        if (success) {
            _rankerList = rankerList;
            _myRank.rank = [SKStorageManager sharedInstance].userInfo.rank;
            _myRank.user_avatar = [SKStorageManager sharedInstance].userInfo.user_avatar;
            _myRank.user_name = [SKStorageManager sharedInstance].userInfo.user_name;
            _myRank.gold = [SKStorageManager sharedInstance].userInfo.gold;
            [self.tableView reloadData];
            [HTProgressHUD dismiss];
        } else {
            [HTProgressHUD dismiss];
        }

    }];
    
    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.width, self.view.height-60)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [self.blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
        [self.view addSubview:self.blankView];
        self.blankView.top = ROUND_HEIGHT_FLOAT(217);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //[MobClick beginLogPageView:@"rankingpage"];
    [TalkingData trackPageBegin:@"rankingpage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[MobClick endLogPageView:@"rankingpage"];
    [TalkingData trackPageEnd:@"rankingpage"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_rankerList.count == 0) return 0;
    return _rankerList.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTProfileRankCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileRankCell class])   forIndexPath:indexPath];

    if (indexPath.row == 0) {
        NSArray<SKRanker*>* topRankers = [NSArray arrayWithObjects:_rankerList[0], _rankerList[1], _rankerList[2], nil];
        [cell setTopThreeRankers:topRankers];
        return cell;
    } else if (indexPath.row == 1) {
        [cell setRanker:_myRank];
        [cell showWithMe:YES];
        return cell;
    } else {
        SKRanker *ranker = _rankerList[indexPath.row +1];
        [cell setRanker:ranker];
        [cell showWithMe:NO];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return (SCREEN_WIDTH-32)/288.*281.;
    } else {
        return 74;
    }
}

#pragma mark - Actions

- (void)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
