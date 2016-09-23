//
//  HTMascotDisplayController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/17.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTMascotDisplayController.h"
#import "HTUIHeader.h"
#import "HTMascotView.h"
#import "HTMascotPropView.h"
#import "HTMascotPropMoreView.h"
#import "HTDescriptionView.h"
#import "HTMascotTipView.h"
#import "HTMascotItem.h"
#import "HTMascotIntroController.h"
#import "SKHelperView.h"

static CGFloat kDuration = 0.3;
static NSString *selectedMascotKey = @"selectedMascotKey";

@interface HTMascotDisplayController () <HTMascotPropViewDelegate, HTMascotPropMoreViewDelegate, HTMascotViewDelegate, SKHelperScrollViewDelegate>

@property (nonatomic, strong) HTMascotView *mascotView;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) HTMascotTipView *mascotTipView;
@property (nonatomic, strong) HTMascotPropView *propView;
@property (nonatomic, strong) HTMascotPropMoreView *moreView;
@property (nonatomic, strong) NSMutableArray<HTMascotProp *> *props;
@property (nonatomic, strong) UIButton *helpButton;
@end

@implementation HTMascotDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [HTProgressHUD show];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.mascots = [NSMutableArray arrayWithObject:[HTMascotHelper defaultMascots]];
    self.props = [NSMutableArray array];
    
    self.mascotTipView = [[HTMascotTipView alloc] initWithIndex:0];
    [self.mascotTipView addTarget:self action:@selector(didClickTipNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mascotTipView];
    [self.mascotTipView sizeToFit];
    
    self.propView = [[HTMascotPropView alloc] initWithProps:self.props];
    self.propView.delegate = self;
    [self.view addSubview:self.propView];
    
    self.tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mascot_1_default_msg_bg"]];
    [self.view addSubview:self.tipImageView];
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = [UIColor colorWithHex:0xd9d9d9];
    self.tipLabel.text = @"快帮我寻找更多的零仔吧!";
    [self.tipImageView addSubview:self.tipLabel];
    
    self.mascotView = [[HTMascotView alloc] initWithMascots:self.mascots];
    self.mascotView.delegate = self;
    [self.view addSubview:self.mascotView];
    [self.view sendSubviewToBack:self.mascotView];
    
    __weak __typeof(self)weakSelf = self;
    _helpButton = [UIButton new];
    [_helpButton setImage:[UIImage imageNamed:@"btn_help"] forState:UIControlStateNormal];
    [_helpButton setImage:[UIImage imageNamed:@"btn_help_highlight"] forState:UIControlStateHighlighted];
    [_helpButton addTarget:self action:@selector(helpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_helpButton];
    
    [_helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(weakSelf.view).offset(10);
        make.left.equalTo(weakSelf.view).offset(10);
    }];
    
    UIButton *cancelButton = [UIButton new];
    [cancelButton setImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-26);
    }];
    
    [UD setInteger:1 forKey:selectedMascotKey];
    
    [self buildConstraints];
    [self reloadAllData];
    [self reloadViews];
    
    if (FIRST_LAUNCH_MASCOTVIEW) {
        [self helpButtonClick:nil];
        [UD setBool:YES forKey:@"firstLaunchMascotView"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[MobClick beginLogPageView:@"mascotpage"];
    [TalkingData trackPageBegin:@"lingzaipage"];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self reloadAllData];
    [self reloadViews];
    
//    [self loadUnreadArticleFlag];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[MobClick endLogPageView:@"mascotpage"];
    [TalkingData trackPageEnd:@"lingzaipage"];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)loadUnreadArticleFlag {
    [[[HTServiceManager sharedInstance] profileService] getArticlesInPastWithPage:0 count:0 callback:^(BOOL success, NSArray<HTArticle *> *articles) {
        NSLog(@"hasread: %ld",(long)[UD integerForKey:@"hasreadArticlesCount"]);
        [UD setInteger:articles.count forKey:@"hasreadArticlesCount"];
//        [AppDelegateInstance.mainController showFlag:articles.count - [UD integerForKey:@"hasreadArticlesCount"]];
    }];
}

- (void)reloadAllData {
//    self.mascots = [[[[HTServiceManager sharedInstance] mascotService] mascotsArray] mutableCopy];
//    [_mascotView setMascots:self.mascots];
//    [self reloadViews];
//    [self reloadDisplayMascotsWithIndex:[UD integerForKey:selectedMascotKey]];
    
    [[[HTServiceManager sharedInstance] mascotService] getUserMascots:^(BOOL success, NSArray<HTMascot *> *mascots) {
        [MBProgressHUD hideHUDForView:KEYWINDS_ROOT_CONTROLLER.view animated:YES];
        if (success) {
            // AT LEAST ONE MASCOT
//            if (mascots.count != 0) {
                self.mascots = [mascots mutableCopy];
                [_mascotView setMascots:self.mascots];
//            }
            [self reloadViews];
            [self reloadDisplayMascotsWithIndex:[UD integerForKey:selectedMascotKey]];
            [HTProgressHUD dismiss];
        } else {
            [self showTipsWithText:@"网络不给力哦，请稍后重试"];
            [HTProgressHUD dismiss];
        }
    }];
    
    [[[HTServiceManager sharedInstance] mascotService] getUserProps:^(BOOL success, NSArray<HTMascotProp *> *props) {
        if (success) {
            self.props = [props mutableCopy];
            [self.propView setProps:props];
            if (props.count == 0) [self.propView removeFromSuperview];
            else [self buildConstraints];
        }
    }];
}

