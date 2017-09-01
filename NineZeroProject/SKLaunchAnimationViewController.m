//
//  SKLaunchAnimationViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/5/21.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKLaunchAnimationViewController.h"
#import "HTUIHeader.h"

@interface SKLaunchAnimationViewController ()

@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIButton *enterButton;

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@end

@implementation SKLaunchAnimationViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];

	[self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	self.view = nil;
}

#pragma mark - Acitons
- (void)createUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);
    scrollView.backgroundColor = COMMON_GREEN_COLOR;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];

	_enterButton = [UIButton new];
    _enterButton.backgroundColor = COMMON_RED_COLOR;
	[_enterButton addTarget:self action:@selector(onClickEnterButton:) forControlEvents:UIControlEventTouchUpInside];
//	[_enterButton setImage:[UIImage imageNamed:@"btn_trailer_enter"] forState:UIControlStateNormal];
    [scrollView addSubview:_enterButton];
    
//    _enterButton.size = CGSizeMake(100, 50);
//    _enterButton.centerX = scrollView.centerX+SCREEN_WIDTH*2;
//    _enterButton.centerY = scrollView.centerY;
    [_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 50));
        make.centerX.equalTo(scrollView.mas_centerX).offset(SCREEN_WIDTH*2);
        make.centerY.equalTo(scrollView.mas_centerY);
    }];
}

- (void)onClickEnterButton:(UIButton *)sender {
	if (self.didSelectedEnter) {
		self.didSelectedEnter();
	}
}

@end
