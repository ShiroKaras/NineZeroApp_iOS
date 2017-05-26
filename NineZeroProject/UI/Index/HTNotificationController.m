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
@property (nonatomic, strong) NSArray<SKNotification *> *notices;
@property (nonatomic, strong) HTBlankView *blankView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HTNotificationController {
    float lastOffsetY;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.bounces = NO;
    
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    tableViewHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = tableViewHeaderView;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_rank_shading"]];
    backImageView.tag = 202;
    backImageView.alpha = 0;
    backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backImageView];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headerView.tag = 200;
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"消息通知";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = PINGFANG_FONT_OF_SIZE(17);
    [titleLabel sizeToFit];
    titleLabel.center = headerView.center;
    [headerView addSubview:titleLabel];
    [self.view addSubview:headerView];
    
    [self.tableView registerClass:[HTNotificationCell class] forCellReuseIdentifier:NSStringFromClass([HTNotificationCell class])];
    self.notices = [NSArray array];
    [HTProgressHUD show];
    [[[SKServiceManager sharedInstance] profileService] getUserNotificationCallback:^(BOOL success, NSArray<SKNotification *> *notifications) {
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
        _blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_net"] text:@"一点信号都没"];
        [_blankView setOffset:10];
        [self.view addSubview:self.blankView];
        _blankView.center = self.view.center;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
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

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 64) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view viewWithTag:9001].alpha = 1;
            [self.view viewWithTag:200].alpha = 1;
            [self.view viewWithTag:202].alpha = 0;
            [self.view viewWithTag:9001].bottom = [self.view viewWithTag:9001].height+12;
            [self.view viewWithTag:200].bottom = [self.view viewWithTag:200].height;
            [self.view viewWithTag:202].bottom = [self.view viewWithTag:202].height;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        if (lastOffsetY >= scrollView.contentOffset.y) {
            [UIView animateWithDuration:0.3 animations:^{
                //显示
                [self.view viewWithTag:9001].alpha = 1;
                [self.view viewWithTag:200].alpha = 1;
                [self.view viewWithTag:202].alpha = 1;
                [self.view viewWithTag:9001].bottom = [self.view viewWithTag:9001].height+12;
                [self.view viewWithTag:200].bottom = [self.view viewWithTag:200].height;
                [self.view viewWithTag:202].bottom = [self.view viewWithTag:202].height;
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                //隐藏
                [self.view viewWithTag:9001].alpha = 0;
                [self.view viewWithTag:200].alpha = 0;
                [self.view viewWithTag:202].alpha = 0;
                [self.view viewWithTag:9001].bottom = 0;
                [self.view viewWithTag:200].bottom = 0;
                [self.view viewWithTag:202].bottom = 0;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    lastOffsetY = scrollView.contentOffset.y;
}

@end
