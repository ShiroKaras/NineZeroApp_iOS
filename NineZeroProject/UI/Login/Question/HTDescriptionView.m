//
//  HTDescriptionView.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/19.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTDescriptionView.h"
#import <Masonry.h>

@interface HTDescriptionView ()

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation HTDescriptionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_navi_cancel"] forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
        
        _webView = [[UIWebView alloc] init];
    }
    return self;
}

@end
