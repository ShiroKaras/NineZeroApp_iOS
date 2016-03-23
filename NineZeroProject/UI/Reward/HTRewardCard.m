//
//  HTRewardCard.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/25.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTRewardCard.h"
#import "HTUIHeader.h"
#import "NSDate+Utility.h"

@interface HTRewardCard ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *ddlLabel;
@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UILabel *exchangedCode;
@end

@implementation HTRewardCard
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, [self intrinsicContentSize].width, [self intrinsicContentSize].height)]) {
        self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_voucher_bg"]];
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.bgImageView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.text = @"草间弥生上海个展门票";
        [self addSubview:self.titleLabel];
        [self.titleLabel sizeToFit];
        
        self.ddlLabel = [[UILabel alloc] init];
        self.ddlLabel.font = [UIFont systemFontOfSize:11];
        self.ddlLabel.text = @"有效期至2015-12-31";
        self.ddlLabel.textColor = [UIColor colorWithHex:0x474747];
        [self addSubview:self.ddlLabel];
        [self.ddlLabel sizeToFit];
        
        self.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reward_logo_demo"]];
        [self addSubview:self.logo];
        
        self.exchangedCode = [[UILabel alloc] init];
        self.exchangedCode.text = @"唯一兑换码：1234567890";
        self.exchangedCode.font = [UIFont systemFontOfSize:11];
        self.exchangedCode.textColor = [UIColor whiteColor];
        self.exchangedCode.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.exchangedCode];
        [self.exchangedCode sizeToFit];
    }
    return self;
}

- (void)showExchangedCode:(BOOL)show {
    self.exchangedCode.hidden = !show;
}

- (void)setReward:(HTReward *)reward {
    [self.logo sd_setImageWithURL:[NSURL URLWithString:reward.pic] placeholderImage:[UIImage imageNamed:@"img_voucher_cover_default"]];
    self.titleLabel.text = reward.title;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:reward.expire_time];
    self.ddlLabel.text = [NSString stringWithFormat:@"有效期至%04ld-%02ld-%02ld", [date year], [date month], [date day]];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(SCREEN_WIDTH - 40, 170);
}

- (void)layoutSubviews {
    self.titleLabel.frame = CGRectMake(8, 14, self.width, self.titleLabel.height);
    self.ddlLabel.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 5, self.width, self.ddlLabel.height);
    self.logo.frame = CGRectMake(0, self.ddlLabel.bottom + 4, self.width, 85);
    self.bgImageView.frame = CGRectMake(0, 0, self.width, self.logo.bottom + 5);
    self.exchangedCode.frame = CGRectMake(0, self.logo.bottom + 13, self.width, 20);
}

@end