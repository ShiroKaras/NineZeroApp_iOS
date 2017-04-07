//
//  NZQuestionListViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/30.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZQuestionListViewController.h"
#import "HTUIHeader.h"

#import "NZQuestionListCell.h"
#import "NZQuestionDetailViewController.h"
#import "NZRankViewController.h"

@interface NZQuestionListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<SKQuestion*>* dataArray;
@end

@implementation NZQuestionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzlepage_title"]];
    [headerView addSubview:_titleImageView];
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.centerX.equalTo(headerView);
    }];
    
    UIButton *rankButton = [UIButton new];
    [rankButton addTarget:self action:@selector(didClickRankButton:) forControlEvents:UIControlEventTouchUpInside];
    [rankButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzlepage_ranking"] forState:UIControlStateNormal];
    [rankButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzlepage_ranking_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:rankButton];
    [rankButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 27));
        make.centerY.equalTo(headerView);
        make.right.equalTo(headerView).offset(-13.5);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64-44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[NZQuestionListCell class] forCellReuseIdentifier:NSStringFromClass([NZQuestionListCell class])];
    [self.view addSubview:self.tableView];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] questionService] getQuestionListCallback:^(BOOL success, NSArray<SKQuestion *> *questionList) {
        _dataArray = questionList;
        [self.tableView reloadData];
    }];
}

#pragma mark - Actions

- (void)didClickRankButton:(UIButton *)sender {
    NZRankViewController *controller = [[NZRankViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZQuestionListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NZQuestionListCell class])];
    if (cell==nil) {
        cell = [[NZQuestionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NZQuestionListCell class])];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZQuestionListCell *cell = (NZQuestionListCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NZQuestionDetailViewController *controller = [[NZQuestionDetailViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 56)];
    headerView.backgroundColor = COMMON_BG_COLOR;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 102, 20)];
    [headerView addSubview:imageView];
    
    if (section == 0) {
        imageView.image = [UIImage imageNamed:@"img_puzzlepage_timedtask"];
    } else if (section==1) {
        imageView.image = [UIImage imageNamed:@"img_puzzlepage_dailytask"];
    }
    
    return headerView;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    else
        return _dataArray.count-1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 56;
}

@end
