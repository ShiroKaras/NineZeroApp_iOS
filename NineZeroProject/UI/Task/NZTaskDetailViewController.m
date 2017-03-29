//
//  NZTaskDetailViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/28.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZTaskDetailViewController.h"
#import "HTUIHeader.h"
#import "NZTaskDetailView.h"

@interface NZTaskDetailViewController ()
@property (nonatomic, strong) UIImageView   *titleImageView;
@property (nonatomic, strong) UIView        *tabBackView;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView   *indicatorLine;
@property (nonatomic, strong) UIButton      *button1;
@property (nonatomic, strong) UIButton      *button2;
@property (nonatomic, strong) UIScrollView  *scrollView1;
@property (nonatomic, strong) UIScrollView  *scrollView2;
@end

@implementation NZTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    WS(weakSelf);
    self.view.backgroundColor = COMMON_BG_COLOR;
    
    _titleImageView = [UIImageView new];
    _titleImageView.image = [UIImage imageNamed:@"img_monday_music_cover_default"];
    _titleImageView.layer.masksToBounds = YES;
    _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_titleImageView];
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(weakSelf.view.width, weakSelf.view.width/320*240));
        make.top.equalTo(@0);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    //TabView
    _tabBackView = [UIView new];
    _tabBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tabBackView];
    [_tabBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(weakSelf.view.width, 54));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(_titleImageView.mas_bottom);
    }];
    
    _button1 = [UIButton new];
    [_button1 addTarget:self action:@selector(didClickButton1:) forControlEvents:UIControlEventTouchUpInside];
    [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_scene_highlight"] forState:UIControlStateNormal];
    [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_scene_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:_button1];
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 27));
        make.centerY.equalTo(_tabBackView);
        make.left.equalTo(@82);
    }];
    
    _button2 = [UIButton new];
    [_button2 addTarget:self action:@selector(didClickButton2:) forControlEvents:UIControlEventTouchUpInside];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_arrest"] forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_arrest_highlight"] forState:UIControlStateHighlighted];
    [self.view addSubview:_button2];
    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 27));
        make.centerY.equalTo(_tabBackView);
        make.right.equalTo(_tabBackView).offset(-82);
    }];
    
    UIView *underLine = [UIView new];
    [_tabBackView addSubview:underLine];
    [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.width, 1));
        make.centerX.equalTo(_tabBackView);
        make.bottom.equalTo(_tabBackView);
    }];
    
    _indicatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_taskdetailpage_choose"]];
    [_tabBackView addSubview:_indicatorLine];
    [_indicatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_button1);
        make.bottom.equalTo(underLine.mas_top);
    }];
    
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
//    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tabBackView.mas_bottom);
        make.bottom.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    [self.view layoutIfNeeded];
    _scrollView.contentSize = CGSizeMake(self.view.width*2, _scrollView.height);
    
    _scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, _scrollView.height)];
    _scrollView1.contentSize = CGSizeMake(self.view.width, 1000);
    _scrollView1.backgroundColor = [UIColor yellowColor];
    _scrollView1.bounces = NO;
    [_scrollView addSubview:_scrollView1];
    
    NZTaskDetailView *detailView = [[NZTaskDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1000) withModel:nil];
    [_scrollView1 addSubview:detailView];
}

#pragma mark - Actions

- (void)didClickButton1:(UIButton*)sender {
    [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_scene_highlight"] forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_arrest"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_indicatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_button1);
            make.bottom.equalTo(_tabBackView.mas_bottom).offset(-1);
        }];
        [_indicatorLine.superview layoutIfNeeded];
    }];
}

- (void)didClickButton2:(UIButton*)sender {
    [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_scene"] forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_taskpage_arrest_highlight"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_indicatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_button2);
            make.bottom.equalTo(_tabBackView.mas_bottom).offset(-1);
        }];
        [_indicatorLine.superview layoutIfNeeded];
    }];
}

@end
