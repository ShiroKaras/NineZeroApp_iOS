//
//  SKMyBadgesViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/6.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKMyBadgesViewController.h"
#import "HTUIHeader.h"

@interface SKMyBadgesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SKMyBadgesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    WS(weakself);
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UILabel *myBadgeTitleLabel = [UILabel new];
    myBadgeTitleLabel.text = @"我的勋章";
    myBadgeTitleLabel.textColor = [UIColor whiteColor];
    myBadgeTitleLabel.font = PINGFANG_FONT_OF_SIZE(20);
    [myBadgeTitleLabel sizeToFit];
    [self.view addSubview:myBadgeTitleLabel];
    
    UIImageView *nextBadgeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userptofiles_exptext"]];
    [nextBadgeImageView sizeToFit];
    [self.view addSubview:nextBadgeImageView];
    
    UIImageView *expArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userptofiles_exp"]];
    [expArrowImageView sizeToFit];
    [self.view addSubview:expArrowImageView];
    
    UIView *progressBarView = [UIView new];
    progressBarView.layer.cornerRadius = 8;
    progressBarView.backgroundColor = [UIColor colorWithHex:0x1f1f1f];
    [self.view addSubview:progressBarView];
    
    UILabel *expLabel = [UILabel new];
    expLabel.text = @"190";
    expLabel.textColor = [UIColor colorWithHex:0xffed41];
    expLabel.font = MOON_FONT_OF_SIZE(12);
    [expLabel sizeToFit];
    [self.view addSubview:expLabel];
    
    [myBadgeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(progressBarView);
        make.bottom.equalTo(nextBadgeImageView.mas_top).offset(-11);
        make.top.equalTo(@68);
    }];
    
    [nextBadgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(progressBarView).offset(10);
        make.bottom.equalTo(progressBarView.mas_top).offset(-9);
    }];

    [expArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nextBadgeImageView);
        make.left.equalTo(nextBadgeImageView.mas_right).offset(2);
    }];
    
    [expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nextBadgeImageView);
        make.left.equalTo(expArrowImageView.mas_right).offset(5);
    }];
    
    [progressBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.width.equalTo(@166);
        make.height.equalTo(@16);
    }];
    
    UIImageView *badgeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mymedal_medal"]];
    [badgeImageView sizeToFit];
    [self.view addSubview:badgeImageView];
    [badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.view);
        make.right.equalTo(weakself.view);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 162, SCREEN_WIDTH, SCREEN_HEIGHT-162) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = COMMON_SEPARATOR_COLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *headBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.width, 6)];
    headBar.backgroundColor = [UIColor colorWithHex:0x242424];
    [cell addSubview:headBar];
    
    UIView *footBar = [[UIView alloc] initWithFrame:CGRectMake(0, 125, cell.width, 25)];
    footBar.backgroundColor = [UIColor colorWithHex:0x242424];
    [cell addSubview:footBar];
    UIView *footBar2 = [[UIView alloc] initWithFrame:CGRectMake(0, 150, cell.width, 4)];
    footBar2.backgroundColor = [UIColor colorWithHex:0x0e0e0e];
    
    UIImageView *badgeLeft = [[UIImageView alloc] init];
    badgeLeft.backgroundColor = [UIColor redColor];
    [cell addSubview:badgeLeft];
    UIImageView *badgeRight = [[UIImageView alloc] init];
    badgeRight.backgroundColor = [UIColor redColor];
    [cell addSubview:badgeRight];
    [badgeLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(120));
        make.height.mas_equalTo(ROUND_WIDTH_FLOAT(120)/120*90);
        make.left.equalTo(ROUND_WIDTH(22));
        make.bottom.equalTo(cell.mas_bottom).offset(-14);
    }];
    [badgeRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(badgeLeft.mas_width);
        make.height.equalTo(badgeLeft.mas_height);
        make.right.equalTo(cell.mas_right).offset(ROUND_WIDTH_FLOAT(-22));
        make.bottom.equalTo(cell.mas_bottom).offset(-14);
    }];
    
    [cell addSubview:footBar2];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROUND_HEIGHT_FLOAT(154);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
