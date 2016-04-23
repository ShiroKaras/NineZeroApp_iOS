//
//  HTArticleController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTArticleController.h"
#import "HTUIHeader.h"

@interface HTArticleController () <UIWebViewDelegate> {
    UIImageView *_backgroundImageView;
    UIVisualEffectView *_visualEfView;
}
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *shareButton;
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
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.image = [UIImage imageNamed:@"bg_article"];
    [self.view addSubview:_backgroundImageView];
    
    if (IOS_VERSION >= 8.0) {
        _visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _visualEfView.alpha = 1.0;
        _visualEfView.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [_backgroundImageView addSubview:_visualEfView];
    }
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.scrollView.delaysContentTouches = NO;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _webView.allowsInlineMediaPlayback = YES;
    _webView.delegate = self;
    _webView.mediaPlaybackRequiresUserAction = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ARTICLE_URL_STRING]]];
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
    [self.shareButton addTarget:self action:@selector(onClickShareButton) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton sizeToFit];
    [self.view addSubview:self.shareButton];
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton addTarget:self action:@selector(onClickLikeButton) forControlEvents:UIControlEventTouchUpInside];
    [self refreshLickButton];
    [self.likeButton sizeToFit];
    [self.view addSubview:self.likeButton];
    
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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _visualEfView.frame = self.view.bounds;
    _backgroundImageView.frame = self.view.bounds;
    _webView.frame = self.view.bounds;
    
    self.backButton.left = 11;
    self.backButton.bottom = SCREEN_HEIGHT - 11;
    self.shareButton.right = SCREEN_WIDTH - 11;
    self.shareButton.top = self.backButton.top;
    self.likeButton.right = self.shareButton.left - 27;
    self.likeButton.top = self.backButton.top;
}

#pragma mark - UIWebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

#pragma mark - Action

- (void)onClickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickShareButton {
    
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

@end
