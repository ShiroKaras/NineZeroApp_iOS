//
//  SKShareRewardController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/10/17.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKShareRewardController.h"
#import "HTUIHeader.h"

@interface SKShareRewardController ()
@property (nonatomic, assign) long coinCount;
@end

@implementation SKShareRewardController

- (instancetype)initWithCoinNumber:(long)coinCount
{
    self = [super init];
    if (self) {
        _coinCount = coinCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sharepage_share3"]];
    [headerImageView sizeToFit];
    [self.view addSubview:headerImageView];
    
    UIImageView *getImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sharepage_share1"]];
    [getImageView sizeToFit];
    [self.view addSubview:getImageView];
    
    UIImageView *coinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sharepage_share2"]];
    [coinImageView sizeToFit];
    [self.view addSubview:coinImageView];
    
    UILabel *coinCountLabel = [[UILabel alloc] init];
    coinCountLabel.text = @"2";
    coinCountLabel.textAlignment = NSTextAlignmentCenter;
    //coinCountLabel.text = [NSString stringWithFormat:@"%ld", _coinCount];
    coinCountLabel.textColor = [UIColor colorWithHex:0xED203B];
    coinCountLabel.font = MOON_FONT_OF_SIZE(19);
    [coinCountLabel sizeToFit];
    [self.view addSubview:coinCountLabel];
    
    UIButton *sureButton = [HTLoginButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    sureButton.enabled = YES;
    [sureButton addTarget:self action:@selector(onClickSureButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureButton];
    
    __weak __typeof(self)weakSelf = self;
    
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(ROUND_HEIGHT_FLOAT(143));
        make.centerX.equalTo(weakSelf.view);
    }];
    
    [getImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView);
        make.top.equalTo(headerImageView.mas_bottom).offset(20);
    }];
    
    [coinCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@12);
        make.centerY.equalTo(getImageView);
        make.left.equalTo(getImageView.mas_right);
    }];
    
    [coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coinCountLabel.mas_right);
        make.centerY.equalTo(coinCountLabel);
    }];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onClickSureButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
