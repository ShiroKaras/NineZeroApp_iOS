//
//  HTProfileRewardController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/25.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTProfileRewardController.h"
#import "HTUIHeader.h"
#import "HTProfileRewardCell.h"
#import "HTDescriptionView.h"

@interface HTProfileRewardController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray<HTTicket *> *rewards;
@property (nonatomic, strong) HTBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HTProfileRewardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [HTUIHelper commonLeftBarItem];
    }
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"礼券";
    
    [self.tableView registerClass:[HTProfileRewardCell class] forCellReuseIdentifier:NSStringFromClass([HTProfileRewardCell class])];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    headerView.backgroundColor = COMMON_TITLE_BG_COLOR;
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"礼券";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [titleLabel sizeToFit];
    titleLabel.center = headerView.center;
    [headerView addSubview:titleLabel];
    [self.view addSubview:headerView];
    
    _rewards = [NSArray array];
    
    [HTProgressHUD show];
    [[[HTServiceManager sharedInstance] profileService] getRewards:^(BOOL success, NSArray<HTTicket *> *rewards) {
        [HTProgressHUD dismiss];
        if (success) {
            _rewards = rewards;
            [self.tableView reloadData];
            if (_rewards.count == 0) {
                self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNoContent];
                [self.blankView setImage:[UIImage imageNamed:@"img_blank_grey_big"] andOffset:17];
                [self.view addSubview:self.blankView];
                self.blankView.top = ROUND_HEIGHT_FLOAT(157);
            }
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
    [MobClick beginLogPageView:@"giftpage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"giftpage"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rewards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTProfileRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileRewardCell class]) forIndexPath:indexPath];
    [cell setReward:_rewards[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HTDescriptionView *descriptionView = [[HTDescriptionView alloc] initWithURLString:@"" andType:HTDescriptionTypeReward];
    [descriptionView setReward:_rewards[indexPath.row]];
    [KEY_WINDOW addSubview:descriptionView];
    [descriptionView showAnimated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 11 + (SCREEN_WIDTH-40)/2;
}

@end
