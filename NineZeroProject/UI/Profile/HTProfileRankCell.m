//
//  HTProfileRankCell.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/2.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTProfileRankCell.h"
#import "HTUIHeader.h"

#define ScaleToScreen ((SCREEN_WIDTH-32)/288.)
#define PADDING 16

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

@property (nonatomic, strong) UIView *backView;

//TOP
@property (nonatomic, strong) UIView *topBackView;
@property (nonatomic, strong) UIImageView *topBackImageView;

@property (nonatomic, strong) UIImageView *ranker_1_Avatar;
@property (nonatomic, strong) UIImageView *ranker_2_Avatar;
@property (nonatomic, strong) UIImageView *ranker_3_Avatar;
@property (nonatomic, strong) UILabel   *ranker_1_NameLabel;
@property (nonatomic, strong) UILabel   *ranker_2_NameLabel;
@property (nonatomic, strong) UILabel   *ranker_3_NameLabel;
@property (nonatomic, strong) UIImageView   *ranker_1_Image;
@property (nonatomic, strong) UIImageView   *ranker_2_Image;
@property (nonatomic, strong) UIImageView   *ranker_3_Image;
@property (nonatomic, strong) UILabel   *ranker_1_CoinLabel;
@property (nonatomic, strong) UILabel   *ranker_2_CoinLabel;
@property (nonatomic, strong) UILabel   *ranker_3_CoinLabel;
@property (nonatomic, strong) UIImageView *ranker_1_CoinImage;
@property (nonatomic, strong) UIImageView *ranker_2_CoinImage;
@property (nonatomic, strong) UIImageView *ranker_3_CoinImage;
@end

@implementation HTProfileRankCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor colorWithHex:0x1F1F1F];
        [self.contentView addSubview:_backView];
        
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
        _nickName.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [self.contentView addSubview:_nickName];
        
        _coinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_success_page_coin"]];
        [self.contentView addSubview:_coinImageView];
        
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.font = MOON_FONT_OF_SIZE(15);
        [self.contentView addSubview:_coinLabel];
        
        _separator = [[UIView alloc] init];
        _separator.backgroundColor = [UIColor colorWithHex:0x303030];
        [self.contentView addSubview:_separator];
        
        //TOP
        _topBackView = [[UIView alloc] init];
        _topBackView.layer.masksToBounds = YES;
        _topBackView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_topBackView];
        
        _topBackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_rankpage_top_season2"]];
        _topBackImageView.layer.masksToBounds = YES;
        _topBackImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_topBackView addSubview:_topBackImageView];
        
        //头像
        _ranker_1_Avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        _ranker_1_Avatar.contentMode = UIViewContentModeScaleAspectFit;
        [_topBackView addSubview:_ranker_1_Avatar];
        
        _ranker_2_Avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        _ranker_2_Avatar.contentMode = UIViewContentModeScaleAspectFit;
        [_topBackView addSubview:_ranker_2_Avatar];
        
        _ranker_3_Avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        _ranker_3_Avatar.contentMode = UIViewContentModeScaleAspectFit;
        [_topBackView addSubview:_ranker_3_Avatar];
        
        //勋章
        _ranker_1_Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_rankpage_top1"]];
        _ranker_1_Image.contentMode = UIViewContentModeScaleAspectFit;
        [_topBackView addSubview:_ranker_1_Image];
        
        _ranker_2_Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_rankpage_top2"]];
        _ranker_2_Image.contentMode = UIViewContentModeScaleAspectFit;
        [_topBackView addSubview:_ranker_2_Image];
        
        _ranker_3_Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_rankpage_top3"]];
        _ranker_3_Image.contentMode = UIViewContentModeScaleAspectFit;
        [_topBackView addSubview:_ranker_3_Image];
        
        //昵称
        _ranker_1_NameLabel = [[UILabel alloc] init];
        _ranker_1_NameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _ranker_1_NameLabel.textColor = [UIColor whiteColor];
        _ranker_1_NameLabel.textAlignment = NSTextAlignmentCenter;
        [_topBackView addSubview:_ranker_1_NameLabel];
        
        _ranker_2_NameLabel = [[UILabel alloc] init];
        _ranker_2_NameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _ranker_2_NameLabel.textColor = [UIColor whiteColor];
        _ranker_2_NameLabel.textAlignment = NSTextAlignmentCenter;
        [_topBackView addSubview:_ranker_2_NameLabel];
        
        _ranker_3_NameLabel = [[UILabel alloc] init];
        _ranker_3_NameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _ranker_3_NameLabel.textColor = [UIColor whiteColor];
        _ranker_3_NameLabel.textAlignment = NSTextAlignmentCenter;
        [_topBackView addSubview:_ranker_3_NameLabel];
        
        //金币
        _ranker_1_CoinLabel = [[UILabel alloc] init];
        _ranker_1_CoinLabel.font = MOON_FONT_OF_SIZE(15);
        _ranker_1_CoinLabel.textColor = [UIColor colorWithHex:0xFFBF26];
        [_topBackView addSubview:_ranker_1_CoinLabel];
        
        _ranker_1_CoinLabel = [[UILabel alloc] init];
        _ranker_1_CoinLabel.font = MOON_FONT_OF_SIZE(15);
        _ranker_1_CoinLabel.textColor = [UIColor colorWithHex:0xFFBF26];
        [_topBackView addSubview:_ranker_1_CoinLabel];
        
        _ranker_2_CoinLabel = [[UILabel alloc] init];
        _ranker_2_CoinLabel.font = MOON_FONT_OF_SIZE(15);
        _ranker_2_CoinLabel.textColor = [UIColor colorWithHex:0xFFBF26];
        [_topBackView addSubview:_ranker_2_CoinLabel];
        
        _ranker_3_CoinLabel = [[UILabel alloc] init];
        _ranker_3_CoinLabel.font = MOON_FONT_OF_SIZE(15);
        _ranker_3_CoinLabel.textColor = [UIColor colorWithHex:0xFFBF26];
        [_topBackView addSubview:_ranker_3_CoinLabel];
        
        _ranker_1_CoinImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_success_page_coin"]];
        [_ranker_1_CoinImage sizeToFit];
        [_topBackView addSubview:_ranker_1_CoinImage];
        
        _ranker_2_CoinImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_success_page_coin"]];
        [_ranker_2_CoinImage sizeToFit];
        [_topBackView addSubview:_ranker_2_CoinImage];
        
        _ranker_3_CoinImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_success_page_coin"]];
        [_ranker_3_CoinImage sizeToFit];
        [_topBackView addSubview:_ranker_3_CoinImage];
    }
    return self;
}

