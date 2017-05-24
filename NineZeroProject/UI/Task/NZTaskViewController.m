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
@property (nonatomic, strong) NSMutableArray<SKStronghold*> *strongholdArray;
@property (nonatomic, assign) NSInteger mid;

@property (nonatomic, strong) AMapLocationManager *locationManager;
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mid = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createUI];
    [self registerLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    NSArray *mascotName = @[@"零仔〇",@"sloth", @"pride",@"wrath",@"envy",@"lust",@"gluttony"];
    if (_mid>1&&_mid<8) {
        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_taskpage_title_%@",mascotName[_mid-1]]]];
    } else {
        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskbook_title"]];
    }
    [self.view addSubview:_titleImageView];
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_top).offset(42);
        make.centerX.equalTo(self.view);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[NZTaskCell class] forCellReuseIdentifier:NSStringFromClass([NZTaskCell class])];
    [self.view addSubview:self.tableView];
}

- (void)loadDataWithLocation:(CLLocation*)location {
    if (_mid == 0) {
        [[[SKServiceManager sharedInstance] strongholdService] getTaskListWithLocation:CLLocationCoordinate2DMake(39.924345, 116.519776) callback:^(BOOL success, NSArray<SKStronghold *> *strongholdList) {
            _strongholdArray = [NSMutableArray arrayWithArray:strongholdList];
            [self.tableView reloadData];
            if (_strongholdArray.count == 0) {
                [self loadBlankView];
            }
        }];
    }
    if (_mid>1&&_mid<8) {
        [[[SKServiceManager sharedInstance] strongholdService] getStrongholdListWithMascotID:[NSString stringWithFormat:@"%ld", (long)(long)_mid] forLocation:location callback:^(BOOL success, NSArray<SKStronghold *> *strongholdList) {
            _strongholdArray = [NSMutableArray arrayWithArray:strongholdList];
            [self.tableView reloadData];
        }];
    }
}

- (void)loadBlankView {
    HTBlankView *blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_task"] text:@"据点那么多，你不去看看？"];
    [blankView setOffset:10];
    [self.view addSubview:blankView];
    blankView.center = self.view.center;
}

- (void)registerLocation {
    self.locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，可修改，最小2s
    self.locationManager.locationTimeout = 2;
    //   逆地理请求超时时间，可修改，最小2s
    self.locationManager.reGeocodeTimeout = 2;
    
    // 带逆地理（返回坐标和地址信息）
    [self.locationManager
     requestLocationWithReGeocode:YES
     completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode,
                       NSError *error) {
         if (error) {
             DLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
         }
         if (regeocode) {
             DLog(@"citycode:%@", regeocode.citycode);
         }
         DLog(@"location:%@", location);
         [self loadDataWithLocation:location];
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
    if(_mid>1&&_mid<8)
        return YES;
    else
        return NO;
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[[SKServiceManager sharedInstance] strongholdService] deleteTaskWithID:_strongholdArray[indexPath.row].id];
        [_strongholdArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView reloadData];
        if (_strongholdArray.count==0) {
            [self loadBlankView];
        }
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
