//
//  HTArticleController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTArticleController.h"
#import "HTUIHeader.h"
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

@interface HTArticleController () <UIWebViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    UIView *_backgroundImageView;
    UIVisualEffectView *_visualEfView;
    float lastOffsetY;
}
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *momentButton;
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *weiboButton;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) HTBlankView *blankView;
@end

@implementation HTArticleController

- (instancetype)initWithArticle:(HTArticle *)article {
    if (self = [super init]) {
        _article = article;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _backgroundImageView = [[UIView alloc] init];
    _backgroundImageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_backgroundImageView];
    
    if (IOS_VERSION >= 8.0) {
        _visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _visualEfView.alpha = 1.0;
        _visualEfView.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [_backgroundImageView addSubview:_visualEfView];
    }
    
    [HTProgressHUD show];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBackView)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.scrollView.delaysContentTouches = NO;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _webView.allowsInlineMediaPlayback = YES;
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    _webView.mediaPlaybackRequiresUserAction = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_article.articleURL]]];
    [self.view addSubview:_webView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"btn_fullscreen_back"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"btn_fullscreen_back_highlight"] forState:UIControlStateHighlighted];
    [self.backButton addTarget:self action:@selector(onClickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton sizeToFit];
    [self.view addSubview:self.backButton];

    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setImage:[UIImage imageNamed:@"btn_fullscreen_share"] forState:UIControlStateNormal];
    [self.shareButton setImage:[UIImage imageNamed:@"btn_fullscreen_share_highlight"] forState:UIControlStateHighlighted];
    [self.shareButton addTarget:self action:@selector(onClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton sizeToFit];
    self.shareButton.alpha = 1.0;
    self.shareButton.tag = HTButtonTypeShare;
    [self.view addSubview:self.shareButton];
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton addTarget:self action:@selector(onClickLikeButton) forControlEvents:UIControlEventTouchUpInside];
    [self refreshLickButton];
    [self.likeButton sizeToFit];
    [self.view addSubview:self.likeButton];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setImage:[UIImage imageNamed:@"btn_fullscreen_close"] forState:UIControlStateNormal];
    [self.cancelButton setImage:[UIImage imageNamed:@"btn_fullscreen_close_highlight"] forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self action:@selector(onClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton sizeToFit];
    self.cancelButton.alpha = 0;
    self.cancelButton.tag = HTButtonTypeCancel;
    [self.view addSubview:self.cancelButton];
    
    self.wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.wechatButton setImage:[UIImage imageNamed:@"btn_fullscreen_wechat"] forState:UIControlStateNormal];
    [self.wechatButton setImage:[UIImage imageNamed:@"btn_fullscreen_wechat_highlight"] forState:UIControlStateHighlighted];
    [self.wechatButton addTarget:self action:@selector(onClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.wechatButton sizeToFit];
    self.wechatButton.tag = HTButtonTypeWechat;
    self.wechatButton.alpha = 0;
    [self.view addSubview:self.wechatButton];
    
    self.momentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.momentButton setImage:[UIImage imageNamed:@"btn_fullscreen_moments"] forState:UIControlStateNormal];
    [self.momentButton setImage:[UIImage imageNamed:@"btn_fullscreen_moments_highlight"] forState:UIControlStateHighlighted];
    [self.momentButton addTarget:self action:@selector(onClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.momentButton sizeToFit];
    self.momentButton.tag = HTButtonTypeMoment;
    self.momentButton.alpha = 0;
    [self.view addSubview:self.momentButton];
    
    self.weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.weiboButton setImage:[UIImage imageNamed:@"btn_fullscreen_weibo"] forState:UIControlStateNormal];
    [self.weiboButton setImage:[UIImage imageNamed:@"btn_fullscreen_weibo_highlight"] forState:UIControlStateHighlighted];
    [self.weiboButton addTarget:self action:@selector(onClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.weiboButton sizeToFit];
    self.weiboButton.tag = HTButtonTypeWeibo;
    self.weiboButton.alpha = 0;
    [self.view addSubview:self.weiboButton];
    
    self.qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.qqButton setImage:[UIImage imageNamed:@"btn_fullscreen_qq"] forState:UIControlStateNormal];
    [self.qqButton setImage:[UIImage imageNamed:@"btn_fullscreen_qq_highlight"] forState:UIControlStateHighlighted];
    [self.qqButton addTarget:self action:@selector(onClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.qqButton sizeToFit];
    self.qqButton.tag = HTButtonTypeQQ;
    self.qqButton.alpha = 0;
    [self.view addSubview:self.qqButton];
    
    if (NO_NETWORK) {
        [_webView removeFromSuperview];
        [_backgroundImageView removeFromSuperview];
        self.view.backgroundColor = [UIColor blackColor];
        self.blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
        [self.blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:17];
        [self.view addSubview:self.blankView];
        self.blankView.top = ROUND_HEIGHT_FLOAT(157);
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _visualEfView.frame = self.view.bounds;
    _backgroundImageView.frame = self.view.bounds;
    _webView.frame = self.view.bounds;
    
    self.backButton.left = 11;
    self.backButton.bottom = SCREEN_HEIGHT - 11;
    self.shareButton.right = SCREEN_WIDTH - 11;
    self.shareButton.top = self.backButton.top;
    self.cancelButton.center = self.shareButton.center;
    self.likeButton.right = self.shareButton.left - 27;
    self.likeButton.top = self.backButton.top;
    
    self.qqButton.right = SCREEN_WIDTH - 11;
    self.qqButton.bottom = self.shareButton.top - 7;
    self.weiboButton.centerY = self.qqButton.centerY;
    self.weiboButton.right = self.qqButton.left - 27;
    self.momentButton.centerY = self.qqButton.centerY;
    self.momentButton.right = self.weiboButton.left - 27;
    self.wechatButton.centerY = self.qqButton.centerY;
    self.wechatButton.right = self.momentButton.left - 27;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _cancelButton.alpha = 0;
    _shareButton.alpha = _likeButton.alpha;
    [self setShareAppear:NO];
    
    if (scrollView.contentOffset.y <= 100) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backButton.alpha = 1.;
            self.shareButton.alpha = 1.;
            self.likeButton.alpha = 1.;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        if (lastOffsetY >= scrollView.contentOffset.y) {
            [UIView animateWithDuration:0.3 animations:^{
                self.backButton.alpha = 1.;
                self.shareButton.alpha = 1.;
                self.likeButton.alpha = 1.;
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.backButton.alpha = 0;
                self.shareButton.alpha = 0;
                self.likeButton.alpha = 0;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
    lastOffsetY = scrollView.contentOffset.y;
}

#pragma mark - UIGestureRecognizer Delegate

// 允许多个手势并发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UIWebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [HTProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [HTProgressHUD dismiss];
}

#pragma mark - Action

- (void)onClickBackView {
    [self setShareAppear:NO];
    self.shareButton.alpha = self.likeButton.alpha;
    self.cancelButton.alpha = self.likeButton.alpha == 0?0:1-self.shareButton.alpha;
}

- (void)onClickBackButton {
    if (self.navigationController && self.navigationController.viewControllers.count >= 2) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)onClickShareButton:(UIButton *)sender {
    [self share:sender];
}

- (void)onClickLikeButton {
    [HTProgressHUD show];
    [[[HTServiceManager sharedInstance] profileService] collectArticleWithArticleID:self.article.articleID completion:^(BOOL success, HTResponsePackage *response) {
        [HTProgressHUD dismiss];
        if (success && response.resultCode == 0) {
            _article.is_collect = !_article.is_collect;
            if (_article.is_collect) {
                [MBProgressHUD bwm_showTitle:@"收藏成功" toView:self.view hideAfter:1.0];
            } else {
                [MBProgressHUD bwm_showTitle:@"取消收藏成功" toView:self.view hideAfter:1.0];
            }
            [self refreshLickButton];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLickButtonInArticleController:)]) {
                [self.delegate didClickLickButtonInArticleController:self];
            }
        } else {
            [self showTipsWithText:response.resultMsg];
        }
    }];
}

