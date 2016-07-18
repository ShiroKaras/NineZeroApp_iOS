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

static CGFloat kDuration = 0.3;
static NSString *selectedMascotKey = @"selectedMascotKey";

@interface HTMascotDisplayController () <HTMascotPropViewDelegate, HTMascotPropMoreViewDelegate, HTMascotViewDelegate>

@property (nonatomic, strong) HTMascotItem *onlyOneMascotImageView;
@property (nonatomic, strong) HTMascotView *mascotView;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) HTMascotTipView *mascotTipView;
@property (nonatomic, strong) HTMascotPropView *propView;
@property (nonatomic, strong) HTMascotPropMoreView *moreView;
@property (nonatomic, strong) NSMutableArray<HTMascot *> *mascots;
@property (nonatomic, strong) NSMutableArray<HTMascotProp *> *props;
@end

@implementation HTMascotDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;
    self.mascots = [NSMutableArray arrayWithObject:[HTMascotHelper defaultMascots]];
    self.props = [NSMutableArray array];

    self.onlyOneMascotImageView = [[HTMascotItem alloc] init];
    self.onlyOneMascotImageView.index = 0;
    self.onlyOneMascotImageView.mascot = self.mascots[0];
    [self.onlyOneMascotImageView playAnimatedNumber:2];
    [self.view addSubview:self.onlyOneMascotImageView];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapOnDefaultMascot)];
    doubleTap.numberOfTapsRequired = 2;
    [self.onlyOneMascotImageView addGestureRecognizer:doubleTap];
    
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
    
    [UD setInteger:1 forKey:selectedMascotKey];
    
    [self buildConstraints];
    [self reloadAllData];
    [self reloadViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"mascotpage"];
    [self reloadAllData];
    [self reloadViews];
    
    [self loadUnreadArticleFlag];
}

- (void)viewWillDisappear:(BOOL)animated {
    [MobClick endLogPageView:@"mascotpage"];
}

- (void)loadUnreadArticleFlag {
    [[[HTServiceManager sharedInstance] profileService] getArticlesInPastWithPage:0 count:0 callback:^(BOOL success, NSArray<HTArticle *> *articles) {
        NSLog(@"hasread: %ld",(long)[UD integerForKey:@"hasreadArticlesCount"]);
        [AppDelegateInstance.mainController removeUnreadArticleFlag];
        [UD setInteger:articles.count forKey:@"hasreadArticlesCount"];
    }];
}

- (void)reloadAllData {
    [[[HTServiceManager sharedInstance] mascotService] getUserMascots:^(BOOL success, NSArray<HTMascot *> *mascots) {
        [MBProgressHUD hideHUDForView:KEYWINDS_ROOT_CONTROLLER.view animated:YES];
        if (success) {
            // AT LEAST ONE MASCOT
            if (mascots.count != 0) {
                self.mascots = [mascots mutableCopy];
                [_mascotView setMascots:self.mascots];
            }
            [self reloadViews];
            [self reloadDisplayMascotsWithIndex:[UD integerForKey:selectedMascotKey]];
        } else {
            [self showTipsWithText:@"网络不给力哦，请稍后重试"];
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
    [self.onlyOneMascotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(ROUND_HEIGHT(175));
        make.width.equalTo(@157);
        make.height.equalTo(@157);
    }];
    
    [self.mascotTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.onlyOneMascotImageView.mas_top).offset(24);
        make.centerX.equalTo(self.onlyOneMascotImageView);
    }];
    
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
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.onlyOneMascotImageView.mas_bottom).equalTo(@11);
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
        self.onlyOneMascotImageView.hidden = NO;
        self.mascotTipView.hidden = NO;
        self.tipImageView.hidden = NO;
        self.tipLabel.hidden = NO;
        self.mascotView.hidden = YES;
        self.onlyOneMascotImageView.mascot = self.mascots[0];
        self.mascotTipView.tipNumber = self.mascots[0].unread_articles;
    } else {
        self.onlyOneMascotImageView.hidden = YES;
        self.mascotTipView.hidden = YES;
        self.tipImageView.hidden = YES;
        self.tipLabel.hidden = YES;
        self.mascotView.hidden = NO;
    }
}

#pragma mark - Action

- (void)didClickTipNumber {
    [MobClick event:@"essay"];
    HTMascotIntroController *introController = [[HTMascotIntroController alloc] initWithMascot:self.mascots[0]];
    [self presentViewController:introController animated:YES completion:nil];
}

- (void)doubleTapOnDefaultMascot {
    [self.onlyOneMascotImageView playAnimatedNumber:arc4random() % 2 + 3];
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
            [self presentViewController:introController animated:YES completion:nil];
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

@end