- (void)buildConstraints {
    [self.propView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(ROUND_HEIGHT(180));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.mascotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mascotView.mas_left).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(self.view.mas_bottom).offset(ROUND_HEIGHT_FLOAT(-180)+49.5);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipImageView);
        make.centerY.equalTo(self.tipImageView).offset(4);
    }];
}

- (void)reloadDisplayMascotsWithIndex:(NSUInteger)index {
    [_mascotView reloadDisplayMascotsWithIndex:index];
}

- (void)reloadViews {
    if (self.mascots.count == 1) {
        self.tipImageView.hidden = NO;
        self.mascotTipView.hidden = YES;
    } else {
        self.mascotTipView.hidden = YES;
        self.tipImageView.hidden = YES;
        self.tipLabel.hidden = YES;
        self.mascotView.hidden = NO;
    }
}

#pragma mark - Action

- (void)didClickTipNumber {
    //[MobClick event:@"essay"];
    [TalkingData trackEvent:@"finger"];
    HTMascotIntroController *introController = [[HTMascotIntroController alloc] initWithMascot:self.mascots[0]];
//    [self presentViewController:introController animated:YES completion:nil];
    [self.navigationController pushViewController:introController animated:YES];
}

- (void)cancelButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)helpButtonClick:(UIButton *)sender {
    [TalkingData trackEvent:@"lingzaitips"];
    SKHelperScrollView *helpView = [[SKHelperScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withType:SKHelperScrollViewTypeMascot];
    helpView.delegate = self;
    helpView.scrollView.frame = CGRectMake(0, -(SCREEN_HEIGHT-356)/2, 0, 0);
    helpView.dimmingView.alpha = 0;
    [self.view addSubview:helpView];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        helpView.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        helpView.dimmingView.alpha = 0.9;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - HTMascotView Delegate

- (void)mascotView:(HTMascotView *)mascotView didClickMascotItem:(HTMascotItem *)mascotItem {

}

- (void)mascotView:(HTMascotView *)mascotView didClickMascotTipView:(HTMascotTipView *)mascotTipView {
    for (HTMascot *mascot in self.mascots) {
        NSLog(@"mas_index:%ld", (unsigned long)mascot.mascotID);
        if (mascot.mascotID-1 == mascotTipView.index) {
            HTMascotIntroController *introController = [[HTMascotIntroController alloc] initWithMascot:mascot];
            [UD setInteger:mascot.mascotID forKey:selectedMascotKey];
//            [self presentViewController:introController animated:YES completion:nil];
            [self.navigationController pushViewController:introController animated:YES];
        }
    }
}

#pragma mark - HTMascotPropView Delegate

- (void)didClickBottomArrowInMascotPropView:(HTMascotPropView *)mascotPropView {
    _moreView = [[HTMascotPropMoreView alloc] initWithProps:self.props andPageCount:0];
    [self.view addSubview:_moreView];
    _moreView.top = SCREEN_HEIGHT;
    _moreView.delegate = self;
    [UIView animateWithDuration:kDuration animations:^{
        _moreView.top = 0;
    }];
}

#pragma mark - HTMascotPropMoreView Delegate

- (void)didClickTopArrowInPropMoreView:(HTMascotPropMoreView *)propMoreView {
    if (propMoreView.pageCount == 0) {
        [UIView animateWithDuration:kDuration animations:^{
            propMoreView.top = SCREEN_HEIGHT;
            propMoreView.alpha = 0;
        } completion:^(BOOL finished) {
            [propMoreView removeFromSuperview];
        }];
    } else {
        _moreView = [[HTMascotPropMoreView alloc] initWithProps:self.props andPageCount:propMoreView.pageCount - 1];
        [self.view addSubview:_moreView];
        _moreView.bottom = 0;
        _moreView.delegate = self;
        _moreView.decorateView.hidden = YES;
        propMoreView.decorateView.hidden = YES;
        [UIView animateWithDuration:kDuration animations:^{
            _moreView.top = 0;
            propMoreView.top = SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            [propMoreView removeFromSuperview];
            _moreView.decorateView.hidden = NO;
        }];
    }
}

- (void)didClickBottomArrowInPropMoreView:(HTMascotPropMoreView *)propMoreView {
    _moreView = [[HTMascotPropMoreView alloc] initWithProps:self.props andPageCount:propMoreView.pageCount + 1];
    [self.view addSubview:_moreView];
    _moreView.top = SCREEN_HEIGHT;
    _moreView.delegate = self;
    _moreView.decorateView.hidden = YES;
    propMoreView.decorateView.hidden = YES;
    [UIView animateWithDuration:kDuration animations:^{
        _moreView.top = 0;
        propMoreView.bottom = 0;
    } completion:^(BOOL finished) {
        [propMoreView removeFromSuperview];
        _moreView.decorateView.hidden = NO;
    }];
}

#pragma mark - SKHelperScrollViewDelegate

- (void)didClickCompleteButton {
    [_helpButton setImage:[UIImage imageNamed:@"btn_help_highlight"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.075 animations:^{
        _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.075 animations:^{
            _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.075 animations:^{
                _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.075 animations:^{
                    _helpButton.transform = CGAffineTransformScale(_helpButton.transform, 0.9, 0.9);
                } completion:^(BOOL finished) {
                    [_helpButton setImage:[UIImage imageNamed:@"btn_help"] forState:UIControlStateNormal];
                }];
            }];
        }];
    }];
}

@end
