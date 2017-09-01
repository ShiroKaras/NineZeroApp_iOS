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
    scrollView.backgroundColor = [UIColor colorWithHex:0x101010];
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];

    for (int i=0; i<3; i++) {
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_guidepage_%d",i+1]]];
        [scrollView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(scrollView);
            make.height.equalTo(@(SCREEN_WIDTH/32*44));
            make.top.equalTo(scrollView);
            make.left.equalTo(@(SCREEN_WIDTH*i));
        }];
    }
    
	_enterButton = [UIButton new];
	[_enterButton addTarget:self action:@selector(onClickEnterButton:) forControlEvents:UIControlEventTouchUpInside];
    [_enterButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [_enterButton setBackgroundImage:[UIImage imageWithColor:COMMON_GREEN_COLOR] forState:UIControlStateHighlighted];
	[_enterButton setImage:[UIImage imageNamed:@"btn_guidepage_enter"] forState:UIControlStateNormal];
    [_enterButton setImage:[UIImage imageNamed:@"btn_guidepage_enter_highlight"] forState:UIControlStateHighlighted];
    [scrollView addSubview:_enterButton];
    
    _enterButton.size = CGSizeMake(SCREEN_WIDTH, 50);
    _enterButton.left = SCREEN_WIDTH *2;
    _enterButton.bottom = scrollView.bottom;
}

- (void)onClickEnterButton:(UIButton *)sender {
	if (self.didSelectedEnter) {
		self.didSelectedEnter();
	}
}

@end
