//
//  HTProfileRewardController.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfileRewardController.h"
#import "HTUIHeader.h"
#import "HTProfileRewardCell.h"
#import "HTDescriptionView.h"

@interface HTProfileRewardController ()
@property (nonatomic, strong) NSArray<HTReward *> *rewards;
@end

@implementation HTProfileRewardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [HTUIHelper commonLeftBarItem];
    }
    self.tableView.backgroundColor = COMMON_BG_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"礼券";
    
    [self.tableView registerClass:[HTProfileRewardCell class] forCellReuseIdentifier:NSStringFromClass([HTProfileRewardCell class])];
    
    _rewards = [NSArray array];
    [[[HTServiceManager sharedInstance] profileService] getRewards:^(BOOL success, NSArray<HTReward *> *rewards) {
        if (success) {
            _rewards = rewards;
            [self.tableView reloadData];
        }
    }];
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
    [self.view.superview addSubview:descriptionView];
    [descriptionView showAnimated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 21 + cardHeight;
}

@end
