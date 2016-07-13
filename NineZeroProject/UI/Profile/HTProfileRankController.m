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

#define RIGISTER_CLASS(clazz)  [self.tableView registerClass:[clazz class] forCellReuseIdentifier:NSStringFromClass([clazz class])];

@interface HTProfileRankController ()
@property (nonatomic, strong) NSArray<HTRanker *> *rankerList;
@property (nonatomic, strong) HTRanker *myRank;
@property (nonatomic, strong) HTBlankView *blankView;
@end

@implementation HTProfileRankController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = COMMON_BG_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    self.title = @"排行榜";
    RIGISTER_CLASS(HTProfileRankCell);

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
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [self.blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
        [self.view addSubview:self.blankView];
        self.blankView.top = ROUND_HEIGHT_FLOAT(157);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"rankingpage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"rankingpage"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_rankerList.count == 0) return 0;
    return _rankerList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTProfileRankCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileRankCell class])   forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell setRanker:_myRank];
        [cell showWithMe:YES];
    } else {
        HTRanker *ranker = _rankerList[indexPath.row - 1];
        [cell setRanker:ranker];
        [cell showWithMe:NO];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

@end
