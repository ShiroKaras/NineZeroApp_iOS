//
//  HTWebController.m
//  NineZeroProject
//
//  Created by ronhu on 16/4/5.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTWebController.h"
#import "HTUIHeader.h"

@interface HTWebController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation HTWebController

- (instancetype)initWithURLString:(NSString *)urlString {
    if (self = [super init]) {
        _urlString = urlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"金币";
    self.view.backgroundColor = [UIColor blackColor];
     _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.scrollView.delaysContentTouches = NO;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _webView.allowsInlineMediaPlayback = YES;
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    _webView.mediaPlaybackRequiresUserAction = NO;
    [self.view addSubview:_webView];
    [HTProgressHUD show];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _webView.frame = self.view.bounds;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [HTProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [HTProgressHUD dismiss];
//    [self showTipsWithText:@"加载失败" offset:64];
    UIView *backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [UIColor blackColor];
    [self.view  addSubview:backView];
    
    HTBlankView *blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
    blankView.center = self.view.center;
    [blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:11];
    [backView addSubview:blankView];
}

@end
