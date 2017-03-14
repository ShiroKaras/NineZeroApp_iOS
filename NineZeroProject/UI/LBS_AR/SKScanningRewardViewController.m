//
//  SKScanningRewardViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/2/13.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "SKScanningRewardViewController.h"
#import "HTUIHeader.h"
#import "SKTicketView.h"
#import "YYAnimatedImageView.h"
#import "YYImage.h"
#import <SDWebImage/UIImage+GIF.h>
#import <UIImage+animatedGIF.h>
#import <YLGIFImage/YLGIFImage.h>
#import <YLGIFImage/YLImageView.h>

typedef NS_OPTIONS(NSUInteger, NZRewardType) {
	NZRewardTypeGold = 0,
	NZRewardTypePet = 1 << 0,
	NZRewardTypeProp = 1 << 1,
	NZRewardTypeTicket = 1 << 2
};

@interface SKScanningRewardViewController ()
@property (nonatomic, strong) HTBlankView *blankView;

@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) SKReward *reward;
@property (nonatomic, strong) UIView *rewardInfoView;
@end

@implementation SKScanningRewardViewController {
	NSString *_rewardID;
	NSString *_sId;
	NSUInteger _scanType; // 0普通扫一扫，1拼图扫一扫
}

- (instancetype)initWithRewardID:(NSString *)rewardID sId:(NSString *)sId scanType:(NSUInteger)scanType {
	if (self = [super init]) {
		_rewardID = rewardID;
		_sId = sId;
		_scanType = scanType;
	}
	return self;
}

