//
//  HTNotificationController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/29.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTNotificationController.h"
#import "HTUIHeader.h"
#import "HTNotificationCell.h"

@interface HTNotificationController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray<HTNotification *> *notices;
@property (nonatomic, strong) HTBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HTNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    headerView.backgroundColor = COMMON_TITLE_BG_COLOR;
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"消息通知";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [titleLabel sizeToFit];
    titleLabel.center = headerView.center;
    [headerView addSubview:titleLabel];
    [self.view addSubview:headerView];
    
    [self.tableView registerClass:[HTNotificationCell class] forCellReuseIdentifier:NSStringFromClass([HTNotificationCell class])];
    self.notices = [NSArray array];
    [HTProgressHUD show];
    [[[HTServiceManager sharedInstance] profileService] getNotifications:^(BOOL success, NSArray<HTNotification *> *notifications) {
        [HTProgressHUD dismiss];
        if (success) {
            _notices = notifications;
            [self.tableView reloadData];
            if (_notices.count == 0) {
                self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNoContent];
                [self.blankView setImage:[UIImage imageNamed:@"img_blank_grey_big"] andOffset:17];
                [self.view addSubview:self.blankView];
                self.blankView.top = ROUND_HEIGHT_FLOAT(217);
            }
        }
    }];
    
    
    if (NO_NETWORK) {
        self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [self.blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
        [self.view addSubview:self.blankView];
        self.blankView.top = ROUND_HEIGHT_FLOAT(217);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
    [TalkingData trackPageBegin:@"pushpage"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:@"pushpage"];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _notices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTNotificationCell class]) forIndexPath:indexPath];
    [cell setNotification:_notices[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [HTNotificationCell calculateCellHeightWithText:_notices[indexPath.row].content];
}

@end
