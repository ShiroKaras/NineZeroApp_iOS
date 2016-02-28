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

@end

@implementation HTNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"消息通知";
    [self.tableView registerClass:[HTNotificationCell class] forCellReuseIdentifier:NSStringFromClass([HTNotificationCell class])];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTNotificationCell class]) forIndexPath:indexPath];
    HTNotification *notication = [[HTNotification alloc] init];
    [cell setNotification:notication];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [HTNotificationCell calculateCellHeightWithText:@""];
}

@end
