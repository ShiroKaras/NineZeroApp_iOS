//
//  HTMascotIntroController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTMascotIntroController.h"
#import "HTUIHeader.h"
#import "HTMascotIntroCell.h"
#import "HTMascotArticleCell.h"
#import "HTArticleController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

typedef NS_ENUM(NSInteger, HTButtonType) {
    HTButtonTypeShare = 0,
    HTButtonTypeCancel,
    HTButtonTypeWechat,
    HTButtonTypeMoment,
    HTButtonTypeWeibo,
    HTButtonTypeQQ,
};
@interface HTMascotIntroController () <UITableViewDelegate, UITableViewDataSource, HTArticleControllerDelegate> {
    CGFloat mascotRowHeight;
}

@property (nonatomic, strong) HTMascot *mascot;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *momentButton;
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *weiboButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *statusBarCoverView;        // 状态栏背后的颜色条
@property (nonatomic, strong) HTBlankView *blankView;
@property (nonatomic, strong) UIView *blankCoverView;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, strong) UIView *promptView;
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation HTMascotIntroController

- (instancetype)initWithMascot:(HTMascot *)mascot {
    if (self = [super init]) {
        _mascot = mascot;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"btn_fullscreen_back"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"btn_fullscreen_back_highlight"] forState:UIControlStateHighlighted];
    [self.backButton addTarget:self action:@selector(onClickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton sizeToFit];
    [self.view addSubview:self.backButton];

    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setImage:[UIImage imageNamed:@"btn_fullscreen_share"] forState:UIControlStateNormal];
    [self.shareButton setImage:[UIImage imageNamed:@"btn_fullscreen_share_highlight"] forState:UIControlStateHighlighted];
    [self.shareButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton sizeToFit];
    self.shareButton.tag = HTButtonTypeShare;
    [self.view addSubview:self.shareButton];
    //隐藏分享
    self.shareButton.alpha = 0;
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setImage:[UIImage imageNamed:@"btn_fullscreen_close"] forState:UIControlStateNormal];
    [self.cancelButton setImage:[UIImage imageNamed:@"btn_fullscreen_close_highlight"] forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton sizeToFit];
    self.cancelButton.alpha = 0;
    self.cancelButton.tag = HTButtonTypeCancel;
    [self.view addSubview:self.cancelButton];
    
    self.wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.wechatButton setImage:[UIImage imageNamed:@"btn_fullscreen_wechat"] forState:UIControlStateNormal];
    [self.wechatButton setImage:[UIImage imageNamed:@"btn_fullscreen_wechat_highlight"] forState:UIControlStateHighlighted];
    [self.wechatButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.wechatButton sizeToFit];
    self.wechatButton.alpha = 0;
    self.wechatButton.tag = HTButtonTypeWechat;
    [self.view addSubview:self.wechatButton];
    
    self.momentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.momentButton setImage:[UIImage imageNamed:@"btn_fullscreen_moments"] forState:UIControlStateNormal];
    [self.momentButton setImage:[UIImage imageNamed:@"btn_fullscreen_moments_highlight"] forState:UIControlStateHighlighted];
    [self.momentButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.momentButton sizeToFit];
    self.momentButton.alpha = 0;
    self.momentButton.tag = HTButtonTypeMoment;
    [self.view addSubview:self.momentButton];
    
    self.weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.weiboButton setImage:[UIImage imageNamed:@"btn_fullscreen_weibo"] forState:UIControlStateNormal];
    [self.weiboButton setImage:[UIImage imageNamed:@"btn_fullscreen_weibo_highlight"] forState:UIControlStateHighlighted];
    [self.weiboButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.weiboButton sizeToFit];
    self.weiboButton.alpha = 0;
    self.weiboButton.tag = HTButtonTypeWeibo;
    [self.view addSubview:self.weiboButton];
    
    self.qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.qqButton setImage:[UIImage imageNamed:@"btn_fullscreen_qq"] forState:UIControlStateNormal];
    [self.qqButton setImage:[UIImage imageNamed:@"btn_fullscreen_qq_highlight"] forState:UIControlStateHighlighted];
    [self.qqButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.qqButton sizeToFit];
    self.qqButton.alpha = 0;
    self.qqButton.tag = HTButtonTypeQQ;
    [self.view addSubview:self.qqButton];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HTMascotIntroCell class] forCellReuseIdentifier:NSStringFromClass([HTMascotIntroCell class])];
    [self.tableView registerClass:[HTMascotArticleCell class] forCellReuseIdentifier:NSStringFromClass([HTMascotArticleCell class])];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.statusBarCoverView = [[UIView alloc] init];
    self.statusBarCoverView.backgroundColor = [HTMascotHelper colorWithMascotIndex:_mascot.mascotID];
    self.statusBarCoverView.alpha = 0;
