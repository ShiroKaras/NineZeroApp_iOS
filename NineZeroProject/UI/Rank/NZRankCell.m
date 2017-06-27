//
//  NZRankCell.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/30.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZRankCell.h"
#import "HTUIHeader.h"

@interface NZRankCell()
@property (nonatomic, strong) UIView        *backView;
@property (nonatomic, strong) UILabel       *rankOrderLabel;
@property (nonatomic, strong) UIImageView   *avatarImageView;
@property (nonatomic, strong) UILabel       *usernameLabel;
@property (nonatomic, strong) UIImageView   *expImageView;
@property (nonatomic, strong) UILabel       *expLabel;
@end

@implementation NZRankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COMMON_BG_COLOR;
        
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@16);
            make.right.equalTo(self.mas_right).offset(-16);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(ROUND_HEIGHT(30));
        }];
        
        _rankOrderLabel = [UILabel new];
        _rankOrderLabel.text = @"99";
        _rankOrderLabel.textColor = COMMON_PINK_COLOR;
        _rankOrderLabel.font = MOON_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(14));
        [_backView addSubview:_rankOrderLabel];
        [_rankOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView);
            make.centerY.equalTo(_backView);
        }];
        
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        _avatarImageView.layer.cornerRadius = 15;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_backView addSubview:_avatarImageView];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_backView.mas_height);
            make.width.equalTo(_backView.mas_height);
            make.centerX.equalTo(_backView.mas_left).offset(72);
            make.centerY.equalTo(_backView);
        }];
        
        _usernameLabel = [UILabel new];
        _usernameLabel.text = @"我是一个零仔";
        _usernameLabel.textColor = [UIColor colorWithHex:0x3c3c3c];
        _usernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        [_backView addSubview:_usernameLabel];
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView);
            make.left.equalTo(_backView.mas_left).offset(112);
        }];
        
        _expImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzleranking_usetop"]];
        [_backView addSubview:_expImageView];
        [_expImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView);
            make.centerX.equalTo(_backView.mas_right).offset(-43-8);
        }];
        
        _expLabel = [UILabel new];
        _expLabel.text = @"99999";
        _expLabel.textColor = [UIColor colorWithHex:0x3c3c3c];
        _expLabel.font = MOON_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(10));
        [_backView addSubview:_expLabel];
        [_expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_backView);
            make.left.equalTo(_expImageView.mas_right).offset(3);
        }];
        
        [self layoutIfNeeded];
        self.cellHeight = ROUND_HEIGHT_FLOAT(40);
    }
    return self;
}

- (void)setRanker:(SKRanker *)ranker {
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:ranker.user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
    _rankOrderLabel.text = ranker.rank>999?@"1K+":[NSString stringWithFormat:@"%ld",ranker.rank];
    _usernameLabel.text = ranker.user_name;
    _expLabel.text = ranker.user_experience_value;
}

- (void)setRanker:(SKRanker *)ranker isMe:(BOOL)isMe {
    if (isMe) {
        [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@16);
            make.right.equalTo(self.mas_right).offset(-16);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(ROUND_HEIGHT(50));
        }];
        _avatarImageView.layer.cornerRadius = ROUND_HEIGHT_FLOAT(25);
        
        _usernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(12);
        _usernameLabel.textColor = COMMON_GREEN_COLOR;
        
        _expImageView.image = [UIImage imageNamed:@"img_puzzleranking_mytop"];
        
        _expLabel.font = MOON_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(12));
        _expLabel.textColor = COMMON_GREEN_COLOR;
        
        [self setRanker:ranker];
        _cellHeight = ROUND_HEIGHT_FLOAT(60);
    } else {
        [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@16);
            make.right.equalTo(self.mas_right).offset(-16);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(ROUND_HEIGHT(30));
        }];
        _avatarImageView.layer.cornerRadius = ROUND_HEIGHT_FLOAT(15);
        
        _usernameLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(10);
        _usernameLabel.textColor = COMMON_TEXT_3_COLOR;
        
        _expImageView.image = [UIImage imageNamed:@"img_puzzleranking_usetop"];
        
        _expLabel.font = MOON_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(10));
        _expLabel.textColor = COMMON_TEXT_3_COLOR;
        
        [self setRanker:ranker];
        _cellHeight = ROUND_HEIGHT_FLOAT(40);
    }
}

- (void)setRanker:(SKRanker *)ranker isMe:(BOOL)isMe withType:(NZRankListType)type {
    if (type == NZRankListTypeQuestion) {
        [self setRanker:ranker isMe:isMe];
    } else if (type == NZRankListTypeHunter) {
        [self setRanker:ranker isMe:isMe];
        if (isMe) {
            _expImageView.image = [UIImage imageNamed:@"img_hunterranking_mytime"];
        } else {
            _expImageView.image = [UIImage imageNamed:@"img_hunterranking_usertime"];
        }
        _expLabel.text = [ranker.total_coop_time stringByAppendingString:@"H"];
    }
}

@end
