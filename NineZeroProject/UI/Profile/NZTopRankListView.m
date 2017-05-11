//
//  NZTopRankListView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/8.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZTopRankListView.h"
#import "HTUIHeader.h"

@implementation NZTopRankListView

- (instancetype)initWithFrame:(CGRect)frame withRankers:(NSArray<SKRanker *> *)rankers {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COMMON_BG_COLOR;
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userpage_ranking"]];
        [self addSubview:titleImageView];
        titleImageView.left = 16;
        titleImageView.top = 16;
        
        for (int i=0; i<11; i++) {
            NZRankCellView *view;
            if (i==0) {
                view = [[NZRankCellView alloc] initWithFrame:CGRectMake(16, titleImageView.bottom+24, self.width-32, ROUND_HEIGHT_FLOAT(40))];
            } else {
                view = [[NZRankCellView alloc] initWithFrame:CGRectMake(16, titleImageView.bottom+24+60+ROUND_HEIGHT_FLOAT(40)*(i-1), self.width-32, ROUND_HEIGHT_FLOAT(30))];
            }
            view.tag = 100+i;
            [self addSubview:view];
        }
        
        
        
        //猎人榜
        UIButton *rank1 = [UIButton new];
        [rank1 addTarget:self action:@selector(didClickHunterButton:) forControlEvents:UIControlEventTouchUpInside];
        [rank1 setTitle:@"猎人榜" forState:UIControlStateNormal];
        [rank1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rank1.titleLabel.font = PINGFANG_FONT_OF_SIZE(12);
        rank1.width = 60;
        rank1.height = 30;
        rank1.right = self.right-16;
        rank1.centerY = titleImageView.centerY;
        [self addSubview:rank1];
        
        //解谜榜
        UIButton *rank2 = [UIButton new];
        [self addSubview:rank2];
        [rank2 setTitle:@"解谜榜" forState:UIControlStateNormal];
        [rank2 setTitleColor:COMMON_GREEN_COLOR forState:UIControlStateNormal];
        rank2.titleLabel.font = PINGFANG_FONT_OF_SIZE(12);
        rank2.width = 60;
        rank2.height = 30;
        rank2.right = rank1.left-8;
        rank2.centerY = titleImageView.centerY;
        self.height = [self viewWithTag:110].bottom+16;
    }
    return self;
}

- (void)didClickHunterButton:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(didClickHunterRankButton)]) {
        [_delegate didClickHunterRankButton];
    }
}

- (void)setRankerArray:(NSArray<SKRanker *> *)rankerArray {
    _rankerArray = rankerArray;
    for (int i=0; i<11; i++) {
        ((NZRankCellView*)[self viewWithTag:100+i]).rankOrderLabel.text = [NSString stringWithFormat:@"%ld", rankerArray[i].rank];
        ((NZRankCellView*)[self viewWithTag:100+i]).usernameLabel.text = rankerArray[i].user_name;
        [((NZRankCellView*)[self viewWithTag:100+i]).avatarImageView sd_setImageWithURL:[NSURL URLWithString:rankerArray[i].user_avatar] placeholderImage:[UIImage imageNamed:@""]];
        ((NZRankCellView*)[self viewWithTag:100+i]).expLabel.text = rankerArray[i].user_experience_value;
    }
}

@end



@implementation NZRankCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _rankOrderLabel = [UILabel new];
        _rankOrderLabel.text = @"99";
        _rankOrderLabel.textColor = COMMON_PINK_COLOR;
        _rankOrderLabel.font = MOON_FONT_OF_SIZE(14);
        [self addSubview:_rankOrderLabel];
        [_rankOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
        _avatarImageView.layer.cornerRadius = frame.size.height/2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_avatarImageView];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.width.equalTo(self.mas_height);
            make.centerX.equalTo(self.mas_left).offset(72);
            make.centerY.equalTo(self);
        }];
        
        _usernameLabel = [UILabel new];
        _usernameLabel.text = @"我是一个零仔";
        _usernameLabel.textColor = [UIColor colorWithHex:0x3c3c3c];
        _usernameLabel.font = PINGFANG_FONT_OF_SIZE(10);
        [self addSubview:_usernameLabel];
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).offset(112);
        }];
        
        UIImageView *expImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzleranking_usetop"]];
        [self addSubview:expImageView];
        [expImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self.mas_right).offset(-43-8);
        }];
        
        _expLabel = [UILabel new];
        _expLabel.text = @"99999";
        _expLabel.textColor = [UIColor colorWithHex:0x3c3c3c];
        _expLabel.font = MOON_FONT_OF_SIZE(10);
        [self addSubview:_expLabel];
        [_expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(expImageView.mas_right).offset(3);
        }];
    }
    return self;
}

@end
