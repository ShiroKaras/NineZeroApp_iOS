//
//  SKMascotIndexViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKMascotIndexViewController.h"
#import "HTUIHeader.h"

#import "SKMascotView.h"

@interface SKMascotIndexViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mScrollView;

@end

@implementation SKMascotIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mScrollView.delegate = self;
    _mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 8, SCREEN_HEIGHT);
    _mScrollView.pagingEnabled = YES;
    _mScrollView.showsHorizontalScrollIndicator = NO;
    _mScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mScrollView];
    
    NSArray *array = @[@(SKMascotTypeDefault), @(SKMascotTypeEnvy), @(SKMascotTypeGluttony), @(SKMascotTypeGreed), @(SKMascotTypePride), @(SKMascotTypeSloth), @(SKMascotTypeWrath), @(SKMascotTypeLust)];
    for (int i = 0; i<8; i++) {
        SKMascotView *mascotView = [[SKMascotView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Type:[array[i] integerValue]];
        [_mScrollView addSubview:mascotView];
    }
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@4);
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //得到图片移动相对原点的坐标
    CGPoint point=scrollView.contentOffset;
    //移动不能超过左边;
    //    if(point.x<0){
    //        point.x=0;
    //        scrollView.contentOffset=point;
    //    }
    //移动不能超过右边
    if(point.x>8*(SCREEN_WIDTH)){
        point.x=(SCREEN_WIDTH)*8;
        scrollView.contentOffset=point;
    }
}


#pragma mark - Actions

- (void)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
