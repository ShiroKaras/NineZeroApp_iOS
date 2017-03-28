//
//  NZTaskViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/28.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZTaskViewController.h"
#import "HTUIHeader.h"

#import "NZTaskCell.h"

@interface NZTaskViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation NZTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[NZTaskCell class] forCellReuseIdentifier:NSStringFromClass([NZTaskCell class])];
    [self.view addSubview:self.tableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NZTaskCell class])];
    if (cell==nil) {
        cell = [[NZTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NZTaskCell class])];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZTaskCell *cell = (NZTaskCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

// 先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        /*
         [_dataMArr removeObjectAtIndex:indexPath.row];
         [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
         [_tableView reloadData];
         */
    }
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
