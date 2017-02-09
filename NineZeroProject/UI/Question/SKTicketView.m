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
//    if (self = [super initWithFrame:CGRectMake(0, 0, 280, 108)]) {
    if (self = [super initWithFrame:frame]) {
        self.ticket = reward;
        [self createUIWithFrame:frame];
    }
    return self;
}

- (void)createUIWithFrame:(CGRect)frame {
    
//    UIImageView *ticketBackgoundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_couponbg"]];
//    ticketBackgoundImageView.layer.masksToBounds =  YES;
//    ticketBackgoundImageView.contentMode = UIViewContentModeScaleAspectFill;
//    ticketBackgoundImageView.frame = self.frame;
//    [self addSubview:ticketBackgoundImageView];
    
    UIImageView *ticketImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    ticketImageView.layer.masksToBounds = YES;
    ticketImageView.layer.cornerRadius =5;
    ticketImageView.contentMode = UIViewContentModeScaleAspectFill;
    [ticketImageView sd_setImageWithURL:[NSURL URLWithString:self.ticket.ticket_cover]];
    [self addSubview:ticketImageView];
    
    UILabel *ticketTitleLabel_shadow = [UILabel new];
    ticketTitleLabel_shadow.text = self.ticket.title;
    ticketTitleLabel_shadow.textColor = [UIColor blackColor];
    ticketTitleLabel_shadow.font = PINGFANG_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(12));
    ticketTitleLabel_shadow.numberOfLines = 2;
    [self addSubview:ticketTitleLabel_shadow];
    [ticketTitleLabel_shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@14);
        make.left.equalTo(@13);
        make.width.equalTo(ROUND_WIDTH(163));
        make.height.equalTo(ROUND_HEIGHT(40));
    }];
    
    UILabel *ticketTitleLabel = [UILabel new];
    ticketTitleLabel.text = self.ticket.title;
    ticketTitleLabel.textColor = [UIColor whiteColor];
    ticketTitleLabel.font = PINGFANG_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(12));
    ticketTitleLabel.numberOfLines = 2;
    [self addSubview:ticketTitleLabel];
    [ticketTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@13);
        make.left.equalTo(@12);
        make.width.equalTo(ROUND_WIDTH(163));
        make.height.equalTo(ROUND_HEIGHT(40));
    }];
    
    UILabel *exchangeCodeLabel_shadow = [UILabel new];
    exchangeCodeLabel_shadow.text = [NSString stringWithFormat:@"唯一兑换码 %@",self.ticket.code];
    exchangeCodeLabel_shadow.textColor = [UIColor blackColor];
    exchangeCodeLabel_shadow.font = PINGFANG_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(10));
    [exchangeCodeLabel_shadow sizeToFit];
    [self addSubview:exchangeCodeLabel_shadow];
    [exchangeCodeLabel_shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-13);
        make.left.equalTo(ticketTitleLabel).offset(1);
    }];
    
    UILabel *exchangeCodeLabel = [UILabel new];
    exchangeCodeLabel.text = [NSString stringWithFormat:@"唯一兑换码 %@",self.ticket.code];
    exchangeCodeLabel.textColor = [UIColor whiteColor];
    exchangeCodeLabel.font = PINGFANG_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(10));
    [exchangeCodeLabel sizeToFit];
    [self addSubview:exchangeCodeLabel];
    [exchangeCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-14);
        make.left.equalTo(ticketTitleLabel);
    }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.ticket.expire_time];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    UILabel *timeLimitLabal_shadow = [UILabel new];
    timeLimitLabal_shadow.text = [NSString stringWithFormat:@"有效期至%@",confromTimespStr];
    timeLimitLabal_shadow.textColor = [UIColor blackColor];
    timeLimitLabal_shadow.font = PINGFANG_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(10));
    [timeLimitLabal_shadow sizeToFit];
    [self addSubview:timeLimitLabal_shadow];
    [timeLimitLabal_shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(exchangeCodeLabel.mas_top).offset(-3);
        make.left.equalTo(ticketTitleLabel).offset(1);
    }];
    
    UILabel *timeLimitLabal = [UILabel new];
    timeLimitLabal.text = [NSString stringWithFormat:@"有效期至%@",confromTimespStr];
    timeLimitLabal.textColor = [UIColor whiteColor];
    timeLimitLabal.font = PINGFANG_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(10));
    [timeLimitLabal sizeToFit];
    [self addSubview:timeLimitLabal];
    [timeLimitLabal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(exchangeCodeLabel.mas_top).offset(-4);
        make.left.equalTo(ticketTitleLabel);
    }];
}

@end