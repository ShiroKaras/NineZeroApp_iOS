//
//  SKTicketView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKTicketView.h"
#import "HTUIHeader.h"

@implementation SKTicketView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 280, 108)]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIImageView *ticketBackgoundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_couponbg"]];
    ticketBackgoundImageView.frame = self.frame;
    [self addSubview:ticketBackgoundImageView];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_couponline"]];
    lineImageView.frame = self.frame;
    [self addSubview:lineImageView];
    
    UILabel *ticketTitleLabel = [UILabel new];
    ticketTitleLabel.text = @"把藏在城市里的零仔\n公仔带回家";
    ticketTitleLabel.textColor = [UIColor whiteColor];
    ticketTitleLabel.font = PINGFANG_FONT_OF_SIZE(12);
    ticketTitleLabel.numberOfLines = 2;
    [self addSubview:ticketTitleLabel];
    [ticketTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@13);
        make.left.equalTo(@12);
        make.width.equalTo(@163);
        make.height.equalTo(@40);
    }];
    
    UILabel *timeLimitLabal = [UILabel new];
    timeLimitLabal.text = @"有效期至2015-12-31";
    timeLimitLabal.textColor = [UIColor whiteColor];
    timeLimitLabal.font = PINGFANG_FONT_OF_SIZE(10);
    [timeLimitLabal sizeToFit];
    [self addSubview:timeLimitLabal];
    [timeLimitLabal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ticketTitleLabel.mas_bottom).offset(8);
        make.left.equalTo(ticketTitleLabel);
    }];
    
    UILabel *exchangeCodeLabel = [UILabel new];
    exchangeCodeLabel.text = @"唯一兑换码 300765455";
    exchangeCodeLabel.textColor = [UIColor whiteColor];
    exchangeCodeLabel.font = PINGFANG_FONT_OF_SIZE(10);
    [exchangeCodeLabel sizeToFit];
    [self addSubview:exchangeCodeLabel];
    [exchangeCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLimitLabal.mas_bottom).offset(4);
        make.left.equalTo(timeLimitLabal);
    }];
}

@end
