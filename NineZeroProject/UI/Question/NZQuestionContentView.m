//
//  NZQuestionContentView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/6.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZQuestionContentView.h"
#import "HTUIHeader.h"

@interface NZQuestionContentView () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *converView;

@end

@implementation NZQuestionContentView

- (instancetype)initWithFrame:(CGRect)frame question:(SKQuestion *)question
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzledetailpage_story"]];
        [self addSubview:titleImageView];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
        }];
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 36, frame.size.width, frame.size.height)];
//        _webView.scrollView.contentInset = UIEdgeInsetsMake(36, 0, 0, 0);
        _webView.delegate = self;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        
        NSString *htmlString = [NSString stringWithFormat:@"<html><body font-family: '-apple-system','HelveticaNeue'; style=\"line-height:24px; font-size:13px\" text=\"#d9d9d9\" bgcolor=\"#0e0e0e\"><span style=\"font-family: \'-apple-system\',\'HelveticaNeue\';\"><div style=\"word-wrap:break-word; width:%ldpx;\">%@</div></span></body></html>", (long)self.frame.size.width-16, question.description_url];
        [_webView loadHTMLString:htmlString baseURL: nil];
        _webView.delegate = self;
        NSString *padding = @"document.body.style.padding='16px 16px 0px 16px';";
        [_webView stringByEvaluatingJavaScriptFromString:padding];
        _webView.alpha = 1;
        [self addSubview:_webView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float sizeHeight = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    NSLog(@"%lf",sizeHeight);
    
    self.viewHeight = _webView.height+36;
}


@end
