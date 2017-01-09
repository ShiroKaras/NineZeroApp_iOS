//
//  HTWebController.m
//  NineZeroProject
//
//  Created by ShiroKaras on 16/4/5.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "HTWebController.h"
#import "HTUIHeader.h"

@interface HTWebController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation HTWebController {
    float lastOffsetY;
}

- (instancetype)initWithURLString:(NSString *)urlString {
    if (self = [super init]) {
        _urlString = urlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_BG_COLOR;

     _webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 64, self.view.bounds.size.width-20, self.view.bounds.size.height-64)];
    _webView.scrollView.delaysContentTouches = NO;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.allowsInlineMediaPlayback = YES;
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    _webView.mediaPlaybackRequiresUserAction = NO;
    [self.view addSubview:_webView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headerView.backgroundColor = COMMON_TITLE_BG_COLOR;
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.titleString;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [titleLabel sizeToFit];
    titleLabel.center = headerView.center;
    [headerView addSubview:titleLabel];
    [self.view addSubview:headerView];
    
    [HTProgressHUD show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.title isEqualToString:@"金币"]) {
        [MobClick beginLogPageView:@"goldcoinpage"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.title isEqualToString:@"金币"]){
        [MobClick endLogPageView:@"goldcoinpage"];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _webView.frame = CGRectMake(10, 64, self.view.bounds.size.width-20, self.view.bounds.size.height-64);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [HTProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [HTProgressHUD dismiss];
//    [self showTipsWithText:@"加载失败" offset:64];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    backView.backgroundColor = [UIColor blackColor];
    [self.view  addSubview:backView];
    
    HTBlankView *blankView = [[HTBlankView alloc] initWithType:HTBlankViewTypeNetworkError];
    blankView.center = self.view.center;
    [blankView setImage:[UIImage imageNamed:@"img_error_grey_big"] andOffset:11];
    [backView addSubview:blankView];
}

@end
