//
//  SKAnswerDetailView.m
//  NineZeroProject
//
//  Created by SinLemon on 16/7/4.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKAnswerDetailView.h"
#import "HTUIHeader.h"
#import "Reachability.h"
#import "JPUSHService.h"
#import "HTAlertView.h"
#import "HTBlankView.h"

@interface SKAnswerDetailView ()

@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, strong) UIButton *cancelButton;           //关闭按钮
@property (nonatomic, strong) UIImageView *headerImageView;     //头图
@property (nonatomic, strong) UITextView *contentView;          //文字内容

@property (nonatomic, strong) UIView *articleBackView;

@end

@implementation SKAnswerDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _cancelButton.right = self.right - 11;
    _cancelButton.top = 11;
    
    _headerImageView.top = _cancelButton.bottom+5;
    _headerImageView.left = 7;
    _headerImageView.right = self.right-7;
    _headerImageView.height = _headerImageView.width/306*72;
    
    _contentView.top = _headerImageView.bottom+21;
    _contentView.left = 23;
    _contentView.right = self.right -23;
    _contentView.bottom = self.bottom;
}

- (void)createUI {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickCancelButton)];
    _dimmingView = [[UIView alloc] init];
    _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [_dimmingView addGestureRecognizer:tap];
    [self addSubview:_dimmingView];
    
    [HTProgressHUD show];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton addTarget:self action:@selector(didClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setImage:[UIImage imageNamed:@"btn_fullscreen_close"] forState:UIControlStateNormal];
    [_cancelButton setImage:[UIImage imageNamed:@"btn_fullscreen_close_highlight"] forState:UIControlStateHighlighted];
    [_cancelButton sizeToFit];
    [_cancelButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [self addSubview:_cancelButton];
    
    _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 11+40+5, self.width, self.height-11-40-5)];
    _backScrollView.backgroundColor = [UIColor redColor];
    
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.backgroundColor = [UIColor redColor];
    [self addSubview:_headerImageView];
    
    _contentView = [[UITextView alloc] init];
    _contentView.backgroundColor = [UIColor purpleColor];
    [self addSubview:_contentView];

    int articleCount = 1;
    float backViewheight = 52.5+2+(15+108)*articleCount;
    _articleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottom - backViewheight, self.width, backViewheight)];
    [self addSubview:_articleBackView];
}

#pragma mark - Action

- (void)didClickCancelButton {
    [AppDelegateInstance.mainController showBottomButton:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.top = self.height;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
