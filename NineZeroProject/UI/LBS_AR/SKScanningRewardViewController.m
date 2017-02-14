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
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HTLoginButton *sureButton;
@property (nonatomic, strong) UIView *topBackView; //布局用View
@property (nonatomic, strong) HTBlankView *blankView;

@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) SKReward *reward;
@end

@implementation SKScanningRewardViewController{
    NSString *_rewardID;
}

- (instancetype)initWithRewardID:(NSString *)rewardID {
    if (self = [super init]) {
        _rewardID = rewardID;
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
    } else {
        [HTProgressHUD show];
        [[[SKServiceManager sharedInstance] scanningService] getScanningRewardWithRewardID:_rewardID
                                                                                  callback:^(BOOL success, SKResponsePackage *response) {
                                                                                      DLog(@"Reward:%@", response.data);
                                                                                      if (response.result == 0) {
                                                                                          [HTProgressHUD dismiss];
                                                                                          _reward = [SKReward mj_objectWithKeyValues:response.data];
                                                                                          if (_reward.ticket.ticket_id != nil) {
                                                                                              [self createBaseRewardViewWithReward:_reward];
                                                                                          }
                                                                                      }
                                                                                  }];
    }
}

- (void)reloadView {
    [self viewWillLayoutSubviews];
}

- (void)onClickSureButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _sureButton.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
}

#pragma mark - Reward

- (void)createBaseRewardViewWithReward:(SKReward *)reward {
    float height = 192 + 30 + 108;
    
    _dimmingView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_dimmingView];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0;
    [_dimmingView addSubview:alphaView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         alphaView.alpha = 0.9;
                     }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDimmingView)];
    tap.numberOfTapsRequired = 1;
    [_dimmingView addGestureRecognizer:tap];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_scan_gift"]];
    [_dimmingView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@248);
        make.height.equalTo(@192);
        make.centerX.equalTo(_dimmingView);
        make.top.equalTo(_dimmingView).offset((SCREEN_HEIGHT - height) / 2);
    }];
    
    UILabel *bottomLabel = [UILabel new];
    bottomLabel.text = @"点击任意区域关闭";
    bottomLabel.textColor = [UIColor colorWithHex:0xa2a2a2];
    bottomLabel.font = PINGFANG_FONT_OF_SIZE(12);
    [bottomLabel sizeToFit];
    [_dimmingView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_dimmingView);
        make.bottom.equalTo(_dimmingView).offset(-16);
    }];
    
    //奖励 - 礼券
    
    SKTicketView *card = [[SKTicketView alloc] initWithFrame:CGRectMake(0, 0, 280, 108) reward:self.reward.ticket];
    [_dimmingView addSubview:card];
    if (SCREEN_WIDTH == IPHONE6_PLUS_SCREEN_WIDTH) {
        [card mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(362));
            make.height.equalTo(@(140));
            make.centerX.equalTo(_dimmingView);
            make.bottom.equalTo(_dimmingView.mas_bottom).offset(-(SCREEN_HEIGHT - height - 32) / 2);
        }];
    } else if (SCREEN_WIDTH == IPHONE6_SCREEN_WIDTH) {
        [card mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@335);
            make.height.equalTo(@130);
            make.centerX.equalTo(_dimmingView);
            make.bottom.equalTo(_dimmingView.mas_bottom).offset(-(SCREEN_HEIGHT - height - 22) / 2);
        }];
    } else if (SCREEN_WIDTH == IPHONE5_SCREEN_WIDTH) {
        [card mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@280);
            make.height.equalTo(@108);
            make.centerX.equalTo(_dimmingView);
            make.bottom.equalTo(_dimmingView.mas_bottom).offset(-(SCREEN_HEIGHT - height) / 2);
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
