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
@property (nonatomic, strong) NSMutableArray<SKQuestion*>* dataArray;
@property (nonatomic, assign) time_t deltaTime;
@property (nonatomic, assign) uint64_t endTime;

@property (nonatomic, assign) BOOL isShowTimeLimitQuestion;
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[NZQuestionListCell class] forCellReuseIdentifier:NSStringFromClass([NZQuestionListCell class])];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        HTBlankView *_blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_net"] text:@"一点信号都没"];
        [_blankView setOffset:10];
        [converView addSubview:_blankView];
        _blankView.center = converView.center;
    } else
        [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] questionService] getQuestionListCallback:^(BOOL success, NSArray<SKQuestion *> *questionList) {
        _dataArray = [NSMutableArray arrayWithArray:questionList];
        //计算结束时间
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[date timeIntervalSince1970];
        _endTime = (uint64_t)a+(uint64_t)[questionList[0].count_down longLongValue];
        if ([questionList[0].count_down longLongValue] <=0) {
            _isShowTimeLimitQuestion = NO;
            [_dataArray removeObjectAtIndex:0];
        } else {
            _isShowTimeLimitQuestion = YES;
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - Actions

- (void)didClickRankButton:(UIButton *)sender {
    NZRankViewController *controller = [[NZRankViewController alloc] initWithType:NZRankListTypeQuestion];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZQuestionListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NZQuestionListCell class])];
    if (cell==nil) {
        cell = [[NZQuestionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NZQuestionListCell class])];
    }
    if (_isShowTimeLimitQuestion) {
        [cell setCellWithQuetion:indexPath.section==0?self.dataArray[0]:self.dataArray[indexPath.row+1]];
    } else {
        [cell setCellWithQuetion:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZQuestionListCell *cell = (NZQuestionListCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isShowTimeLimitQuestion) {
        if (indexPath.section == 0) {
            NZQuestionDetailViewController *controller = [[NZQuestionDetailViewController alloc] initWithType:NZQuestionTypeTimeLimitLevel questionID:self.dataArray[0].qid];
            controller.endTime = _endTime;
            [self.navigationController pushViewController:controller animated:YES];
        } else if (indexPath.section == 1){
            NZQuestionDetailViewController *controller = [[NZQuestionDetailViewController alloc] initWithType:NZQuestionTypeHistoryLevel questionID:self.dataArray[indexPath.row+1].qid];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else {
        NZQuestionDetailViewController *controller = [[NZQuestionDetailViewController alloc] initWithType:NZQuestionTypeHistoryLevel questionID:self.dataArray[indexPath.row].qid];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 56)];
    headerView.backgroundColor = COMMON_BG_COLOR;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 102, 20)];
    [headerView addSubview:imageView];
    
    if (_isShowTimeLimitQuestion) {
        if (section == 0) {
            imageView.image = [UIImage imageNamed:@"img_puzzlepage_timedtask"];
        } else if (section==1) {
            imageView.image = [UIImage imageNamed:@"img_puzzlepage_dailytask"];
        }
    } else {
        imageView.image = [UIImage imageNamed:@"img_puzzlepage_dailytask"];
    }
    
    return headerView;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isShowTimeLimitQuestion) {
        if (section == 0)
            return 1;
        else
            return _dataArray.count-1;
    } else {
        return _dataArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isShowTimeLimitQuestion) {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 56;
}

@end
