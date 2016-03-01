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

@end

@implementation HTProfileRewardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [HTUIHelper commonLeftBarItem];
    self.tableView.backgroundColor = COMMON_BG_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"礼券";
    
    [self.tableView registerClass:[HTProfileRewardCell class] forCellReuseIdentifier:NSStringFromClass([HTProfileRewardCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTProfileRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTProfileRewardCell class]) forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HTDescriptionView *descriptionView = [[HTDescriptionView alloc] initWithURLString:@"" andType:HTDescriptionTypeReward];
    [self.view.superview addSubview:descriptionView];
    [descriptionView showAnimated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 21 + cardHeight;
}

@end
