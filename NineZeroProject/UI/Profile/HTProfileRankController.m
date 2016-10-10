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
@property (nonatomic, strong) NSArray<HTRanker *> *rankerList;
@property (nonatomic, strong) HTRanker *myRank;
@property (nonatomic, strong) HTBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HTProfileRankController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
//    headerView.backgroundColor = COMMON_TITLE_BG_COLOR;
//    UILabel *titleLabel = [UILabel new];
//    titleLabel.text = @"排行榜";
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.font = [UIFont systemFontOfSize:17];
//    [titleLabel sizeToFit];
//    titleLabel.center = headerView.center;
//    [headerView addSubview:titleLabel];
//    [self.view addSubview:headerView];
    
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    REGISTER_CLASS(HTProfileRankCell);

    self.rankerList = [NSArray array];
    _myRank = [[HTRanker alloc] init];
    [HTProgressHUD show];
    [[[HTServiceManager sharedInstance] profileService] getRankList:^(BOOL success, NSArray<HTRanker *> *ranker) {
        if (success) {
            _rankerList = ranker;
            [[[HTServiceManager sharedInstance] profileService] getMyRank:^(BOOL success, HTRanker *ranker) {
                [HTProgressHUD dismiss];
                if (success) {
                    _myRank = ranker;
                    [self.tableView reloadData];
                }
            }];
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
        NSArray<HTRanker*>* topRankers = [NSArray arrayWithObjects:_rankerList[0], _rankerList[1], _rankerList[2], nil];
        [cell setTopThreeRankers:topRankers];
        return cell;
    } else if (indexPath.row == 1) {
        [cell setRanker:_myRank];
        [cell showWithMe:YES];
        return cell;
    } else {
        HTRanker *ranker = _rankerList[indexPath.row +1];
        [cell setRanker:ranker];
        [cell showWithMe:NO];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return (SCREEN_WIDTH-20)/288.*281.;
    } else {
        return 74;
    }
}

@end
