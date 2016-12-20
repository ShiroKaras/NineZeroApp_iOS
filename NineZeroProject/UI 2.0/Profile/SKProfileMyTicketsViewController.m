//
//  SKProfileMyTicketsViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/6.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKProfileMyTicketsViewController.h"
#import "HTUIHeader.h"
#import "SKTicketView.h"

@interface SKProfileMyTicketsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) NSArray<SKTicket*>    *ticketArray;
@end

@implementation SKProfileMyTicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"我的礼券";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [titleLabel sizeToFit];
    titleLabel.center = headerView.center;
    [headerView addSubview:titleLabel];
    [self.view addSubview:headerView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] profileService] getUserTicketsCallbackCallback:^(BOOL suceese, NSArray<SKTicket *> *tickets) {
        self.ticketArray = tickets;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SKTicketView *ticket = [[SKTicketView alloc] initWithFrame:CGRectZero reward:self.ticketArray[indexPath.row]];
    [cell addSubview:ticket];
    [ticket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@280);
        make.height.equalTo(@108);
        make.top.equalTo(cell);
        make.centerX.equalTo(cell);
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108+10;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ticketArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
