//
//  SKQuestionRewardView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/19.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKQuestionRewardView.h"
#import "HTUIHeader.h"

#import "SKTicketView.h"

@interface SKQuestionRewardView ()
@property (nonatomic, strong) NSDictionary *rewardDict;
@end

@implementation SKQuestionRewardView

- (instancetype)initWithFrame:(CGRect)frame reward:(NSDictionary*)rewardDict button:(UIButton*)button;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rewardDict = rewardDict;
        [self createUIWithFrame:frame button:button];
    }
    return self;
}

- (void)createUIWithFrame:(CGRect)frame button:(UIButton*)button {
    //rewardBackView
    UIView *rewardBackView = [[UIView alloc] initWithFrame:frame];
    rewardBackView.backgroundColor = COMMON_SEPARATOR_COLOR;
    rewardBackView.layer.cornerRadius = 5;
    [self addSubview:rewardBackView];
    
    UIImageView *giftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_detailspage_gift_highlight"]];
    [self addSubview:giftImageView];
    giftImageView.frame = button.frame;
    
    UIView *rewardBaseInfoView = [UIView new];
    rewardBaseInfoView.backgroundColor = [UIColor clearColor];
    [rewardBackView addSubview:rewardBaseInfoView];
    [rewardBaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@248);
        make.height.equalTo(@294);
        make.centerX.equalTo(rewardBackView);
        if ([[self.rewardDict allKeys] containsObject:@"ticket"])   make.top.equalTo(@16);
        else            make.top.equalTo(@86);
    }];
    
    [self createRewardBaseInfoWithBaseInfoView:rewardBaseInfoView];
    
    //Ticket
    if ([[self.rewardDict allKeys] containsObject:@"ticket"]) {
        SKTicketView *card = [[SKTicketView alloc] initWithFrame:CGRectZero];
        [rewardBaseInfoView addSubview:card];
        [card mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@280);
            make.height.equalTo(@108);
            make.centerX.equalTo(rewardBaseInfoView);
            make.bottom.equalTo(rewardBackView.mas_bottom).offset(-(self.height-320-108)/2);
        }];
    }

}

- (void)createRewardBaseInfoWithBaseInfoView:(UIView*)rewardBaseInfoView {
    UIImageView *rewardImageView_mascot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_mascot"]];
    [rewardBaseInfoView addSubview:rewardImageView_mascot];
    [rewardImageView_mascot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@139);
        make.height.equalTo(@146);
        make.top.equalTo(rewardBaseInfoView.mas_top);
        make.right.equalTo(rewardBaseInfoView.mas_right);
    }];
    
    UIImageView *rewardImageView_txt_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_1"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_1];
    [rewardImageView_txt_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@105);
        make.height.equalTo(@60);
        make.top.equalTo(rewardBaseInfoView).offset(121);
        make.left.equalTo(rewardBaseInfoView);
    }];
    
    UIImageView *rewardImageView_txt_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_2"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_2];
    [rewardImageView_txt_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@111);
        make.height.equalTo(@24);
        make.left.equalTo(rewardBaseInfoView).offset(106);
        make.top.equalTo(rewardBaseInfoView).offset(217-24);
    }];
    
    UILabel *percentLabel = [UILabel new];
    percentLabel.font = MOON_FONT_OF_SIZE(32.5);
    percentLabel.textColor = COMMON_GREEN_COLOR;
    percentLabel.text = @"99.9%";
    [percentLabel sizeToFit];
    [rewardBaseInfoView addSubview:percentLabel];
    [percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardImageView_txt_1.mas_right).offset(4);
        make.top.equalTo(rewardImageView_mascot.mas_bottom).offset(8);
    }];
    
    //金币行
    UIImageView *rewardImageView_txt_3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_page_txt_3"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_3];
    [rewardImageView_txt_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@19);
        make.top.equalTo(rewardImageView_txt_2.mas_bottom).offset(10);
        make.left.equalTo(rewardBaseInfoView);
    }];
    
    UILabel *iconCountLabel = [UILabel new];
    iconCountLabel.textColor = COMMON_RED_COLOR;
    iconCountLabel.text = @"5";
    iconCountLabel.font = MOON_FONT_OF_SIZE(19);
    [iconCountLabel sizeToFit];
    [rewardBaseInfoView addSubview:iconCountLabel];
    [iconCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardImageView_txt_3.mas_right).offset(6);
        make.centerY.equalTo(rewardImageView_txt_3);
    }];
    
    UIImageView *rewardImageView_txt_gold = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_goldtext"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_gold];
    [rewardImageView_txt_gold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@37);
        make.height.equalTo(@19);
        make.left.equalTo(iconCountLabel.mas_right).offset(6);
        make.centerY.equalTo(iconCountLabel);
    }];
    
    //经验值行
    UIImageView *rewardImageView_exp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_exp"]];
    [rewardBaseInfoView addSubview:rewardImageView_exp];
    [rewardImageView_exp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@18);
        make.height.equalTo(@18);
        make.top.equalTo(rewardImageView_txt_3.mas_bottom).offset(6);
        make.right.equalTo(rewardImageView_txt_3);
    }];
    
    UILabel *expCountLabel = [UILabel new];
    expCountLabel.textColor = COMMON_RED_COLOR;
    expCountLabel.text = @"5";
    expCountLabel.font = MOON_FONT_OF_SIZE(19);
    [expCountLabel sizeToFit];
    [rewardBaseInfoView addSubview:expCountLabel];
    [expCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardImageView_exp.mas_right).offset(6);
        make.centerY.equalTo(rewardImageView_exp);
    }];
    
    UIImageView *rewardImageView_txt_exp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_exptext"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_exp];
    [rewardImageView_txt_exp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@56);
        make.height.equalTo(@19);
        make.left.equalTo(expCountLabel.mas_right).offset(6);
        make.centerY.equalTo(expCountLabel);
    }];
    
    //宝石行
    UIImageView *rewardImageView_diamond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_monds"]];
    [rewardBaseInfoView addSubview:rewardImageView_diamond];
    [rewardImageView_diamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@18);
        make.height.equalTo(@18);
        make.top.equalTo(rewardImageView_exp.mas_bottom).offset(6);
        make.right.equalTo(rewardImageView_exp);
    }];
    
    UILabel *diamondCountLabel = [UILabel new];
    diamondCountLabel.textColor = COMMON_RED_COLOR;
    diamondCountLabel.text = @"5";
    diamondCountLabel.font = MOON_FONT_OF_SIZE(19);
    [diamondCountLabel sizeToFit];
    [rewardBaseInfoView addSubview:diamondCountLabel];
    [diamondCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rewardImageView_diamond.mas_right).offset(6);
        make.centerY.equalTo(rewardImageView_diamond);
    }];
    
    UIImageView *rewardImageView_txt_diamond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_reward_mondstext"]];
    [rewardBaseInfoView addSubview:rewardImageView_txt_diamond];
    [rewardImageView_txt_diamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@38);
        make.height.equalTo(@19);
        make.left.equalTo(diamondCountLabel.mas_right).offset(6);
        make.centerY.equalTo(diamondCountLabel);
    }];
}


@end
