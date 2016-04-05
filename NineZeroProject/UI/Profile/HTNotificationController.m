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

@interface HTNotificationController ()
@property (nonatomic, strong) NSArray<HTNotification *> *notices;
@property (nonatomic, strong) HTBlankView *blankView;
@end

@implementation HTNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"消息通知";
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
