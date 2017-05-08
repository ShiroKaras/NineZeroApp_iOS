//
//  NZNotificationViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/8.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZNotificationViewController.h"
#import "HTUIHeader.h"

#import "NZNotificationTableViewCell.h"

@interface NZNotificationViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HTBlankView *blankView;
@property (nonatomic, strong) NSArray<SKNotification *> *notices;
@end

@implementation NZNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    [self.view addSubview:titleView];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_newspage_title"]];
    [titleView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView);
        make.centerY.equalTo(titleView);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-49-64) style:UITableViewStylePlain];
    [self.tableView registerClass:[NZNotificationTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NZNotificationTableViewCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    if (NO_NETWORK) {
        self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [self.blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
        [self.view addSubview:self.blankView];
        self.blankView.top = ROUND_HEIGHT_FLOAT(217);
    } else {
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
    }
}

#pragma mark - UITableView Delegate



#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NZNotificationTableViewCell class]) forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