- (void)setRanker:(SKRanker *)ranker {
    _topBackView.hidden = YES;
    _ranker = ranker;

    _orderLabel.hidden = NO;
    _orderImageView.hidden = YES;
    _orderLabel.text = ranker.rank>999? @"1K+":[NSString stringWithFormat:@"%ld", (unsigned long)ranker.rank];
    [_orderLabel sizeToFit];

    [_avatar sd_setImageWithURL:[NSURL URLWithString:ranker.user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    NSString *displayName = (ranker.area_name.length != 0) ? [NSString stringWithFormat:@"%@", ranker.user_name] : ranker.user_name;
    _nickName.text = displayName;
    [_nickName sizeToFit];
    _coinLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)ranker.gold];
    _coinLabel.textColor = [self colorWithCoin:[ranker.gold integerValue]];
    [_coinLabel sizeToFit];
}

- (void)setTopThreeRankers:(NSArray<HTRanker *> *)topThreeRankers {
    _topBackView.hidden = NO;
    
    [_ranker_1_Avatar sd_setImageWithURL:[NSURL URLWithString:topThreeRankers[0].user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    [_ranker_2_Avatar sd_setImageWithURL:[NSURL URLWithString:topThreeRankers[1].user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    [_ranker_3_Avatar sd_setImageWithURL:[NSURL URLWithString:topThreeRankers[2].user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    
    _ranker_1_NameLabel.text = topThreeRankers[0].user_name;
    _ranker_2_NameLabel.text = topThreeRankers[1].user_name;
    _ranker_3_NameLabel.text = topThreeRankers[2].user_name;
    [_ranker_1_NameLabel sizeToFit];
    [_ranker_2_NameLabel sizeToFit];
    [_ranker_3_NameLabel sizeToFit];
    
    _ranker_1_CoinLabel.text = [NSString stringWithFormat:@"%lu",topThreeRankers[0].gold];
    _ranker_2_CoinLabel.text = [NSString stringWithFormat:@"%lu",topThreeRankers[1].gold];
    _ranker_3_CoinLabel.text = [NSString stringWithFormat:@"%lu",topThreeRankers[2].gold];
    [_ranker_1_CoinLabel sizeToFit];
    [_ranker_2_CoinLabel sizeToFit];
    [_ranker_3_CoinLabel sizeToFit];
}

- (void)showWithMe:(BOOL)me {
    _backView.backgroundColor = (me) ? COMMON_GREEN_COLOR : [UIColor colorWithHex:0x1F1F1F];
    _orderLabel.textColor = (me) ? [UIColor whiteColor] : COMMON_PINK_COLOR;
    _coinLabel.textColor = (me) ? [UIColor whiteColor] : [UIColor colorWithHex:0xED203B];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _backView.frame = CGRectMake(PADDING, 0, SCREEN_WIDTH-PADDING*2, self.height);
    
    _orderImageView.left = PADDING;
    _orderImageView.centerY = self.height / 2;
    _orderLabel.frame = CGRectMake(PADDING+20, self.height / 2 - 10, 39, 20);
    _avatar.frame = CGRectMake(PADDING +67, self.height / 2 - 28, 56, 56);
    _avatar.layer.cornerRadius = 28;
    _avatar.layer.masksToBounds = YES;
    _nickName.frame = CGRectMake(_avatar.right + 16, 18, 190, 15);
    _coinImageView.left = _avatar.right + 16;
    _coinImageView.top = _nickName.bottom +8;
    _coinLabel.left = _coinImageView.right + 6;
    _coinLabel.centerY = _coinImageView.centerY;
    
    _separator.frame = CGRectMake(PADDING, self.height - 1, SCREEN_WIDTH-PADDING*2, 1);
    
    //TOP
    _topBackView.left = 0;
    _topBackView.top = 0;
    _topBackView.width = SCREEN_WIDTH;
    _topBackView.height = 281.*ScaleToScreen;
    
    _topBackImageView.centerX = _topBackView.centerX;
    _topBackImageView.top = _topBackView.top;
    _topBackImageView.width = SCREEN_WIDTH-PADDING*2;
    _topBackImageView.height = 281.*ScaleToScreen;
    
    _ranker_1_Avatar.width = 72*ScaleToScreen;
    _ranker_1_Avatar.height = 72*ScaleToScreen;
    _ranker_1_Avatar.centerX = _topBackView.centerX;
    _ranker_1_Avatar.bottom = _topBackView.bottom - 75*ScaleToScreen;
    _ranker_1_Avatar.layer.cornerRadius = 72*ScaleToScreen/2;
    _ranker_1_Avatar.layer.masksToBounds = YES;
    
    _ranker_2_Avatar.width = 56*ScaleToScreen;
    _ranker_2_Avatar.height = 56*ScaleToScreen;
    _ranker_2_Avatar.centerX = _topBackImageView.left + _topBackImageView.width/6;
    _ranker_2_Avatar.bottom = _ranker_1_Avatar.bottom;
    _ranker_2_Avatar.layer.cornerRadius = 56*ScaleToScreen/2;
    _ranker_2_Avatar.layer.masksToBounds = YES;
    
    _ranker_3_Avatar.width = 56*ScaleToScreen;
    _ranker_3_Avatar.height = 56*ScaleToScreen;
    _ranker_3_Avatar.centerX = _topBackImageView.right - _topBackImageView.width/6;
    _ranker_3_Avatar.bottom = _ranker_1_Avatar.bottom;
    _ranker_3_Avatar.layer.cornerRadius = 56*ScaleToScreen/2;
    _ranker_3_Avatar.layer.masksToBounds = YES;

    _ranker_1_Image.right = _ranker_1_Avatar.right;
    _ranker_1_Image.top = _ranker_1_Avatar.bottom - 21;
    
    _ranker_2_Image.right = _ranker_2_Avatar.right;
    _ranker_2_Image.top = _ranker_2_Avatar.bottom - 21;
    
    _ranker_3_Image.right = _ranker_3_Avatar.right;
    _ranker_3_Image.top = _ranker_3_Avatar.bottom - 21;
    
    _ranker_1_NameLabel.top = _ranker_1_Avatar.bottom+14;
    _ranker_1_NameLabel.width = _ranker_1_Avatar.width;
    _ranker_1_NameLabel.centerX = _topBackView.centerX;
    
    _ranker_2_NameLabel.top = _ranker_1_Avatar.bottom+14;
    _ranker_2_NameLabel.width = _ranker_2_Avatar.width;
    _ranker_2_NameLabel.centerX = _ranker_2_Avatar.centerX;
    
    _ranker_3_NameLabel.top = _ranker_1_Avatar.bottom+14;
    _ranker_3_NameLabel.width = _ranker_3_Avatar.width;
    _ranker_3_NameLabel.centerX = _ranker_3_Avatar.centerX;
    
    _ranker_1_CoinLabel.top = _ranker_1_NameLabel.bottom +16;
    _ranker_1_CoinLabel.centerX = _ranker_1_Avatar.centerX +12;
    _ranker_2_CoinLabel.top = _ranker_1_NameLabel.bottom +16;
    _ranker_2_CoinLabel.centerX = _ranker_2_Avatar.centerX +12;
    _ranker_3_CoinLabel.top = _ranker_1_NameLabel.bottom +16;
    _ranker_3_CoinLabel.centerX = _ranker_3_Avatar.centerX +12;
    
    _ranker_1_CoinImage.centerY = _ranker_1_CoinLabel.centerY;
    _ranker_1_CoinImage.right = _ranker_1_CoinLabel.left -6;
    _ranker_2_CoinImage.centerY = _ranker_2_CoinLabel.centerY;
    _ranker_2_CoinImage.right = _ranker_2_CoinLabel.left -6;
    _ranker_3_CoinImage.centerY = _ranker_3_CoinLabel.centerY;
    _ranker_3_CoinImage.right = _ranker_3_CoinLabel.left -6;
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
