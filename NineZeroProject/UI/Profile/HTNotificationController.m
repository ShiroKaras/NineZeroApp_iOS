//
//  HTNotificationController.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTNotificationController.h"
#import "HTUIHeader.h"
#import "HTNotificationCell.h"

@interface HTNotificationController ()
@property (nonatomic, strong) NSArray<HTNotification *> *notices;
@end

@implementation HTNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"消息通知";
    [self.tableView registerClass:[HTNotificationCell class] forCellReuseIdentifier:NSStringFromClass([HTNotificationCell class])];
    self.notices = [NSArray array];
    [[[HTServiceManager sharedInstance] profileService] getNotifications:^(BOOL success, NSArray<HTNotification *> *notifications) {
        if (success) {
            _notices = notifications;
            [self.tableView reloadData];
        }
    }];
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
