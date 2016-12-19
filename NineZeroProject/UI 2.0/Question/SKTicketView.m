//
//  SKTicketView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKTicketView.h"
#import "HTUIHeader.h"

@interface SKTicketView ()
@property (nonatomic, strong) SKTicket *ticket;
@end

@implementation SKTicketView

- (instancetype)initWithFrame:(CGRect)frame reward:(SKTicket*)reward
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 280, 108)]) {
        self.ticket = reward;
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
    ticketTitleLabel.text = self.ticket.title;
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.ticket.expire_time];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    UILabel *timeLimitLabal = [UILabel new];
    timeLimitLabal.text = [NSString stringWithFormat:@"有效期至%@",confromTimespStr];
    timeLimitLabal.textColor = [UIColor whiteColor];
    timeLimitLabal.font = PINGFANG_FONT_OF_SIZE(10);
    [timeLimitLabal sizeToFit];
    [self addSubview:timeLimitLabal];
    [timeLimitLabal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ticketTitleLabel.mas_bottom).offset(8);
        make.left.equalTo(ticketTitleLabel);
    }];
    
    UILabel *exchangeCodeLabel = [UILabel new];
    exchangeCodeLabel.text = [NSString stringWithFormat:@"唯一兑换码 %@",self.ticket.code];
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
