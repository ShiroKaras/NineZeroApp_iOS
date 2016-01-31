//
//  HTRewardController.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/26.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTRewardController.h"
#import "HTUIHeader.h"

@interface HTRewardController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIImageView *prefixOverImageView;
@property (nonatomic, strong) UIImageView *suffixOverImageView;
@property (nonatomic, strong) UIImageView *prefixGetImageView;
@property (nonatomic, strong) UIImageView *suffixGetImageView;
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) UILabel *goldenLabel;
@property (nonatomic, strong) UIImageView *andImageView;
@property (nonatomic, strong) UIImageView *getImageView;
@end

@implementation HTRewardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.85];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.85];
    _scrollView.delaysContentTouches = NO;
    [self.view addSubview:_scrollView];
    
    _prefixOverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_1"]];
    [_scrollView addSubview:_prefixOverImageView];
    _suffixOverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_2"]];
    [_scrollView addSubview:_suffixOverImageView];
    _prefixGetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_3"]];
    [_scrollView addSubview:_prefixGetImageView];
    _suffixGetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_4"]];
    [_scrollView addSubview:_suffixGetImageView];
    _andImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_and"]];
    [_scrollView addSubview:_andImageView];
    _getImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_5"]];
    [_scrollView addSubview:_getImageView];
    
    _percentLabel = [[UILabel alloc] init];
    _percentLabel.font = [UIFont fontWithName:@"Moon-Bold" size:32.5];
    _percentLabel.textColor = [UIColor colorWithHex:0x24ddb2];
    _percentLabel.text = @"98%";
    [_scrollView addSubview:_percentLabel];
    [_percentLabel sizeToFit];
    
    _goldenLabel = [[UILabel alloc] init];
    _goldenLabel.font = [UIFont fontWithName:@"Moon-Bold" size:23];
    _goldenLabel.textColor = [UIColor colorWithHex:0xed203b];
    _goldenLabel.text = @"20";
    [_scrollView addSubview:_goldenLabel];
    [_goldenLabel sizeToFit];
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureButton setTitle:@"完成" forState:UIControlStateNormal];
    _sureButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _sureButton.backgroundColor = [UIColor colorWithHex:0x24ddb2];
    [_sureButton addTarget:self action:@selector(onClickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureButton];
}

- (void)onClickSureButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
    _prefixOverImageView.left = ROUND_WIDTH_FLOAT(56);
    _prefixOverImageView.top = ROUND_HEIGHT_FLOAT(62);
    _suffixOverImageView.top = _prefixOverImageView.bottom + 10;
    _percentLabel.left = _prefixOverImageView.right + 5;
    _percentLabel.bottom = _prefixOverImageView.bottom + 5;
    _suffixOverImageView.left = _percentLabel.left;
    
    _prefixGetImageView.left = ROUND_WIDTH_FLOAT(54);
    _prefixGetImageView.top = _prefixOverImageView.bottom + 60;
    _goldenLabel.left = _prefixGetImageView.right + 3;
    _goldenLabel.bottom = _prefixGetImageView.bottom + 3;
    _suffixGetImageView.left = _goldenLabel.right + 5;
    _suffixGetImageView.bottom = _prefixGetImageView.bottom;
    
    _andImageView.top = _suffixGetImageView.bottom + ROUND_HEIGHT_FLOAT(29);
    _andImageView.centerX = SCREEN_WIDTH / 2;
    _getImageView.left = _andImageView.right + 16;
    _getImageView.centerY = _andImageView.centerY;

    _sureButton.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    
    // TODO
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

@end
