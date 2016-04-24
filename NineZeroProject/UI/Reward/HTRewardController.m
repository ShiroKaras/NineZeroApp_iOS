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
@property (nonatomic, strong) YYAnimatedImageView *gifImageView;   //gif
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) HTMascot *mascot;
@property (nonatomic, strong) HTMascotProp *prop;
@property (nonatomic, strong) HTTicket *ticket;;
@property (nonatomic, assign) NSUInteger goldNumber;

@end

@implementation HTRewardController {
    uint64_t _rewardID;
}

- (instancetype)initWithRewardID:(uint64_t)rewardID {
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
    
    _prefixOverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_1"]];
    [_scrollView addSubview:_prefixOverImageView];
    _suffixOverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_2"]];
    [_scrollView addSubview:_suffixOverImageView];
    _prefixGetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_3"]];
    [_scrollView addSubview:_prefixGetImageView];
    _suffixGetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_4"]];
    [_scrollView addSubview:_suffixGetImageView];
    _andImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_and"]];
    [_scrollView addSubview:_andImageView];
    _getImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_5"]];
    [_scrollView addSubview:_getImageView];
    
    _percentLabel = [[UILabel alloc] init];
    _percentLabel.font = MOON_FONT_OF_SIZE(32.5);
    _percentLabel.textColor = COMMON_GREEN_COLOR;
    _percentLabel.text = @"98%";
    [_scrollView addSubview:_percentLabel];
    [_percentLabel sizeToFit];
    
    _goldenLabel = [[UILabel alloc] init];
    _goldenLabel.font = MOON_FONT_OF_SIZE(23);
    _goldenLabel.textColor = [UIColor colorWithHex:0xed203b];
    _goldenLabel.text = @"20";
    [_scrollView addSubview:_goldenLabel];
    [_goldenLabel sizeToFit];
    
    // and
    _andImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mascot_7_page_title-1"]];
    [_scrollView addSubview:_andImageView];
    _andImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mascot_7_page_title-1"]];
    [_scrollView addSubview:_andImageView2];
    
    // gif
    _gifImageView = [[YYAnimatedImageView alloc] init];
    YYImage *image = [YYImage imageNamed:@"reward_mascot3_intro_gif.gif"];
    image.preloadAllAnimatedImageFrames = YES;
    _gifImageView.image = image;
    [_scrollView addSubview:_gifImageView];
    
    _imageView = [[UIImageView alloc] init];
    [_scrollView addSubview:_imageView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:@"http://ww2.sinaimg.cn/large/7cefdfa5jw1dskejdmiaog.gif"]];
        _imageView.image = gifImage;
        [_imageView startAnimating];
    });
    
    // 奖品
    _card = [[HTTicketCard alloc] init];
    [_scrollView addSubview:_card];
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureButton setTitle:@"完成" forState:UIControlStateNormal];
    _sureButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _sureButton.backgroundColor = COMMON_GREEN_COLOR;
    [_sureButton addTarget:self action:@selector(onClickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureButton];
    
    [[[HTServiceManager sharedInstance] mascotService] getRewardWithID:_rewardID completion:^(BOOL success, HTResponsePackage *rsp) {
        
    }];
}

- (void)onClickSureButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
    _prefixOverImageView.left = ROUND_WIDTH_FLOAT(56);
    _prefixOverImageView.top = ROUND_HEIGHT_FLOAT(62);
    _suffixOverImageView.top = _prefixOverImageView.bottom + 10;
    _percentLabel.left = _prefixOverImageView.right + 5;
    _percentLabel.bottom = _prefixOverImageView.bottom + 5;
    _suffixOverImageView.left = _percentLabel.left;
    
    _prefixGetImageView.left = ROUND_WIDTH_FLOAT(54);
    _prefixGetImageView.top = _prefixOverImageView.bottom + 60;
    _goldenLabel.left = _prefixGetImageView.right + 3;
    _goldenLabel.bottom = _prefixGetImageView.bottom + 3;
    _suffixGetImageView.left = _goldenLabel.right + 5;
    _suffixGetImageView.bottom = _goldenLabel.bottom - 5;
    
    _andImageView.top = _suffixGetImageView.bottom + ROUND_HEIGHT_FLOAT(29);
    _andImageView.centerX = SCREEN_WIDTH / 2;
    _getImageView.left = _andImageView.right + 16;
    _getImageView.centerY = _andImageView.centerY;

    _andImageView2.top = _gifImageView.bottom + 27;
    _andImageView2.centerX = SCREEN_WIDTH / 2;

    _gifImageView.width = self.view.width;
    _gifImageView.height = 150;
    _gifImageView.top = _andImageView.bottom + 27;
    
    _imageView.frame = _gifImageView.frame;
    _gifImageView.hidden = YES;
    
    _card.centerX = SCREEN_WIDTH / 2;
    _card.top = _andImageView2.bottom + 29;

    _sureButton.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    
    // TODO
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(SCREEN_HEIGHT - 50, _card.bottom + 100));
}

@end
