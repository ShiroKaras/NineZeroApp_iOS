//
//  HTArticleController.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/31.
//  Copyright © 2016年 ronhu. All rights reserved.
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
    
    NSString *html = @"<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n    <meta charset=\"UTF-8\">\n    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n    <meta content=\"width=device-width, initial-scale=1.0\" name=\"viewport\" />\n    <title>Title</title>\n    <link rel=\"stylesheet\" href=\"../Public/dist/common.js.css\">\n    <link rel=\"stylesheet\" href=\"../Public/dist/article.css\">\n</head>\n<body>\n\n<header>\n    <img src=\"../Public/2.jpg\" class=\"am-img-responsive\">\n    <img src=\"../Public/2.gif\" class=\"thumbnail\">\n</header>\n\n<section>\n    <span class=\"c-red\">/零仔No.1</span>\n    <h3>这里是文章标题这里是文章标题</h3>\n    <p class=\"am-text-center\">中间标题</p>\n    <p>\n        这只零仔是懒惰，特征主要体现在行为上，走哪睡哪，吃东西会睡着 ，洗澡会睡着，\n        上学的路上会睡着，他可以映射这个时代的学生们，在压力之下的疲乏于无所作为。\n    </p>\n    <p>\n        这只零仔是懒惰，特征主要体现在行为上，走哪睡哪，吃东西会睡着 ，洗澡会睡着，\n        上学的路上会睡着，他可以映射这个时代的学生们，在压力之下的疲乏于无所作为。\n    </p>\n    <img src=\"../Public/1.jpg\">\n    <p>\n        这只零仔是懒惰，特征主要体现在行为上，走哪睡哪，吃东西会睡着 ，洗澡会睡着，\n        上学的路上会睡着，他可以映射这个时代的学生们，在压力之下的疲乏于无所作为。\n    </p>\n</section>\n\n<footer class=\"am-cf am-padding\">\n    <i class=\"the-icon-btn am-icon am-icon-angle-left am-fl\"></i>\n    <i class=\"the-icon-btn am-icon am-icon-upload am-fr \"></i>\n    <i class=\"the-icon-btn am-icon am-icon-heart am-fr am-margin-right\"></i>\n</footer>\n\n\n\n<script src=\"../Public/dist/common.js\"></script>\n<script src=\"../Public/dist/article.js\"></script>\n</body>\n</html>";
//    html = [NSString stringWithFormat:@"<head><style>img{width:device-width !important;}</style></head>\n<html><body font-family: '-apple-system','HelveticaNeue'; style=\"line-height:24px; font-size:13px; padding='6px 13px 0px 13px'\" text=\"#DDDDDD\">%@</body></html>", html];
//    
//    html = [NSString stringWithFormat:@"<head><style>img{width:device-width !important;}</style></head>\n<html><body font-family: \'-apple-system\',\'HelveticaNeue\'; style=\"line-height:24px; font-size:13px; padding=\'6px 13px 0px 13px\'\" text=\"#DDDDDD\"><span style=\"font-family:Helvetica;\">%@</span></body></html>", html];
    
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.image = [UIImage imageNamed:@"bg_article"];
    [self.view addSubview:_backgroundImageView];
    
    if (IOS_VERSION >= 8.0) {
        _visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _visualEfView.alpha = 1.0;
        [_backgroundImageView addSubview:_visualEfView];
    }
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.scrollView.delaysContentTouches = NO;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _webView.allowsInlineMediaPlayback = YES;
    _webView.delegate = self;
    _webView.mediaPlaybackRequiresUserAction = NO;
    //    [_webView stringByEvaluatingJavaScriptFromString:padding];
    [_webView loadHTMLString:html baseURL:nil];
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
    [self.likeButton setImage:[UIImage imageNamed:@"btn_fullscreen_liked"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"btn_fullscreen_liked_highlight"] forState:UIControlStateHighlighted];
    [self.likeButton addTarget:self action:@selector(onClickLikeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.likeButton sizeToFit];
    [self.view addSubview:self.likeButton];
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
//    NSString *padding = @"document.body.style.margin='0';document.body.style.padding = '0'";
    NSString *padding = @"require(\'expose?$!expose?jQuery!jquery\');\nrequire(\'amazeui/dist/css/amazeui.css\');\nrequire(\'amazeui/dist/js/amazeui.js\');\nrequire(\'./../css/article.scss\');\n\n";
    [webView stringByEvaluatingJavaScriptFromString:padding];
}

#pragma mark - Action

- (void)onClickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickShareButton {
    
}

- (void)onClickLikeButton {

}

@end