//    [self.view addSubview:self.statusBarCoverView];
    
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_article_prompt"]];
    [promptImageView sizeToFit];
    
    _promptView = [UIView new];
    _promptView.size = promptImageView.size;
    _promptView.center = self.view.center;
    _promptView.alpha = 0;
    [self.view addSubview:_promptView];
    
    promptImageView.frame = CGRectMake(0, 0, _promptView.width, _promptView.height);
    [_promptView addSubview:promptImageView];
    
    _promptLabel = [UILabel new];
    _promptLabel.textColor = [UIColor colorWithHex:0xD9D9D9];
    _promptLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [_promptView addSubview:_promptLabel];
    _promptLabel.frame = CGRectMake(8.5, _promptView.height-12.5-13, _promptView.width-17, 57);
}

- (void)loadMoreData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
    [MobClick beginLogPageView:@"mascotintropage"];
    
    void (^netWorkErrorHandler)() = ^() {
        _mascot.article_list = nil;
        self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [self.blankView setImage:[UIImage imageNamed:@"img_error_light_grey_small"] andOffset:11];
        [self.view addSubview:self.blankView];
        [self.tableView reloadData];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1000)];
        footerView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = footerView;
        self.tableView.scrollEnabled = NO;
    };
    
    void (^noContentHandler)() = ^() {
        self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNoContent];
        [self.blankView setImage:[UIImage imageNamed:@"img_blank_grey_small"] andOffset:11];
        [self.view addSubview:self.blankView];
        [self.tableView reloadData];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1000)];
        footerView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = footerView;
        self.tableView.scrollEnabled = NO;
    };
    
    if ([[AFNetworkReachabilityManager sharedManager] isReachable] == NO) {
        netWorkErrorHandler();
    } else {
        [HTProgressHUD show];
        [[[HTServiceManager sharedInstance] mascotService] getUserMascotDetail:_mascot.mascotID completion:^(BOOL success, HTMascot *mascot) {
            [HTProgressHUD dismiss];
            if (success && mascot.article_list.count != 0) {
                _mascot.article_list = mascot.article_list;
                
                MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
                NSMutableArray<UIImage *> *refreshingImages = [NSMutableArray array];
                for (int i = 0; i != 3; i++) {
                    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"list_view_loader_grey_%d", (i + 1)]];
                    [refreshingImages addObject:image];
                }
                [footer setImages:refreshingImages duration:1.0 forState:MJRefreshStateRefreshing];
                footer.refreshingTitleHidden = YES;
                self.tableView.mj_footer = footer;
                footer.height = 0;
                
                [self.tableView reloadData];
            } else if (_mascot.article_list.count == 0) {
                noContentHandler();
            } else {
                netWorkErrorHandler();
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"mascotintropage"];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.backButton.origin = CGPointMake(10, 10);
    self.shareButton.top = self.backButton.top;
    self.shareButton.right = SCREEN_WIDTH - 11;
    self.cancelButton.origin = self.shareButton.origin;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.statusBarCoverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    [self.view sendSubviewToBack:self.tableView];
    
    self.blankView.top = 27 + _headerViewHeight;
    
    self.qqButton.top = self.shareButton.bottom + 7;
    self.qqButton.right = SCREEN_WIDTH - 11;
    self.weiboButton.centerY = self.qqButton.centerY;
    self.weiboButton.right = self.qqButton.left - 27;
    self.momentButton.centerY = self.qqButton.centerY;
    self.momentButton.right = self.weiboButton.left - 27;
    self.wechatButton.centerY = self.qqButton.centerY;
    self.wechatButton.right = self.momentButton.left - 27;
}

