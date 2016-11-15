//
//  SKRankInQuestionTableViewCell.m
//  NineZeroProject
//
//  Created by SinLemon on 16/8/4.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKRankInQuestionTableViewCell.h"
#import "HTUIHeader.h"

@interface SKRankInQuestionTableViewCell()

@property (nonatomic, strong) UIView *orderBackView;
@property (nonatomic, strong) UIImageView *orderImageView;
@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nickName;

@end

@implementation SKRankInQuestionTableViewCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _orderBackView = [[UIView alloc] init];
        _orderBackView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_orderBackView];
        
        _orderImageView = [[UIImageView alloc] init];
        [_orderBackView addSubview:_orderImageView];
        
        _orderLabel = [[UILabel alloc] init];
        _orderLabel.font = MOON_FONT_OF_SIZE(18);
        _orderLabel.textColor = COMMON_PINK_COLOR;
        [_orderBackView addSubview:_orderLabel];
        
        _avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        [self.contentView addSubview:_avatar];
        
        _nickName = [[UILabel alloc] init];
        _nickName.textColor = [UIColor whiteColor];
        _nickName.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nickName];
    }
    return self;
}

- (void)setRanker:(HTRanker *)ranker {
    _ranker = ranker;
    if (ranker.rank == 1 || ranker.rank == 2 || ranker.rank == 3) {
        _orderImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_profile_leaderboard_no%ld", (unsigned long)ranker.rank]];
        [_orderImageView sizeToFit];
        _orderImageView.alpha = 1;
        _orderLabel.alpha = 0;
    } else {
        _orderImageView.alpha = 0;
        _orderLabel.alpha = 1;
        _orderLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)ranker.rank];
        [_orderLabel sizeToFit];
    }
    
    [_avatar sd_setImageWithURL:[NSURL URLWithString:ranker.user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    NSString *displayName = (ranker.area_name.length != 0) ? [NSString stringWithFormat:@"%@", ranker.user_name] : ranker.user_name;
    _nickName.text = displayName;
    [_nickName sizeToFit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _avatar.height = 56;
    _avatar.width = 56;
    _avatar.centerX = self.contentView.centerX-20;
    _avatar.centerY = self.contentView.centerY;
    _avatar.layer.cornerRadius = 28;
    _avatar.layer.masksToBounds = YES;
    
    _orderBackView.height = 33;
    _orderBackView.width = 38;
    _orderBackView.centerY = _avatar.centerY;
    _orderBackView.right = _avatar.left - 14;
    
    _orderImageView.left = 0;
    _orderImageView.centerY = _orderBackView.height/2;
    
    _orderLabel.size = CGSizeMake(39, 20);
    _orderLabel.left = 0;
    _orderLabel.centerY = _orderBackView.height/2;
    
    _nickName.left = _avatar.right + 10;
    _nickName.centerY = _avatar.centerY;
    
}

@end
