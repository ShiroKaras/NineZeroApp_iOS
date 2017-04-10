//
//  NZQuestionGiftView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/10.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZQuestionGiftView.h"
#import "HTUIHeader.h"

#import "SKTicketView.h"

@implementation NZQuestionGiftView

- (instancetype)initWithFrame:(CGRect)frame withReward:(SKReward *)reward
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:scrollView];
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzledetailpage_gift"]];
        [scrollView addSubview:titleImageView];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
        }];
        
        UIImageView *rankTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_successtext1"]];
        [scrollView addSubview:rankTextImageView];
        [rankTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(titleImageView.mas_bottom).offset(31);
        }];
        
        UIImageView *textImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_gettext"]];
        [scrollView addSubview:textImageView1];
        [textImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rankTextImageView);
            make.top.equalTo(rankTextImageView.mas_bottom).offset(26);
        }];
        
        //金币
        UILabel *goldLabel = [UILabel new];
        goldLabel.text = @"5";
        goldLabel.textColor = COMMON_PINK_COLOR;
        goldLabel.font = MOON_FONT_OF_SIZE(30);
        [goldLabel sizeToFit];
        [scrollView addSubview:goldLabel];
        [goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textImageView1.mas_bottom).offset(13);
            make.right.equalTo(textImageView1);
        }];
        
        UIImageView *goldTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_gold"]];
        [scrollView addSubview:goldTextImageView];
        [goldTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(goldLabel);
            make.left.equalTo(goldLabel.mas_right).offset(6);
        }];
        
        //宝石
        UILabel *gemLabel = [UILabel new];
        gemLabel.text = @"5";
        gemLabel.textColor = COMMON_PINK_COLOR;
        gemLabel.font = MOON_FONT_OF_SIZE(30);
        [gemLabel sizeToFit];
        [scrollView addSubview:gemLabel];
        [gemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(goldLabel.mas_bottom).offset(13);
            make.right.equalTo(textImageView1);
        }];
        
        UIImageView *gemTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_diamonds"]];
        [scrollView addSubview:gemTextImageView];
        [gemTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(gemLabel);
            make.left.equalTo(gemLabel.mas_right).offset(6);
        }];
        
        //经验值
        UILabel *expLabel = [UILabel new];
        expLabel.text = @"5";
        expLabel.textColor = COMMON_PINK_COLOR;
        expLabel.font = MOON_FONT_OF_SIZE(30);
        [expLabel sizeToFit];
        [scrollView addSubview:expLabel];
        [expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(gemLabel.mas_bottom).offset(13);
            make.right.equalTo(textImageView1);
        }];
        
        UIImageView *expTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_exp"]];
        [scrollView addSubview:expTextImageView];
        [expTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(expLabel);
            make.left.equalTo(expLabel.mas_right).offset(6);
        }];
        
        [self layoutIfNeeded];
        
        SKTicketView *ticket = [[SKTicketView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/2, expTextImageView.bottom+31, 280, 108) reward:reward.ticket];
        [scrollView addSubview:ticket];
        
        scrollView.contentSize = CGSizeMake(frame.size.width, ticket.bottom);
    }
    return self;
}

@end