#pragma mark - Action

- (void)onClickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickButton:(UIButton *)sender {
//    [self share:sender];
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_mascot.article_list.count == 0) return 1;
    return 2 + _mascot.article_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HTMascotIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTMascotIntroCell class]) forIndexPath:indexPath];
        [cell setMascot:self.mascot];
        return cell;
    } else if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    } else {
        HTMascotArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTMascotArticleCell class]) forIndexPath:indexPath];
        [cell setArticle:self.mascot.article_list[self.mascot.article_list.count - (indexPath.row -2) -1]];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (mascotRowHeight == 0) mascotRowHeight = [HTMascotIntroCell calculateCellHeightWithMascot:self.mascot];
        _headerViewHeight = mascotRowHeight;
        return mascotRowHeight;
    } else if (indexPath.row == 1) {
        return 15;
    } else {
        return 110;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 2) {
        _promptView.alpha = 0;
        if (self.mascot.article_list[self.mascot.article_list.count - (indexPath.row -2) -1].is_locked) {
            _promptLabel.text = [NSString stringWithFormat:@"闯过第%@章后，解锁本篇研究报告", self.mascot.article_list[self.mascot.article_list.count - (indexPath.row -2) -1].qid];
            [_promptLabel sizeToFit];
            [UIView animateWithDuration:0.3 animations:^{
                _promptView.alpha =1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 delay:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    _promptView.alpha = 0;
                } completion:^(BOOL finished) {
                    
                }];
            }];
        } else {
            HTArticleController *articleController = [[HTArticleController alloc] initWithArticle:self.mascot.article_list[self.mascot.article_list.count - (indexPath.row -2) -1]];
            [self presentViewController:articleController animated:YES completion:nil];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _statusBarCoverView.alpha = MIN(scrollView.contentOffset.y / (mascotRowHeight - 20), 1);
//    _shareButton.alpha = 1 - _statusBarCoverView.alpha;
}

#pragma mark - HTArticleController Delegate

- (void)didClickLickButtonInArticleController:(HTArticleController *)controller {
    HTArticle *article = controller.article;
    __block NSMutableArray<HTArticle *> *articles;
    [self.mascot.article_list enumerateObjectsUsingBlock:^(HTArticle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.articleID == article.articleID) {
            [articles addObject:article];
        } else {
            [articles addObject:obj];
        }
    }];
    self.mascot.article_list = articles;
    [self.tableView reloadData];
}

#pragma mark - Share

- (void)setShareAppear:(BOOL)appear {
    _momentButton.alpha = appear;
    _weiboButton.alpha = appear;
    _qqButton.alpha = appear;
    _wechatButton.alpha = appear;
}

