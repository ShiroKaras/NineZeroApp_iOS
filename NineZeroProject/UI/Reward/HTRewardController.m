//
//  HTRewardController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/26.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTRewardController.h"
#import "HTUIHeader.h"
#import <SDWebImage/UIImage+GIF.h>
#import <YLGIFImage/YLImageView.h>
#import <YLGIFImage/YLGIFImage.h>
#import "YYImage.h"
#import "YYAnimatedImageView.h"
#import "HTRewardCard.h"
#import <UIImage+animatedGIF.h>

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
@property (nonatomic, strong) UIImageView *andImageView2;
@property (nonatomic, strong) UIImageView *getImageView;

@property (nonatomic, strong) HTTicketCard *card;          // 奖品卡片
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) HTMascot *mascot;
@property (nonatomic, strong) HTMascotProp *prop;
@property (nonatomic, strong) HTTicket *ticket;;
@property (nonatomic, assign) NSUInteger goldNumber;
@property (nonatomic, assign) NSUInteger rankNumber;

@end

@implementation HTRewardController {
    uint64_t _rewardID;
    uint64_t _qid;
}

- (instancetype)initWithRewardID:(uint64_t)rewardID questionID:(uint64_t)qid {
    if (self = [super init]) {
        _rewardID = rewardID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.85];
    _scrollView.delaysContentTouches = NO;
    [self.view addSubview:_scrollView];
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureButton setTitle:@"完成" forState:UIControlStateNormal];
    _sureButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _sureButton.backgroundColor = COMMON_GREEN_COLOR;
    [_sureButton addTarget:self action:@selector(onClickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureButton];
    
    [HTProgressHUD show];
    [[[HTServiceManager sharedInstance] mascotService] getRewardWithID:_rewardID questionID:_qid completion:^(BOOL success, HTResponsePackage *rsp) {
        [HTProgressHUD dismiss];
        if (success && rsp.resultCode == 0) {
            [self createTopView];
            if (rsp.data[@"gold"]) {
                _goldNumber = [[NSString stringWithFormat:@"%@", rsp.data[@"gold"]] integerValue];
                _goldenLabel.text = [NSString stringWithFormat:@"%ld", (long)_goldNumber];
                [_goldenLabel sizeToFit];
            }
            if (rsp.data[@"rank"]) {
                _rankNumber = [[NSString stringWithFormat:@"%@", rsp.data[@"rank"]] integerValue];
                // TODO: 根据规则填入rankNumber
            }
            if (rsp.data[@"ticket"]) {
                HTTicket *ticket = [HTTicket objectWithKeyValues:rsp.data[@"ticket"]];
                _ticket = ticket;
                [self createTicketView];
            }
            if (rsp.data[@"pet"]) {
                HTMascot *mascot = [HTMascot objectWithKeyValues:rsp.data[@"pet"]];
                _mascot = mascot;
            }
            if (rsp.data[@"prop"]) {
                HTMascotProp *prop = [HTMascotProp objectWithKeyValues:rsp.data[@"prop"]];
                _prop = prop;
            }
            if (_prop || _mascot) {
                [self createGifView];
            }
            
            [self reloadView];
        } else {
            [self showTipsWithText:@"网络失败"];
        }
    }];
}

- (void)reloadView {
    [self viewWillLayoutSubviews];
}

- (void)onClickSureButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)createTopView {
    _prefixOverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_1"]];
    [_scrollView addSubview:_prefixOverImageView];
    _suffixOverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_2"]];
    [_scrollView addSubview:_suffixOverImageView];
    _prefixGetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_3"]];
    [_scrollView addSubview:_prefixGetImageView];
    _suffixGetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_4"]];
    [_scrollView addSubview:_suffixGetImageView];
    
    _percentLabel = [[UILabel alloc] init];
    _percentLabel.font = MOON_FONT_OF_SIZE(32.5);
    _percentLabel.textColor = COMMON_GREEN_COLOR;
//    _percentLabel.text = @"98%";
    [_scrollView addSubview:_percentLabel];
    [_percentLabel sizeToFit];
    
    _goldenLabel = [[UILabel alloc] init];
    _goldenLabel.font = MOON_FONT_OF_SIZE(23);
    _goldenLabel.textColor = [UIColor colorWithHex:0xed203b];
//    _goldenLabel.text = @"20";
    [_scrollView addSubview:_goldenLabel];
    [_goldenLabel sizeToFit];
}

- (void)createTicketView {
    // and
    _andImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mascot_7_page_title-1"]];
    [_scrollView addSubview:_andImageView2];
    
    // 奖品
    _card = [[HTTicketCard alloc] init];
    [_card setReward:_ticket];
    [_scrollView addSubview:_card];
}

- (void)createGifView {
    _andImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mascot_7_page_title-1"]];
    [_scrollView addSubview:_andImageView];
    _getImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_5"]];
    [_scrollView addSubview:_getImageView];
    // gif
    _imageView = [[UIImageView alloc] init];
    [_scrollView addSubview:_imageView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // TODO: 从mascot或者prop中找到gif字段并展示
        UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:@"http://ww2.sinaimg.cn/large/7cefdfa5jw1dskejdmiaog.gif"]];
        _imageView.image = gifImage;
        [_imageView startAnimating];
    });
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat maxOffsetY = 0;
    
    // "恭喜你超越xxx"
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
    _prefixOverImageView.left = ROUND_WIDTH_FLOAT(56);
    _prefixOverImageView.top = ROUND_HEIGHT_FLOAT(62);
    _suffixOverImageView.top = _prefixOverImageView.bottom + 10;
    _percentLabel.left = _prefixOverImageView.right + 5;
    _percentLabel.bottom = _prefixOverImageView.bottom + 5;
    _suffixOverImageView.left = _percentLabel.left;
    
    // "你获得了 x 金币"
    _prefixGetImageView.left = ROUND_WIDTH_FLOAT(54);
    _prefixGetImageView.top = _prefixOverImageView.bottom + 60;
    _goldenLabel.left = _prefixGetImageView.right + 3;
    _goldenLabel.bottom = _prefixGetImageView.bottom + 3;
    _suffixGetImageView.left = _goldenLabel.right + 5;
    _suffixGetImageView.bottom = _goldenLabel.bottom - 5;
    
    maxOffsetY = _suffixGetImageView.bottom;
    
    // "& 捕获到"
    if (_mascot || _prop) {
        _andImageView.top = maxOffsetY + ROUND_HEIGHT_FLOAT(29);
        _andImageView.centerX = SCREEN_WIDTH / 2;
        _getImageView.left = _andImageView.right + 16;
        _getImageView.centerY = _andImageView.centerY;
        // gif
        _imageView.width = self.view.width;
        _imageView.height = 150;
        _imageView.top = _andImageView.bottom + 27;
        maxOffsetY = _imageView.bottom;
    }

    // 礼券
    if (_ticket) {
        _andImageView2.top = maxOffsetY + 27;
        _andImageView2.centerX = SCREEN_WIDTH / 2;
        
        _card.centerX = SCREEN_WIDTH / 2;
        _card.top = _andImageView2.bottom + 29;
        maxOffsetY = _card.bottom;
    }

    _sureButton.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(SCREEN_HEIGHT - 50, maxOffsetY + 100));
}

@end
