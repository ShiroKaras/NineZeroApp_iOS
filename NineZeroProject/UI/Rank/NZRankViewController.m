//
//  NZRankViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/30.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZRankViewController.h"
#import "HTUIHeader.h"

@interface NZRankViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NZRankListType type;
@property (nonatomic, strong) SKRanker *myRank;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<SKRanker *> *rankerList;

@end

@implementation NZRankViewController

- (instancetype)initWithType:(NZRankListType)type
{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzleranking_title"]];
    [headerView addSubview:_titleImageView];
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.centerX.equalTo(headerView);
    }];
    
    _myRank = [[SKRanker alloc] init];
    _myRank.rank = [[SKStorageManager sharedInstance].profileInfo.rank integerValue];
    _myRank.user_avatar = [SKStorageManager sharedInstance].userInfo.user_avatar;
    _myRank.user_name = [SKStorageManager sharedInstance].userInfo.user_name;
    _myRank.gold = [SKStorageManager sharedInstance].profileInfo.user_gold;
    _myRank.user_experience_value = [SKStorageManager sharedInstance].profileInfo.user_experience_value;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[NZRankCell class] forCellReuseIdentifier:NSStringFromClass([NZRankCell class])];
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    if (_type == NZRankListTypeQuestion) {
        [[[SKServiceManager sharedInstance] profileService] getSeason2RankListCallback:^(BOOL success, NSArray<SKRanker *> *rankerList) {
            if (success) {
                _rankerList = rankerList;
                [self.tableView reloadData];
                [HTProgressHUD dismiss];
            } else {
                [HTProgressHUD dismiss];
            }
        }];
    } else if (_type == NZRankListTypeHunter) {
        [[[SKServiceManager sharedInstance] mascotService] getMascotCoopTimeRankListCallback:^(BOOL success, NSArray<SKRanker *> *rankerList) {
            if (success) {
                _rankerList = rankerList;
                [self.tableView reloadData];
                [HTProgressHUD dismiss];
            } else {
                [HTProgressHUD dismiss];
            }
        }];
    }
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZRankCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NZRankCell class])];
    if (cell==nil) {
        cell = [[NZRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NZRankCell class])];
    }
    if (indexPath.row == 0) {
        [cell setRanker:_myRank isMe:YES withType:_type];
    } else {
        [cell setRanker:self.rankerList[indexPath.row-1] isMe:NO withType:_type];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZRankCell *cell = (NZRankCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rankerList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