- (instancetype)initWithReward:(SKReward *)reward {
	if (self = [super init]) {
		_reward = reward;
		_scanType = 1;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	if (NO_NETWORK) {
		self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
		[self.blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
		[self.view addSubview:self.blankView];
		self.blankView.top = ROUND_HEIGHT_FLOAT(217);
	} else if (!_reward) {
		[HTProgressHUD show];

		if (_scanType == 0) {
			[[[SKServiceManager sharedInstance] scanningService] getScanningRewardWithRewardId:_rewardID
												       sId:_sId
												  callback:^(BOOL success, SKResponsePackage *response) {
												      DLog(@"Reward:%@", response.data);
												      if (response.result == 0) {
													      [HTProgressHUD dismiss];
													      _reward = [SKReward mj_objectWithKeyValues:response.data];
													      if (_reward) {
														      [self createBaseRewardViewWithReward:_reward];
													      }
												      } else if (response.result == -9006) {
													      // 已获得该奖励
													      [HTProgressHUD dismiss];
													      [self dismissViewControllerAnimated:NO completion:nil];
												      }
												  }];
		} else if (_scanType == 1) {
			[[[SKServiceManager sharedInstance] scanningService] getScanningPuzzleRewardWithRewardId:_rewardID
													     sId:_sId
													callback:^(BOOL success, SKResponsePackage *response) {
													    DLog(@"Reward:%@", response.data);
													    if (response.result == 0) {
														    [HTProgressHUD dismiss];
														    _reward = [SKReward mj_objectWithKeyValues:response.data];
														    if (_reward) {
															    [self createBaseRewardViewWithReward:_reward];
														    }
													    } else if (response.result == -9006) {
														    // 已获得该奖励
														    [HTProgressHUD dismiss];
														    [self dismissViewControllerAnimated:NO completion:nil];
													    } else {
														    [self dismissViewControllerAnimated:NO completion:nil];
													    }
													}];
		}
	} else {
		[self createBaseRewardViewWithReward:_reward];
	}
}

- (void)reloadView {
	[self viewWillLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	if (self.navigationController) {
		self.navigationController.navigationBarHidden = YES;
	}
}

#pragma mark - Reward

- (void)createBaseRewardViewWithReward:(SKReward *)reward {
	UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
	alphaView.backgroundColor = [UIColor blackColor];
	alphaView.alpha = 0;
	[self.view addSubview:alphaView];

	[UIView animateWithDuration:0.3
			 animations:^{
			     alphaView.alpha = 0.8;
			 }];

	__weak __typeof__(self) weakSelf = self;
	_dimmingView = [[UIView alloc] init];
	_dimmingView.height = 188.f;

	[self.view addSubview:_dimmingView];
	[_dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.width.equalTo(@247);
	    make.centerX.equalTo(weakSelf.view);
	}];

	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
	tap.numberOfTapsRequired = 1;
	[self.view addGestureRecognizer:tap];

	UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_scan_gift"]];
	[_dimmingView addSubview:titleImageView];

	[titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.width.equalTo(weakSelf.dimmingView);
	    make.height.equalTo(@188);
	    make.centerX.equalTo(weakSelf.dimmingView);
	    make.top.equalTo(weakSelf.dimmingView);
	}];

	CGFloat height = _dimmingView.height + 10.f;

	if (_scanType == 1) { // 拼图扫一扫需要显示礼券
		[self createRewardInfoViewWithBaseHeight:&height];
		_dimmingView.height = height;
	}

	UILabel *bottomLabel = [UILabel new];
	bottomLabel.text = @"点击任意区域关闭";
	bottomLabel.textColor = [UIColor colorWithHex:0xa2a2a2];
	bottomLabel.font = PINGFANG_FONT_OF_SIZE(12);
	[bottomLabel sizeToFit];
	[self.view addSubview:bottomLabel];
	[bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.centerX.equalTo(weakSelf.view);
	    make.bottom.equalTo(weakSelf.view).offset(-16);
	}];

	if (_reward.ticket.ticket_id != nil) {
		//奖励 - 礼券
		if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH) {
			SKTicketView *card = [[SKTicketView alloc] initWithFrame:CGRectMake(0, 0, 362, 140) reward:self.reward.ticket];
			[_dimmingView addSubview:card];
			[card mas_makeConstraints:^(MASConstraintMaker *make) {
			    make.width.equalTo(@(362));
			    make.height.equalTo(@(140));
			    make.centerX.equalTo(weakSelf.dimmingView);
			    make.bottom.equalTo(weakSelf.dimmingView.mas_bottom).offset(-(SCREEN_HEIGHT - height - 32) / 2);
			}];
			_dimmingView.height += 140.f;
		} else if (SCREEN_WIDTH == IPHONE6_SCREEN_WIDTH) {
			SKTicketView *card = [[SKTicketView alloc] initWithFrame:CGRectMake(0, 0, 335, 130) reward:self.reward.ticket];
			[_dimmingView addSubview:card];
			[card mas_makeConstraints:^(MASConstraintMaker *make) {
			    make.width.equalTo(@335);
			    make.height.equalTo(@130);
			    make.centerX.equalTo(weakSelf.dimmingView);
			    make.bottom.equalTo(weakSelf.dimmingView.mas_bottom).offset(-(SCREEN_HEIGHT - height - 22) / 2);
			}];
			_dimmingView.height += 130.f;
		} else if (SCREEN_WIDTH == IPHONE5_SCREEN_WIDTH) {
			SKTicketView *card = [[SKTicketView alloc] initWithFrame:CGRectMake(0, 0, 280, 108) reward:self.reward.ticket];
			[_dimmingView addSubview:card];
			[card mas_makeConstraints:^(MASConstraintMaker *make) {
			    make.width.equalTo(@280);
			    make.height.equalTo(@108);
			    make.centerX.equalTo(weakSelf.dimmingView);
			    make.bottom.equalTo(weakSelf.dimmingView.mas_bottom).offset(-(SCREEN_HEIGHT - height) / 2);
			}];
			_dimmingView.height += 108.f;
		}
	}

	[_dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.height.mas_equalTo(weakSelf.dimmingView.height);
	    make.centerY.equalTo(weakSelf.view);
	}];
}

