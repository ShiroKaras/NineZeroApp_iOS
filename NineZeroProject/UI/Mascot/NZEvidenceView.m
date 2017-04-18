//
//  NZEvidenceView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/18.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZEvidenceView.h"
#import "HTUIHeader.h"

@implementation NZEvidenceView

- (instancetype)initWithFrame:(CGRect)frame withMascot:(SKMascot *)mascot {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *alphaView = [[UIView alloc] initWithFrame:frame];
        alphaView.backgroundColor = COMMON_BG_COLOR;
        alphaView.alpha = 0.9;
        [self addSubview:alphaView];
        
        UIImageView *propImageView = [UIImageView new];
        propImageView.backgroundColor = COMMON_GREEN_COLOR;
        propImageView.layer.cornerRadius = 2;
        propImageView.layer.borderColor = COMMON_GREEN_COLOR.CGColor;
        [self addSubview:propImageView];
        [propImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(222), ROUND_WIDTH_FLOAT(222)));
            make.centerX.equalTo(alphaView.mas_centerX);
            make.top.equalTo(ROUND_HEIGHT(107.5));
        }];
        
        UIImageView *propTextImageView = [UIImageView new];
        propTextImageView.backgroundColor = COMMON_GREEN_COLOR;
        [self addSubview:propTextImageView];
        [propTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 26));
            make.centerX.equalTo(alphaView.mas_centerX);
            make.top.equalTo(propImageView.mas_bottom).offset(30);
        }];
        
        UILabel *propTextLabel = [UILabel new];
        propTextLabel.text = @"这里不能随地大小便\n获得增加拘禁时间24H";
        propTextLabel.textColor = [UIColor whiteColor];
        propTextLabel.font = PINGFANG_FONT_OF_SIZE(14);
        [propTextLabel sizeToFit];
        [self addSubview:propTextLabel];
        [propTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(alphaView.mas_centerX);
            make.top.equalTo(propTextImageView.mas_bottom).offset(25);
        }];

//        UIButton *closeButton = [[UIButton alloc] initWithFrame:frame];
//        [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:closeButton];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)closeView {
    [self removeFromSuperview];
}

@end
