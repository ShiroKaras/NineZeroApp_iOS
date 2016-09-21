//
//  HTProfileRankCell.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/2.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTProfileRankCell.h"
#import "HTUIHeader.h"

@interface HTProfileProgressView ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIColor *coverColor;
@end

@implementation HTProfileProgressView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor colorWithHex:0x232323];
        [self addSubview:_backView];
        
        _coverView = [[UIView alloc] init];
        [self addSubview:_coverView];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsLayout];
}

- (void)setCoverColor:(UIColor *)coverColor {
    _coverColor = coverColor;
    _coverView.backgroundColor = coverColor;
}

- (void)setBackColor:(UIColor *)backColor {
    _backView.backgroundColor = backColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _backView.layer.cornerRadius = 5.0f;
    _coverView.layer.cornerRadius = 5.0f;
    _backView.frame = CGRectMake(0, 0, self.width, self.height);
    _coverView.frame = CGRectMake(0, 0, self.width * MAX(0 ,MIN(_progress, 1)), self.height);
}

@end

@interface HTProfileRankCell ()
@property (nonatomic, strong) UIImageView *orderImageView;
@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UIImageView *coinImageView;
@property (nonatomic, strong) HTProfileProgressView *progressView;
@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UIView *separator;
@end

@implementation HTProfileRankCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _orderImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_orderImageView];
        
        _orderLabel = [[UILabel alloc] init];
        _orderLabel.font = MOON_FONT_OF_SIZE(18);
        _orderLabel.textColor = COMMON_PINK_COLOR;
        [self.contentView addSubview:_orderLabel];
        
        _avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        [self.contentView addSubview:_avatar];
        
        _nickName = [[UILabel alloc] init];
        _nickName.textColor = [UIColor whiteColor];
        _nickName.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nickName];
        
        _progressView = [[HTProfileProgressView alloc] init];
        [self.contentView addSubview:_progressView];
        
        _coinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_success_page_coin"]];
        [self.contentView addSubview:_coinImageView];
        
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.font = MOON_FONT_OF_SIZE(15);
        _coinLabel.textColor = COMMON_PINK_COLOR;
        [self.contentView addSubview:_coinLabel];
        
        _separator = [[UIView alloc] init];
        _separator.backgroundColor = COMMON_SEPARATOR_COLOR;
        [self.contentView addSubview:_separator];
    }
    return self;
}

- (void)setRanker:(HTRanker *)ranker {
    _ranker = ranker;
    if (ranker.rank == 1 || ranker.rank == 2 || ranker.rank == 3) {
        _orderImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_profile_leaderboard_no%ld", (unsigned long)ranker.rank]];
        [_orderImageView sizeToFit];
        _orderImageView.hidden = NO;
        _orderLabel.hidden = YES;
    } else {
        _orderLabel.hidden = NO;
        _orderImageView.hidden = YES;
        _orderLabel.text = ranker.rank>999? @"1K+":[NSString stringWithFormat:@"%ld", (unsigned long)ranker.rank];
        [_orderLabel sizeToFit];
    }

    [_avatar sd_setImageWithURL:[NSURL URLWithString:ranker.user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    NSString *displayName = (ranker.area_name.length != 0) ? [NSString stringWithFormat:@"%@", ranker.user_name] : ranker.user_name;
    _nickName.text = displayName;
    [_nickName sizeToFit];
    [_progressView setProgress:MIN(1.0, ranker.gold / 1500.0)];
    [_progressView setCoverColor:[self colorWithCoin:ranker.gold]];
    _coinLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)ranker.gold];
    _coinLabel.textColor = [self colorWithCoin:ranker.gold];
    [_coinLabel sizeToFit];
}

- (void)showWithMe:(BOOL)me {
    self.contentView.backgroundColor = (me) ? COMMON_TITLE_BG_COLOR : [UIColor blackColor];
    _nickName.textColor = (me) ? COMMON_GREEN_COLOR : [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _orderImageView.left = 10;
    _orderImageView.centerY = self.height / 2;
    _orderLabel.frame = CGRectMake(12, self.height / 2 - 10, 39, 20);
    _avatar.frame = CGRectMake(_orderLabel.right + 12, self.height / 2 - 28, 56, 56);
    _nickName.frame = CGRectMake(_avatar.right + 4, 20, 190, 15);
    _avatar.layer.cornerRadius = 28;
    _avatar.layer.masksToBounds = YES;
    CGFloat progressView = 130 + SCREEN_WIDTH - 320;
    _progressView.frame = CGRectMake(_avatar.right + 4, _nickName.bottom + 8, progressView, 15);
    _coinImageView.left = _progressView.right + 3;
    _coinImageView.centerY = _progressView.centerY;
    _coinLabel.left = _coinImageView.right + 2;
    _coinLabel.centerY = _progressView.centerY;
    
    _separator.frame = CGRectMake(0, self.height - 1, SCREEN_WIDTH, 1);
}

- (UIColor *)colorWithCoin:(NSUInteger)coin {
    UIColor *color = COMMON_PINK_COLOR;
    if (coin < 100) {
        color = [UIColor colorWithHex:0x24ddb2];
    } else if (coin >= 100 && coin < 300) {
        color = [UIColor colorWithHex:0xffbd00];
    } else if (coin >= 300 && coin < 600) {
        color = [UIColor colorWithHex:0xed203b];
    } else if (coin >= 600 && coin < 1000) {
        color = [UIColor colorWithHex:0xd40e88];
    } else if (coin >= 1000 && coin <= 1500) {
        color = [UIColor colorWithHex:0x770ae2];
    }
    return color;
}

@end