- (void)createRewardInfoViewWithBaseHeight:(CGFloat *)height {
	__weak __typeof__(self) weakSelf = self;
	if (_reward.gold.length > 0) {
		//金币行
		UIImageView *rewardImageView_txt_3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_homepage_gold"]];
		[_dimmingView addSubview:rewardImageView_txt_3];

		[rewardImageView_txt_3 mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.width.equalTo(@20);
		    make.height.equalTo(@20);
		    make.top.equalTo(weakSelf.dimmingView.mas_top).offset(*height);
		    make.left.equalTo(weakSelf.dimmingView.mas_left).offset(82.5f);
		}];

		UILabel *iconCountLabel = [UILabel new];
		iconCountLabel.textColor = COMMON_RED_COLOR;
		iconCountLabel.text = _reward.gold;
		iconCountLabel.font = MOON_FONT_OF_SIZE(19);
		[iconCountLabel sizeToFit];
		[_dimmingView addSubview:iconCountLabel];
		[iconCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.left.equalTo(rewardImageView_txt_3.mas_right).offset(6);
		    make.centerY.equalTo(rewardImageView_txt_3);
		}];

		UIImageView *rewardImageView_txt_gold = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_goldtext"]];
		[_dimmingView addSubview:rewardImageView_txt_gold];
		[rewardImageView_txt_gold mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.width.equalTo(@37);
		    make.height.equalTo(@20);
		    make.left.equalTo(iconCountLabel.mas_right).offset(6);
		    make.centerY.equalTo(iconCountLabel);
		}];

		*height += 20;
	}

	if (_reward.experience_value.length > 0) {
		//经验值行
		UIImageView *rewardImageView_exp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_exp"]];
		[_dimmingView addSubview:rewardImageView_exp];
		[rewardImageView_exp mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.width.equalTo(@18);
		    make.height.equalTo(@18);
		    make.top.equalTo(weakSelf.dimmingView.mas_top).offset(9 + *height);
		    make.left.equalTo(weakSelf.dimmingView.mas_left).offset(82.5f);
		}];

		UILabel *expCountLabel = [UILabel new];
		expCountLabel.textColor = COMMON_RED_COLOR;
		expCountLabel.text = @"5";
		expCountLabel.font = MOON_FONT_OF_SIZE(19);
		[expCountLabel sizeToFit];
		[_dimmingView addSubview:expCountLabel];
		[expCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.left.equalTo(rewardImageView_exp.mas_right).offset(6);
		    make.centerY.equalTo(rewardImageView_exp);
		}];

		UIImageView *rewardImageView_txt_exp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_exptext"]];
		[_dimmingView addSubview:rewardImageView_txt_exp];
		[rewardImageView_txt_exp mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.width.equalTo(@56);
		    make.height.equalTo(@20);
		    make.left.equalTo(expCountLabel.mas_right).offset(6);
		    make.centerY.equalTo(expCountLabel);
		}];

		*height += 20;
	}

	if (_reward.gemstone.length > 0) {
		//宝石行
		UIImageView *rewardImageView_diamond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_monds"]];
		[_dimmingView addSubview:rewardImageView_diamond];
		[rewardImageView_diamond mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.width.equalTo(@18);
		    make.height.equalTo(@18);
		    make.top.equalTo(weakSelf.dimmingView.mas_top).offset(9 + *height);
		    make.left.equalTo(weakSelf.dimmingView.mas_left).offset(82.5f);
		}];

		UILabel *diamondCountLabel = [UILabel new];
		diamondCountLabel.textColor = COMMON_RED_COLOR;
		diamondCountLabel.text = @"5";
		diamondCountLabel.font = MOON_FONT_OF_SIZE(19);
		[diamondCountLabel sizeToFit];
		[_dimmingView addSubview:diamondCountLabel];
		[diamondCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.left.equalTo(rewardImageView_diamond.mas_right).offset(6);
		    make.centerY.equalTo(rewardImageView_diamond);
		}];

		UIImageView *rewardImageView_txt_diamond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_mondstext"]];
		[_dimmingView addSubview:rewardImageView_txt_diamond];
		[rewardImageView_txt_diamond mas_makeConstraints:^(MASConstraintMaker *make) {
		    make.width.equalTo(@38);
		    make.height.equalTo(@19);
		    make.left.equalTo(diamondCountLabel.mas_right).offset(6);
		    make.centerY.equalTo(diamondCountLabel);
		}];
	}
}

#pragma mark - Action

- (void)removeDimmingView {
	[_dimmingView removeFromSuperview];
	_dimmingView = nil;
	if ([_delegate respondsToSelector:@selector(didClickBackButtonInScanningCaptureController:)]) {
		[_delegate didClickBackButtonInScanningCaptureController:self];
	} else {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

@end
