//
//  ChatFlowViewController.m
//  ChatFlow
//
//  Created by SinLemon on 2017/2/16.
//  Copyright © 2017年 ShiroKaras. All rights reserved.
//

#import "ChatFlowViewController.h"
#import "ChatFlowCell.h"
#import <Masonry.h>

@interface ChatFlowViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ChatFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        [_dataArray addObject:@(1)];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerClass:[ChatFlowCell class] forCellReuseIdentifier:NSStringFromClass([ChatFlowCell class])];
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
    [self scrollViewToBottom:YES];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(addChatData) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Add" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

- (void)addChatData {
    [_dataArray addObject:@(arc4random()%2+1)];
    [self.tableView reloadData];
    [self scrollViewToBottom:YES];
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChatFlowCell class]) forIndexPath:indexPath];
    if (cell==nil) {
         cell = [[ChatFlowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ChatFlowCell class])];
    }
    cell.type = [_dataArray[indexPath.row] intValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
