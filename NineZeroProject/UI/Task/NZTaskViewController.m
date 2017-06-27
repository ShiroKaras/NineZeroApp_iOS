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
@property (nonatomic, strong) NSArray *mascotName;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SKStronghold*> *strongholdArray;
@property (nonatomic, assign) NSInteger mid;
@property (nonatomic, strong) UIButton *helpButton;
@property (nonatomic, strong) UIView *helperView;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) BOOL isOpenLBS;
@property (nonatomic, assign) BOOL hideHelperButton;
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
        _hideHelperButton = YES;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self registerLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.automaticallyAdjustsScrollViewInsets = false;
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    _mascotName = @[@"lingzai",@"sloth", @"pride",@"wrath",@"envy",@"lust",@"gluttony"];
    if (_mid>1&&_mid<8) {
        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_taskpage_title_%@1",_mascotName[_mid-1]]]];
    } else {
        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskbook_title"]];
    }
    [self.view addSubview:_titleImageView];
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_top).offset(42);
        make.centerX.equalTo(self.view);
    }];
    
    // 帮助按钮
    _helpButton = [UIButton new];
    _helpButton.hidden = _hideHelperButton;
    [_helpButton addTarget:self action:@selector(helpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_helpButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_introduce"] forState:UIControlStateNormal];
    [_helpButton setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_introduce_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:_helpButton];
    [_helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 27));
        make.centerY.equalTo(_titleImageView);
        make.right.equalTo(@(-13));
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[NZTaskCell class] forCellReuseIdentifier:NSStringFromClass([NZTaskCell class])];
    [self.view addSubview:self.tableView];
    
    if (NO_NETWORK) {
        UIView *converView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        converView.backgroundColor = COMMON_BG_COLOR;
        [self.view addSubview:converView];
        HTBlankView *_blankView = [[HTBlankView alloc] initWithImage:[UIImage imageNamed:@"img_blankpage_net"] text:@"一点信号都没"];
        [_blankView setOffset:10];
        [converView addSubview:_blankView];
        _blankView.center = converView.center;
    }
    
    if (FIRST_LAUNCH_TASKLIST) {
        EVER_LAUNCH_TASKLIST
        [self helpButtonClicked:nil];
    }
}

- (void)loadDataWithLocation:(CLLocation*)location {
    if (_mid == 0) {
        [[[SKServiceManager sharedInstance] strongholdService] getTaskListWithLocation:location callback:^(BOOL success, NSArray<SKStronghold *> *strongholdList) {
            [HTProgressHUD dismiss];
            _strongholdArray = [NSMutableArray arrayWithArray:strongholdList];
            [self.tableView reloadData];
            if (_strongholdArray.count == 0) {
                [self loadBlankView];
            }
        }];
    }
    if (_mid>1&&_mid<8) {
        [[[SKServiceManager sharedInstance] strongholdService] getStrongholdListWithMascotID:[NSString stringWithFormat:@"%ld", (long)(long)_mid] location:location cityCode:_cityCode callback:^(BOOL success, NSArray<SKStronghold *> *strongholdList) {
            [HTProgressHUD dismiss];
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
    [HTProgressHUD show];
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
             _isOpenLBS = NO;
         }
         if (regeocode) {
             DLog(@"citycode:%@", regeocode.citycode);
         }
         DLog(@"location:%@", location);
         
         if (location != nil)   _isOpenLBS = YES;
         else _isOpenLBS = NO;
         
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
    cell.distanceLabel.hidden = !_isOpenLBS;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZTaskCell *cell = (NZTaskCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

// 先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_mid>1&&_mid<8)
        return NO;
    else
        return YES;
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

#pragma mark - Actions

- (void)helpButtonClicked:(UIButton *)sender {
    UIImageView *helpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    helpImageView.contentMode = UIViewContentModeScaleAspectFit;
    helpImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeHelper:)];
    tap.numberOfTapsRequired = 1;
    [helpImageView addGestureRecognizer:tap];
    
    if(SCREEN_WIDTH == IPHONE5_SCREEN_WIDTH) {
        helpImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_taskpage_%@info_640",_mascotName[_mid-1]]];
    } else if (SCREEN_WIDTH == IPHONE6_SCREEN_WIDTH) {
        helpImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_taskpage_%@info_750",_mascotName[_mid-1]]];
    } else if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH) {
        helpImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_taskpage_%@info_1242",_mascotName[_mid-1]]];
    }
    [KEY_WINDOW addSubview:helpImageView];
    
    UILabel *bottomLabel = [UILabel new];
    bottomLabel.text = @"点击任意区域关闭";
    bottomLabel.textColor = [UIColor colorWithHex:0xa2a2a2];
    bottomLabel.font = PINGFANG_FONT_OF_SIZE(12);
    [bottomLabel sizeToFit];
    [helpImageView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(helpImageView);
        make.bottom.equalTo(helpImageView).offset(-16);
    }];
    
    helpImageView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        helpImageView.alpha = 1;
    }];
}

- (void)closeHelper:(UITapGestureRecognizer*)gestureRecognizer {
    UIImageView *v = (UIImageView *)[gestureRecognizer view];
    [UIView animateWithDuration:0.3 animations:^{
        v.alpha = 0;
    } completion:^(BOOL finished) {
        [v removeFromSuperview];
        [_helpButton setImage:[UIImage imageNamed:@"btn_taskpage_introduce_highlight"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.075
                         animations:^{
                             _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 1.1, 1.1);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.075
                                              animations:^{
                                                  _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 0.9, 0.9);
                                              }
                                              completion:^(BOOL finished) {
                                                  [UIView animateWithDuration:0.075
                                                                   animations:^{
                                                                       _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 1.1, 1.1);
                                                                   }
                                                                   completion:^(BOOL finished) {
                                                                       [UIView animateWithDuration:0.075
                                                                                        animations:^{
                                                                                            _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 0.9, 0.9);
                                                                                        }
                                                                                        completion:^(BOOL finished) {
                                                                                            [_helpButton setImage:[UIImage imageNamed:@"btn_taskpage_introduce"] forState:UIControlStateNormal];
                                                                                        }];
                                                                   }];
                                              }];
                         }];
    }];
}


@end
