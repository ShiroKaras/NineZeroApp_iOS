//
//  SKSwipeViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/10/9.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKSwipeViewController.h"
#import "HTUIHeader.h"
#import "SKDownloadProgressView.h"
#import "SKScanningResultView.h"

@interface SKSwipeViewController ()
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *scanningGridLine;
@property (nonatomic, strong) NSArray<SKScanning *> *scanningList;
@property (nonatomic, strong) SKQuestion *question;
@property (nonatomic, strong) UIButton *giftButton;
@property (nonatomic, strong) UIImageView *giftMascotHand;
@property (nonatomic, assign) int swipeType;
@end

@implementation SKSwipeViewController

- (instancetype)initWithScanningList:(NSArray<SKScanning *> *)scanningList {
	self = [super init];
	if (self) {
		_swipeType = 0;
		_scanningList = scanningList;
	}
	return self;
}

- (instancetype)initWithQuestion:(SKQuestion *)question {
	self = [super init];
	if (self) {
		_swipeType = 1;
		_question = question;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.glView = [[OpenGLView alloc] initWithFrame:self.view.bounds withSwipeType:_swipeType targetsCount:(int)_scanningList.count];
	[self.view addSubview:self.glView];
	[self.glView setOrientation:[[UIApplication sharedApplication] statusBarOrientation]];

	//扫描线
	_scanningGridLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_scanning_gridlines"]];
	[_scanningGridLine sizeToFit];
	_scanningGridLine.top = 0;
	_scanningGridLine.right = 0;
	[self.view addSubview:_scanningGridLine];

	[UIView animateWithDuration:1.0
		animations:^{
		    _scanningGridLine.left = SCREEN_WIDTH;
		}
		completion:^(BOOL finished) {
		    _scanningGridLine.right = 0;
		    _scanningGridLine.alpha = 0.4;
		    [UIView animateWithDuration:1.0
			    animations:^{
				_scanningGridLine.left = SCREEN_WIDTH;
			    }
			    completion:^(BOOL finished) {
				[_scanningGridLine removeFromSuperview];
			    }];
		}];

	//提示
	self.tipImageView = [[UIImageView alloc] init];
	self.tipImageView.layer.masksToBounds = YES;
	self.tipImageView.image = [UIImage imageNamed:@"img_ar_hint_bg"];
	self.tipImageView.contentMode = UIViewContentModeBottom;
	[self.tipImageView sizeToFit];
	[self.view addSubview:self.tipImageView];
	self.tipLabel = [[UILabel alloc] init];
	if (_swipeType == 0) {
		self.tipLabel.text = _scanningList[0].hint;
	} else if (_swipeType == 1) {
		self.tipLabel.text = _question.hint;
	}
	self.tipLabel.font = [UIFont systemFontOfSize:13];
	self.tipLabel.textColor = [UIColor colorWithHex:0x9d9d9d];
	[self.tipImageView addSubview:self.tipLabel];
	[self showtipImageView];

	self.giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.view addSubview:self.giftButton];
	//摇动动画
	CABasicAnimation *animation = [[CABasicAnimation alloc] init];
	animation.fromValue = @(-0.3);
	animation.toValue = @(0.3);
	animation.duration = 0.2;
	animation.repeatCount = 100;
	animation.autoreverses = YES;
	animation.delegate = self;
	[self.giftButton.layer addAnimation:animation forKey:@"animateLayer"];

	self.giftMascotHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_loadingvideo_gift_1"]];
	[self.giftMascotHand sizeToFit];
	[self.view addSubview:self.giftMascotHand];

	[self buildConstrains];

	if (!NO_NETWORK) {
		//进度条
		SKDownloadProgressView *progressView = [[SKDownloadProgressView alloc] init];
		progressView.center = self.view.center;
		[self.view addSubview:progressView];

		[UIView animateWithDuration:0.5
			animations:^{
			    [progressView setProgressViewPercent:1.];
			}
			completion:^(BOOL finished) {
			    [progressView removeFromSuperview];
			}];

		[self loadData];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.glView start];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.glView stop];
	for (UIView *view in KEY_WINDOW.subviews) {
		if ([view isKindOfClass:[SKScanningResultView class]]) {
			[view removeFromSuperview];
		}
	}
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	[self.glView resize:self.view.bounds orientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.glView setOrientation:toInterfaceOrientation];
}

- (void)buildConstrains {
	[self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.bottom.equalTo(@(-55));
	    make.centerX.equalTo(self.view);
	    make.width.equalTo(@(288));
	    make.height.equalTo(@(86));
	}];

	[self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.centerX.equalTo(self.tipImageView);
	    make.bottom.equalTo(self.tipImageView.mas_bottom).offset(-27);
	}];

	[self.giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.size.mas_equalTo(CGSizeMake(54, 42));
	    make.bottom.equalTo(self.view.mas_bottom).offset(-14);
	    make.right.equalTo(self.view.mas_right).offset(-14);
	}];

	[self.giftMascotHand mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.right.equalTo(self.view);
	    make.centerY.equalTo(self.giftButton);
	}];
}

- (void)loadData {
	[[[SKServiceManager sharedInstance] scanningService] getScanningWithCallBack:^(BOOL success, SKResponsePackage *package){

	}];
}

#pragma mark - Delegate

- (void)onCaptureMascotSuccessful {
	[self.delegate didClickBackButtonInScanningResultView:self];
}

#pragma mark - Actions

- (void)showtipImageView {
	self.tipImageView.alpha = 1.0;
	[UIView animateWithDuration:0.3
			      delay:10.0
			    options:UIViewAnimationOptionCurveEaseInOut
			 animations:^{
			     self.tipImageView.alpha = 0;
			 }
			 completion:^(BOOL finished){

			 }];
	//    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(hidetipImageView) userInfo:nil repeats:NO];
}

- (void)hidetipImageView {
	[UIView animateWithDuration:0.3
			 animations:^{
			     self.tipImageView.alpha = 0;
			 }];
}
@end
