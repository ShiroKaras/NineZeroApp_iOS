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
    
    NSString *html = @"<p>\n\t<br />\n</p>\n<p>\n\t<br />\n</p>\n<p>\n\t<br />\n</p>\n<p>\n\t<br />\n</p>\n<p>\n\t<br />\n</p>\n<p>\n\t&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;这里是主标题\n</p>\n<p>\n\t<span style=\"font-size:14px;\"><strong>&nbsp; &nbsp; &nbsp; &nbsp; 这里是副标题</strong></span><span style=\"font-size:14px;\"><strong>这里是副标题 &nbsp; &nbsp; &nbsp;&nbsp;</strong></span> \n</p>\n<p>\n\t<span style=\"font-size:14px;\"><strong><br />\n</strong></span> \n</p>\n<hr />\n<p>\n\t<br />\n</p>\n<p class=\"p1\">\n\t<span class=\"s1\">\n\t<p class=\"p1\">\n\t\t<span class=\"s1\">这次的开放是内因。来自边缘广州的微信，如新星般冉冉升起。同样实现</span><span class=\"s2\">5</span><span class=\"s1\">亿用户，微信用了</span><span class=\"s2\">4</span><span class=\"s1\">年，而</span><span class=\"s2\">QQ</span><span class=\"s1\">用了十几年。你可以说这是互联网指数级发展的结果，也可以说微信是专为移动而生的产品。所幸，命运依旧青睐</span><span class=\"s2\">QQ</span><span class=\"s1\">，他们把时代的机遇给了微信，但是把年轻人群再次给到了</span><span class=\"s2\">QQ</span><span class=\"s1\">。腾讯即通应用部的总经理张孝超说，使用手机</span><span class=\"s2\">QQ</span><span class=\"s1\">的用户，超过半成以上是</span><span class=\"s2\">90</span><span class=\"s1\">后和</span><span class=\"s2\">00</span><span class=\"s1\">后用户。这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">。</span>\n\t</p>\n\t<p class=\"p1\">\n\t\t<span class=\"s1\"><img src=\"http://img3.imgtn.bdimg.com/it/u=3184591409,3565172750&amp;fm=21&amp;gp=0.jpg\" width=\"375\" height=\"300\" alt=\"\" /><br />\n</span>\n\t</p>\n\t<p>\n\t\t<span class=\"s1\">这次的开放是内因。来自边缘广州的微信，如新星般冉冉升起。同样实现</span><span class=\"s2\">5</span><span class=\"s1\">亿用户，微信用了</span><span class=\"s2\">4</span><span class=\"s1\">年，而</span><span class=\"s2\">QQ</span><span class=\"s1\">用了十几年。你可以说这是互联网指数级发展的结果，也可以说微信是专为移动而生的产品。所幸，命运依旧青睐</span><span class=\"s2\">QQ</span><span class=\"s1\">，他们把时代的机遇给了微信，但是把年轻人群再次给到了</span><span class=\"s2\">QQ</span><span class=\"s1\">。腾讯即通应用部的总经理张孝超说，使用手机</span><span class=\"s2\">QQ</span><span class=\"s1\">的用户，超过半成以上是</span><span class=\"s2\">90</span><span class=\"s1\">后和</span><span class=\"s2\">00</span><span class=\"s1\">后用户。这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">。</span>\n\t</p>\n\t<p class=\"p1\">\n\t\t<span class=\"s1\">这次的开放是内因。来自边缘广州的微信，如新星般冉冉升起。同样实现</span><span class=\"s2\">5</span><span class=\"s1\">亿用户，微信用了</span><span class=\"s2\">4</span><span class=\"s1\">年，而</span><span class=\"s2\">QQ</span><span class=\"s1\">用了十几年。你可以说这是互联网指数级发展的结果，也可以说微信是专为移动而生的产品。所幸，命运依旧青睐</span><span class=\"s2\">QQ</span><span class=\"s1\">，他们把时代的机遇给了微信，但是把年轻人群再次给到了</span><span class=\"s2\">QQ</span><span class=\"s1\">。腾讯即通应用部的总经理张孝超说，使用手机</span><span class=\"s2\">QQ</span><span class=\"s1\">的用户，超过半成以上是</span><span class=\"s2\">90</span><span class=\"s1\">后和</span><span class=\"s2\">00</span><span class=\"s1\">后用户。这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">。</span>\n\t</p>\n\t<p class=\"p1\">\n\t\t<span class=\"s1\"><img src=\"http://img3.imgtn.bdimg.com/it/u=3184591409,3565172750&amp;fm=21&amp;gp=0.jpg\" width=\"375\" height=\"300\" alt=\"\" /><br />\n</span>\n\t</p>\n\t<p>\n\t\t<span class=\"s1\">这次的开放是内因。来自边缘广州的微信，如新星般冉冉升起。同样实现</span><span class=\"s2\">5</span><span class=\"s1\">亿用户，微信用了</span><span class=\"s2\">4</span><span class=\"s1\">年，而</span><span class=\"s2\">QQ</span><span class=\"s1\">用了十几年。你可以说这是互联网指数级发展的结果，也可以说微信是专为移动而生的产品。所幸，命运依旧青睐</span><span class=\"s2\">QQ</span><span class=\"s1\">，他们把时代的机遇给了微信，但是把年轻人群再次给到了</span><span class=\"s2\">QQ</span><span class=\"s1\">。腾讯即通应用部的总经理张孝超说，使用手机</span><span class=\"s2\">QQ</span><span class=\"s1\">的用户，超过半成以上是</span><span class=\"s2\">90</span><span class=\"s1\">后和</span><span class=\"s2\">00</span><span class=\"s1\">后用户。这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">。</span>\n\t</p>\n\t<p class=\"p1\">\n\t\t<span class=\"s1\">这次的开放是内因。来自边缘广州的微信，如新星般冉冉升起。同样实现</span><span class=\"s2\">5</span><span class=\"s1\">亿用户，微信用了</span><span class=\"s2\">4</span><span class=\"s1\">年，而</span><span class=\"s2\">QQ</span><span class=\"s1\">用了十几年。你可以说这是互联网指数级发展的结果，也可以说微信是专为移动而生的产品。所幸，命运依旧青睐</span><span class=\"s2\">QQ</span><span class=\"s1\">，他们把时代的机遇给了微信，但是把年轻人群再次给到了</span><span class=\"s2\">QQ</span><span class=\"s1\">。腾讯即通应用部的总经理张孝超说，使用手机</span><span class=\"s2\">QQ</span><span class=\"s1\">的用户，超过半成以上是</span><span class=\"s2\">90</span><span class=\"s1\">后和</span><span class=\"s2\">00</span><span class=\"s1\">后用户。这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">。</span>\n\t</p>\n\t<p class=\"p1\">\n\t\t<span class=\"s1\"><img src=\"http://img3.imgtn.bdimg.com/it/u=3184591409,3565172750&amp;fm=21&amp;gp=0.jpg\" width=\"375\" height=\"300\" alt=\"\" /><br />\n</span>\n\t</p>\n\t<p>\n\t\t<span class=\"s1\">这次的开放是内因。来自边缘广州的微信，如新星般冉冉升起。同样实现</span><span class=\"s2\">5</span><span class=\"s1\">亿用户，微信用了</span><span class=\"s2\">4</span><span class=\"s1\">年，而</span><span class=\"s2\">QQ</span><span class=\"s1\">用了十几年。你可以说这是互联网指数级发展的结果，也可以说微信是专为移动而生的产品。所幸，命运依旧青睐</span><span class=\"s2\">QQ</span><span class=\"s1\">，他们把时代的机遇给了微信，但是把年轻人群再次给到了</span><span class=\"s2\">QQ</span><span class=\"s1\">。腾讯即通应用部的总经理张孝超说，使用手机</span><span class=\"s2\">QQ</span><span class=\"s1\">的用户，超过半成以上是</span><span class=\"s2\">90</span><span class=\"s1\">后和</span><span class=\"s2\">00</span><span class=\"s1\">后用户。这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">这意味着，</span><span class=\"s2\">QQ</span><span class=\"s1\">与微信成为差异化社交产品，大多数人同时拥有这两款社交工具，但深度使用者的重复率可能不超过</span><span class=\"s2\">20</span><span class=\"s1\">。</span>\n\t</p>\n</span>\n</p>\n<p>\n\t<span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span><span class=\"s2\"></span><span class=\"s1\"></span> \n</p>\n<p>\n\t<span style=\"line-height:1.5;\"></span> \n</p>";
    
    html = [NSString stringWithFormat:@"<head><style>img{width:device-width !important;}</style></head>\n<html><body font-family: '-apple-system','HelveticaNeue'; style=\"line-height:24px; font-size:13px; padding='6px 13px 0px 13px'\" text=\"#DDDDDD\">%@</body></html>", html];
    
    html = [NSString stringWithFormat:@"<head><style>img{width:device-width !important;}</style></head>\n<html><body font-family: \'-apple-system\',\'HelveticaNeue\'; style=\"line-height:24px; font-size:13px; padding=\'6px 13px 0px 13px\'\" text=\"#DDDDDD\"><span style=\"font-family:Helvetica;\">%@</span></body></html>", html];
    
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
    NSString *padding = @"document.body.style.margin='0';document.body.style.padding = '0'";
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