//- (void)share:(UIButton*)sender {
//    HTButtonType type = (HTButtonType)sender.tag;
//    switch (type) {
//        case HTButtonTypeShare: {
//            [UIView animateWithDuration:0.3 animations:^{
//                _shareButton.alpha = 0;
//                _cancelButton.alpha = 1.0;
//                [self setShareAppear:YES];
//            } completion:^(BOOL finished) {
//            }];
//            break;
//        }
//        case HTButtonTypeCancel: {
//            [UIView animateWithDuration:0.3 animations:^{
//                _cancelButton.alpha = 0;
//                _shareButton.alpha = 1.0;
//                [self setShareAppear:NO];
//            } completion:^(BOOL finished) {
//            }];
//            break;
//        }
//        case HTButtonTypeWechat: {
//            NSArray* imageArray = @[@""];
//            if (imageArray) {
//                
//                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//                [shareParams SSDKEnableUseClientShare];
//                [shareParams SSDKSetupShareParamsByText:@"分享内容test"
//                                                 images:imageArray
//                                                    url:[NSURL URLWithString:@"http://www.mob.com"]
//                                                  title:@"分享文章"
//                                                   type:SSDKContentTypeAuto];
//                [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//                    switch (state) {
//                        case SSDKResponseStateSuccess:
//                        {
//                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                message:nil
//                                                                               delegate:nil
//                                                                      cancelButtonTitle:@"确定"
//                                                                      otherButtonTitles:nil];
//                            [alertView show];
//                            break;
//                        }
//                        case SSDKResponseStateFail:
//                        {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                            message:[NSString stringWithFormat:@"%@",error]
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"OK"
//                                                                  otherButtonTitles:nil, nil];
//                            [alert show];
//                            break;
//                        }
//                        default:
//                            break;
//                    }
//                }];
//            }
//            break;
//        }
//        case HTButtonTypeMoment: {
//            NSArray* imageArray = @[@""];
//            if (imageArray) {
//                
//                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//                [shareParams SSDKEnableUseClientShare];
//                [shareParams SSDKSetupShareParamsByText:@"分享内容test"
//                                                 images:imageArray
//                                                    url:[NSURL URLWithString:@"http://www.mob.com"]
//                                                  title:@"分享文章"
//                                                   type:SSDKContentTypeAuto];
//                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//                    switch (state) {
//                        case SSDKResponseStateSuccess:
//                        {
//                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                message:nil
//                                                                               delegate:nil
//                                                                      cancelButtonTitle:@"确定"
//                                                                      otherButtonTitles:nil];
//                            [alertView show];
//                            break;
//                        }
//                        case SSDKResponseStateFail:
//                        {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                            message:[NSString stringWithFormat:@"%@",error]
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"OK"
//                                                                  otherButtonTitles:nil, nil];
//                            [alert show];
//                            break;
//                        }
//                        default:
//                            break;
//                    }
//                }];
//            }
//            break;
//        }
//        case HTButtonTypeWeibo: {
//            NSArray* imageArray = @[@""];
//            if (imageArray) {
//                
//                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//                [shareParams SSDKEnableUseClientShare];
//                [shareParams SSDKSetupShareParamsByText:@"分享内容test http://www.baidu.com"
//                                                 images:imageArray
//                                                    url:[NSURL URLWithString:@"http://www.mob.com"]
//                                                  title:@"分享文章"
//                                                   type:SSDKContentTypeImage];
//                [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//                    switch (state) {
//                        case SSDKResponseStateSuccess:
//                        {
//                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                message:nil
//                                                                               delegate:nil
//                                                                      cancelButtonTitle:@"确定"
//                                                                      otherButtonTitles:nil];
//                            [alertView show];
//                            break;
//                        }
//                        case SSDKResponseStateFail:
//                        {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                            message:[NSString stringWithFormat:@"%@",error]
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"OK"
//                                                                  otherButtonTitles:nil, nil];
//                            [alert show];
//                            break;
//                        }
//                        default:
//                            break;
//                    }
//                }];
//            }
//            break;
//        }
//        case HTButtonTypeQQ: {
//            NSArray* imageArray = @[@""];
//            if (imageArray) {
//                
//                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//                [shareParams SSDKEnableUseClientShare];
//                [shareParams SSDKSetupShareParamsByText:@"分享内容test"
//                                                 images:imageArray
//                                                    url:[NSURL URLWithString:@"http://www.mob.com"]
//                                                  title:@"分享文章"
//                                                   type:SSDKContentTypeAuto];
//                [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//                    switch (state) {
//                        case SSDKResponseStateSuccess:
//                        {
//                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                message:nil
//                                                                               delegate:nil
//                                                                      cancelButtonTitle:@"确定"
//                                                                      otherButtonTitles:nil];
//                            [alertView show];
//                            break;
//                        }
//                        case SSDKResponseStateFail:
//                        {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                            message:[NSString stringWithFormat:@"%@",error]
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"OK"
//                                                                  otherButtonTitles:nil, nil];
//                            [alert show];
//                            break;
//                        }
//                        default:
//                            break;
//                    }
//                }];
//            }
//            break;
//        }
//    }
//}

@end
