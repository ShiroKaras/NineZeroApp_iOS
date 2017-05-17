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
#import "NZTaskDetailViewController.h"

@interface NZTaskViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<SKStronghold*> *strongholdArray;
@property (nonatomic, assign) NSInteger mid;
@end

@implementation NZTaskViewController

- (instancetype)initWithMascotID:(NSInteger)mid
{
    self = [super init];
    if (self) {
        _mid = mid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    NSArray *mascotName = @[@"零仔〇",@"sloth", @"pride",@"wrath",@"envy",@"lust",@"gluttony"];
    if (_mid>1&&_mid<8) {
        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_taskpage_title_%@",mascotName[_mid-1]]]];
    } else {
        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskbook_title"]];
    }
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
    [self.tableView registerClass:[NZTaskCell class] forCellReuseIdentifier:NSStringFromClass([NZTaskCell class])];
    [self.view addSubview:self.tableView];

    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    [[[SKServiceManager sharedInstance] strongholdService] getStrongholdListWithMascotID:[NSString stringWithFormat:@"%ld", _mid] forLocation:CLLocationCoordinate2DMake(39.924345, 116.519776) callback:^(BOOL success, NSArray<SKStronghold *> *strongholdList) {
        _strongholdArray = strongholdList;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NZTaskCell class])];
    if (cell==nil) {
        cell = [[NZTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NZTaskCell class])];
    }
    [cell loadDataWith:_strongholdArray[indexPath.row]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NZTaskDetailViewController *controller = [[NZTaskDetailViewController alloc] initWithID:_strongholdArray[indexPath.row].id];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _strongholdArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
