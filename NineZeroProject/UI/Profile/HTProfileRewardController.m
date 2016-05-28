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

@interface HTProfileRewardController ()
@property (nonatomic, strong) NSArray<HTTicket *> *rewards;
@property (nonatomic, strong) HTBlankView *blankView;
@end

@implementation HTProfileRewardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [HTUIHelper commonLeftBarItem];
    }
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"礼券";
    
    [self.tableView registerClass:[HTProfileRewardCell class] forCellReuseIdentifier:NSStringFromClass([HTProfileRewardCell class])];
    
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
        self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [self.blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
        [self.view addSubview:self.blankView];
        self.blankView.top = ROUND_HEIGHT_FLOAT(157);
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
    return 21 + cardHeight;
}

@end
