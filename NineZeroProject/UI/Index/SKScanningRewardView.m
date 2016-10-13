//
//  SKScanningRewardViewController.m
//  NineZeroProject
//
//  Created by SinLemon on 16/10/13.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKScanningRewardView.h"
#import "HTRewardCard.h"
#import "HTUIHeader.h"
#import "OpenGLView.h"

@interface SKScanningRewardView ()

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) HTLoginButton *sureButton;
@property (nonatomic, strong) HTBlankView   *blankView;
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) HTTicketCard *card;          // 奖品卡片
@property (nonatomic, strong) HTTicket *ticket;

@property (nonatomic, assign) NSString *rewardID;
@end

@implementation SKScanningRewardView {
    float maxOffsetY;
}

- (instancetype)initWithFrame:(CGRect)frame ticket:(HTTicket*)ticket {
    self = [super initWithFrame:frame];
    if (self) {
        _ticket = ticket;
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame rewardID:(NSString*)rewardID {
    self = [super initWithFrame:frame];
    if (self) {
        _rewardID = rewardID;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
    _scrollView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.9];
    _scrollView.delaysContentTouches = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _sureButton = [HTLoginButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
    [_sureButton setTitle:@"完成" forState:UIControlStateNormal];
    _sureButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _sureButton.enabled = YES;
    [_sureButton addTarget:self action:@selector(onClickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sureButton];
    
    _topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sacnning_reward"]];
    [_topImage sizeToFit];
    [self addSubview:_topImage];
    
    _topImage.top = ROUND_HEIGHT_FLOAT(68);
    _topImage.centerX = self.centerX;
    
    [self createTicketView];
    if (_ticket) {
        _card.top = _topImage.bottom +25;
        _card.centerX = SCREEN_WIDTH / 2;
        maxOffsetY = _card.bottom;
    }
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, MAX(SCREEN_HEIGHT - 50, maxOffsetY + 100));
    /*
    [HTProgressHUD show];
    [[[HTServiceManager sharedInstance] questionService] getScanningRewardWithRewardId:_rewardID :^(BOOL success, HTResponsePackage *response) {
        [HTProgressHUD dismiss];
        if (success && response.resultCode == 0) {
            
            [[self activityViewController].navigationController popViewControllerAnimated:YES];
        } else if (success && response.resultCode == 501){
            [[self activityViewController].navigationController popViewControllerAnimated:YES];
        } else {
            [[self activityViewController].navigationController popViewControllerAnimated:YES];
        }
    }];
    */
    if (NO_NETWORK) {
        self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [self.blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
        [self addSubview:self.blankView];
        self.blankView.top = ROUND_HEIGHT_FLOAT(217);
    }
}

- (void)createTicketView {
    _card = [[HTTicketCard alloc] init];
    [_card setReward:_ticket];
    [_scrollView addSubview:_card];
}

- (UIViewController *)activityViewController {
    UIViewController* activityViewController = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if(tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0) {
        UIView *frontView = [viewsArray objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]) {
            activityViewController = nextResponder;
        } else {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

- (UIViewController *)viewController {
    for (UIView *view in KEY_WINDOW.subviews) {
        if ([view isKindOfClass:[OpenGLView class]]) {
            for (UIView* next = [view superview]; next; next = next.superview) {
                UIResponder *nextResponder = [next nextResponder];
                if ([nextResponder isKindOfClass:[UIViewController class]]) {
                    return (UIViewController *)nextResponder;
                }
            }
        }
    }
    return nil;
}

- (void)onClickSureButton {
    [self removeFromSuperview];
}

- (void)showTipsWithText:(NSString *)text {
    if (text.length == 0) text = @"操作失败";
    UIView *tipsBackView = [[UIView alloc] init];
    tipsBackView.backgroundColor = COMMON_PINK_COLOR;
    [KEY_WINDOW addSubview:tipsBackView];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = [UIFont systemFontOfSize:16];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor whiteColor];
    [tipsBackView addSubview:tipsLabel];
    
    [tipsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(KEY_WINDOW).offset(0);
        make.width.equalTo(KEY_WINDOW);
        make.height.equalTo(@30);
    }];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tipsBackView);
    }];
    
    tipsLabel.text = text;
    CGFloat tipsBottom = tipsBackView.bottom;
    tipsBackView.bottom = 0;
    [UIView animateWithDuration:0.3 animations:^{
        tipsBackView.hidden = NO;
        tipsBackView.bottom = tipsBottom;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                tipsBackView.bottom = 0;
            } completion:^(BOOL finished) {
                tipsBackView.bottom = tipsBottom;
                tipsBackView.hidden = YES;
            }];
        });
    }];
}
@end