#pragma mark - Tool Method

- (void)refreshLickButton {
    if (_article.is_collect) {
        [self.likeButton setImage:[UIImage imageNamed:@"btn_fullscreen_liked"] forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"btn_fullscreen_liked_highlight"] forState:UIControlStateHighlighted];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"btn_fullscreen_like"] forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"btn_fullscreen_like_highlight"] forState:UIControlStateHighlighted];
    }
}
#pragma mark - Share

- (void)setShareAppear:(BOOL)appear {
    _momentButton.alpha = appear;
    _weiboButton.alpha = appear;
    _qqButton.alpha = appear;
    _wechatButton.alpha = appear;
}

- (void)share:(UIButton*)sender {
    HTButtonType type = (HTButtonType)sender.tag;
    switch (type) {
        case HTButtonTypeShare: {
            [UIView animateWithDuration:0.3 animations:^{
                _shareButton.alpha = 0;
                _cancelButton.alpha = 1.0;
                [self setShareAppear:YES];
            } completion:^(BOOL finished) {
            }];
            break;
        }
        case HTButtonTypeCancel: {
            [UIView animateWithDuration:0.3 animations:^{
                _cancelButton.alpha = 0;
                _shareButton.alpha = _likeButton.alpha;
                [self setShareAppear:NO];
            } completion:^(BOOL finished) {
            }];
            break;
        }
        case HTButtonTypeWechat: {
            NSArray* imageArray = @[_article.article_pic_2];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:_article.article_content
                                                 images:imageArray
                                                    url:[NSURL URLWithString:_article.articleURL]
                                                  title:_article.articleTitle
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@",error]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil, nil];
                            [alert show];
                            break;
                        }
                        default:
                            break;
                    }
                }];
            }
            break;
        }
        case HTButtonTypeMoment: {
            NSArray* imageArray = @[_article.article_pic_2];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:_article.article_subtitle
                                                 images:imageArray
                                                    url:[NSURL URLWithString:_article.articleURL]
                                                  title:_article.articleTitle
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@",error]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil, nil];
                            [alert show];
                            break;
                        }
                        default:
                            break;
                    }
                }];
            }
            break;
        }
        case HTButtonTypeWeibo: {
            NSArray* imageArray = @[_article.article_pic_2];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ %@ 来自@九零APP", _article.articleTitle , _article.articleURL]
                                                 images:imageArray
                                                    url:[NSURL URLWithString:_article.articleURL]
                                                  title:_article.articleTitle
                                                   type:SSDKContentTypeImage];
                [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@",error]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil, nil];
                            [alert show];
                            break;
                        }
                        default:
                            break;
                    }
                }];
            }
            break;
        }
        case HTButtonTypeQQ: {
            NSArray* imageArray = @[_article.article_pic_2];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:_article.article_content
                                                 images:imageArray
                                                    url:[NSURL URLWithString:_article.articleURL]
                                                  title:_article.articleTitle
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@",error]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil, nil];
                            [alert show];
                            break;
                        }
                        default:
                            break;
                    }
                }];
            }
            break;
        }
    }
}

@end
