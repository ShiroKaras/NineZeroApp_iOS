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
@property (nonatomic, strong) UILabel       *rankOrderLabel;
@property (nonatomic, strong) UIImageView   *avatarImageView;
@property (nonatomic, strong) UILabel       *usernameLabel;
@property (nonatomic, strong) UILabel       *expLabel;
@end

@implementation NZRankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = COMMON_BG_COLOR;
        
        UIView *backView = [UIView new];
        backView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@16);
            make.right.equalTo(self.mas_right).offset(-16);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(@30);
        }];
        
        _rankOrderLabel = [UILabel new];
        _rankOrderLabel.text = @"99";
        _rankOrderLabel.textColor = COMMON_PINK_COLOR;
        _rankOrderLabel.font = MOON_FONT_OF_SIZE(14);
        [backView addSubview:_rankOrderLabel];
        [_rankOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView);
            make.centerY.equalTo(backView);
        }];

        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        _avatarImageView.layer.cornerRadius = 15;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [backView addSubview:_avatarImageView];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerX.equalTo(backView.mas_left).offset(72);
            make.centerY.equalTo(backView);
        }];
        
        _usernameLabel = [UILabel new];
        _usernameLabel.text = @"我是一个零仔";
        _usernameLabel.textColor = [UIColor colorWithHex:0x3c3c3c];
        _usernameLabel.font = PINGFANG_FONT_OF_SIZE(10);
        [backView addSubview:_usernameLabel];
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.left.equalTo(backView.mas_left).offset(102);
        }];
        
        UIImageView *expImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzleranking_usetop"]];
        [backView addSubview:expImageView];
        [expImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.centerX.equalTo(backView.mas_right).offset(-43-8);
        }];
        
        _expLabel = [UILabel new];
        _expLabel.text = @"99999";
        _expLabel.textColor = [UIColor colorWithHex:0x3c3c3c];
        _expLabel.font = MOON_FONT_OF_SIZE(10);
        [backView addSubview:_expLabel];
        [_expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backView);
            make.left.equalTo(expImageView.mas_right).offset(3);
        }];
        
        [self layoutIfNeeded];
        self.cellHeight = 40;
    }
    return self;
}


@end
