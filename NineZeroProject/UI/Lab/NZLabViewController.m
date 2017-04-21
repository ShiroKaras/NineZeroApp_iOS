//
//  NZLabViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/20.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZLabViewController.h"
#import "HTUIHeader.h"

#import "NZLabTableViewCell.h"

@interface NZLabViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation NZLabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskbook_title"]];
    [headerView addSubview:_titleImageView];
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.centerX.equalTo(headerView);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[NZLabTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NZLabTableViewCell class])];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZLabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NZLabTableViewCell class])];
    if (cell==nil) {
        cell = [[NZLabTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NZLabTableViewCell class])];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZLabTableViewCell *cell = (NZLabTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return _dataArray.count;
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


@end
