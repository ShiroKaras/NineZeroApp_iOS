//
//  HTMascotDisplayController.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/17.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTMascotDisplayController.h"
#import "HTUIHeader.h"
#import "HTMascotView.h"
#import "HTMascotPropView.h"
#import "HTMascotPropMoreView.h"

static CGFloat kDuration = 0.3;

@interface HTMascotDisplayController () <HTMascotPropViewDelegate, HTMascotPropMoreViewDelegate>

@property (nonatomic, strong) HTMascotView *onlyOneMascotImageView;
@property (nonatomic, strong) HTMascotView *mascotView;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) HTMascotTipView *mascotTipView;
@property (nonatomic, strong) HTMascotPropView *propView;
@property (nonatomic, strong) HTMascotPropMoreView *moreView;

@end

@implementation HTMascotDisplayController {
    NSArray<HTMascotProp *> *props;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    
//    self.onlyOneMascotImageView = [[HTMascotView alloc] initWithImage:[UIImage imageNamed:@"img_mascot_1_animation_1"]];
//    [self.view addSubview:self.onlyOneMascotImageView];
//    self.mascotTipView = [[HTMascotTipView alloc] init];
//    self.mascotTipView.tipNumber = 2;
//    [self.view addSubview:self.mascotTipView];
    
    NSArray<NSNumber *>* showIndexs = @[@0, @1, @2, @3, @4, @5, @6, @7];
    self.mascotView = [[HTMascotView alloc] initWithShowMascotIndexs:showIndexs];
    [self.view addSubview:self.mascotView];
    
    props = @[[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init],[[HTMascotProp alloc] init]];
    self.propView = [[HTMascotPropView alloc] initWithProps:props];
    self.propView.delegate = self;
    [self.view addSubview:self.propView];
    
//    self.tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mascot_1_default_msg_bg"]];
//    [self.view addSubview:self.tipImageView];
//    
//    self.tipLabel = [[UILabel alloc] init];
//    self.tipLabel.font = [UIFont systemFontOfSize:13];
//    self.tipLabel.textColor = [UIColor colorWithHex:0xd9d9d9];
//    self.tipLabel.text = @"快帮我寻找更多的零仔吧!";
//    [self.tipImageView addSubview:self.tipLabel];
    
    [self buildConstraints];
}

- (void)buildConstraints {
//    [self.onlyOneMascotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(@175);
//        make.width.equalTo(@157);
//        make.height.equalTo(@157);
//    }];
//    
//    [self.mascotTipView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.onlyOneMascotImageView.mas_top);
//        make.centerX.equalTo(self.onlyOneMascotImageView);
//    }];
    
    [self.mascotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    [self.propView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(ROUND_HEIGHT(180));
    }];
    
//    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.onlyOneMascotImageView.mas_bottom).equalTo(@11);
//    }];
//    
//    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.tipImageView);
//        make.centerY.equalTo(self.tipImageView).offset(4);
//    }];
}

#pragma mark - HTMascotPropView Delegate

- (void)didClickBottomArrawInMascotPropView:(HTMascotPropView *)mascotPropView {
    _moreView = [[HTMascotPropMoreView alloc] initWithProps:props andPageCount:0];
    [self.view addSubview:_moreView];
    _moreView.top = SCREEN_HEIGHT;
    _moreView.delegate = self;
    [UIView animateWithDuration:kDuration animations:^{
        _moreView.top = 0;
    }];
}

#pragma mark - HTMascotPropMoreView Delegate

- (void)didClickTopArrawInPropMoreView:(HTMascotPropMoreView *)propMoreView {
    if (propMoreView.pageCount == 0) {
        [UIView animateWithDuration:kDuration animations:^{
            propMoreView.top = SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            [propMoreView removeFromSuperview];
        }];
    } else {
        _moreView = [[HTMascotPropMoreView alloc] initWithProps:props andPageCount:propMoreView.pageCount - 1];
        [self.view addSubview:_moreView];
        _moreView.bottom = 0;
        _moreView.delegate = self;
        [UIView animateWithDuration:kDuration animations:^{
            _moreView.top = 0;
            propMoreView.top = SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            [propMoreView removeFromSuperview];
        }];
    }
}

- (void)didClickBottomArrawInPropMoreView:(HTMascotPropMoreView *)propMoreView {
    _moreView = [[HTMascotPropMoreView alloc] initWithProps:props andPageCount:propMoreView.pageCount + 1];
    [self.view addSubview:_moreView];
    _moreView.top = SCREEN_HEIGHT;
    _moreView.delegate = self;
    [UIView animateWithDuration:kDuration animations:^{
        _moreView.top = 0;
        propMoreView.bottom = 0;
    } completion:^(BOOL finished) {
        [propMoreView removeFromSuperview];
    }];
}

@end
