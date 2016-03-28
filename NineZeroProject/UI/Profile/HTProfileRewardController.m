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
#import "MJRefresh.h"

@interface HTProfileRewardController ()
@property (nonatomic, strong) NSMutableArray<HTTicket *> *rewards;
@property (nonatomic, strong) HTBlankView *blankView;
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
    
    _rewards = [NSMutableArray array];
    
//    [HTProgressHUD show];
//    [[[HTServiceManager sharedInstance] profileService] getRewards:^(BOOL success, NSArray<HTTicket *> *rewards) {
//        [HTProgressHUD dismiss];
//        if (success) {
//            _rewards = rewards;
//            [self.tableView reloadData];
//            if (_rewards.count == 0) {
//                self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNoContent];
//                [self.blankView setImage:[UIImage imageNamed:@"img_blank_grey_big"] andOffset:17];
//                [self.view addSubview:self.blankView];
//                self.blankView.top = ROUND_HEIGHT_FLOAT(157);
//            }
//        }
//    }];
//    
//    if (NO_NETWORK) {
//        self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
//        [self.blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
//        [self.view addSubview:self.blankView];
//        self.blankView.top = ROUND_HEIGHT_FLOAT(157);
//    }
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    NSMutableArray<UIImage *> *refreshingImages = [NSMutableArray array];
    for (int i = 0; i != 3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"list_view_loader_%d", (i + 1)]];
        [refreshingImages addObject:image];
    }
    [footer setImages:refreshingImages duration:1.0 forState:MJRefreshStateRefreshing];
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
//    footer.height = 0;
    [self.tableView reloadData];

    NSMutableArray *rewards = [NSMutableArray array];
    for (int i = 0; i != 10; i++) {
        HTTicket *ticket = [[HTTicket alloc] init];
        ticket.ticket_id = 1000101;
        ticket.address = @"中关村";
        ticket.code = 123123;
        ticket.expire_time = time(NULL) + 22000;
        ticket.mobile = @"1333333333";
        ticket.title = @"海底捞两人团购券";
        ticket.used = 0;
        [rewards addObject:ticket];
    }
    _rewards = rewards;
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

- (void)loadMoreData {
    for (int i = 0; i != 10; i++) {
        HTTicket *ticket = [[HTTicket alloc] init];
        ticket.ticket_id = 1000101;
        ticket.address = @"中关村";
        ticket.code = 123123;
        ticket.expire_time = time(NULL) + 22000;
        ticket.mobile = @"1333333333";
        ticket.title = @"海底捞两人团购券";
        ticket.used = 0;
        [_rewards addObject:ticket];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    });
}

@end
