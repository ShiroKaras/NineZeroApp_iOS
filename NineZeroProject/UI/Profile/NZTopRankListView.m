//
//  NZTopRankListView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/8.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZTopRankListView.h"
#import "HTUIHeader.h"

@interface NZTopRankListView ()
@property (nonatomic, strong) UIButton *rankListButton;
@property (nonatomic, strong) UIButton *hunterListButton;
@end

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
                view.usernameLabel.textColor = COMMON_GREEN_COLOR;
                view.usernameLabel.font = PINGFANG_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(12));
                view.expImageView.image = [UIImage imageNamed:@"img_puzzleranking_mytop"];
                view.expLabel.textColor = COMMON_GREEN_COLOR;
            } else {
                view = [[NZRankCellView alloc] initWithFrame:CGRectMake(16, titleImageView.bottom+24+60+ROUND_HEIGHT_FLOAT(40)*(i-1), self.width-32, ROUND_HEIGHT_FLOAT(30))];
            }
            view.tag = 100+i;
            [self addSubview:view];
            
            _viewHeight = view.bottom+16;
        }
        
        //猎人榜
        _hunterListButton = [UIButton new];
        [_hunterListButton addTarget:self action:@selector(didClickHunterButton:) forControlEvents:UIControlEventTouchUpInside];
        [_hunterListButton setTitle:@"猎人榜" forState:UIControlStateNormal];
        [_hunterListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _hunterListButton.titleLabel.font = PINGFANG_FONT_OF_SIZE(12);
        _hunterListButton.width = 60;
        _hunterListButton.height = 30;
        _hunterListButton.right = self.right-16;
        _hunterListButton.centerY = titleImageView.centerY;
        [self addSubview:_hunterListButton];
        
        //解谜榜
        _rankListButton = [UIButton new];
        [_rankListButton addTarget:self action:@selector(didClickRankListButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rankListButton];
        [_rankListButton setTitle:@"解谜榜" forState:UIControlStateNormal];
        [_rankListButton setTitleColor:COMMON_GREEN_COLOR forState:UIControlStateNormal];
        _rankListButton.titleLabel.font = PINGFANG_FONT_OF_SIZE(12);
        _rankListButton.width = 60;
        _rankListButton.height = 30;
        _rankListButton.right = _hunterListButton.left-8;
        _rankListButton.centerY = titleImageView.centerY;
        
    }
    return self;
}

- (void)setRankerArray:(NSArray<SKRanker *> *)rankerArray {
    for (int i=0; i<11; i++) {
        if (i<rankerArray.count) {
            ((NZRankCellView*)[self viewWithTag:100+i]).hidden = NO;
            ((NZRankCellView*)[self viewWithTag:100+i]).rankOrderLabel.text = [NSString stringWithFormat:@"%ld", rankerArray[i].rank];
            ((NZRankCellView*)[self viewWithTag:100+i]).usernameLabel.text = rankerArray[i].user_name;
            [((NZRankCellView*)[self viewWithTag:100+i]).avatarImageView sd_setImageWithURL:[NSURL URLWithString:rankerArray[i].user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
            ((NZRankCellView*)[self viewWithTag:100+i]).expLabel.text = rankerArray[i].user_experience_value;
        } else  {
            ((NZRankCellView*)[self viewWithTag:100+i]).hidden = YES;
        }
    }
}

#pragma - mark Delegate

- (void)didClickRankListButton:(UIButton *)sender {
    [_rankListButton setTitleColor:COMMON_GREEN_COLOR forState:UIControlStateNormal];
    [_hunterListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ([_delegate respondsToSelector:@selector(didClickRankButton)]) {
        [_delegate didClickRankButton];
    }
}

- (void)didClickHunterButton:(UIButton *)sender {
    [_rankListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_hunterListButton setTitleColor:COMMON_GREEN_COLOR forState:UIControlStateNormal];
    if ([_delegate respondsToSelector:@selector(didClickHunterRankButton)]) {
        [_delegate didClickHunterRankButton];
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
        _rankOrderLabel.font = MOON_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(14));
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
        _usernameLabel.font = PINGFANG_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(10));
        [self addSubview:_usernameLabel];
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).offset(112);
        }];
        
        _expImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzleranking_usetop"]];
        [self addSubview:_expImageView];
        [_expImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self.mas_right).offset(-43-8);
        }];
        
        _expLabel = [UILabel new];
        _expLabel.text = @"99999";
        _expLabel.textColor = [UIColor colorWithHex:0x3c3c3c];
        _expLabel.font = MOON_FONT_OF_SIZE(ROUND_WIDTH_FLOAT(10));
        [self addSubview:_expLabel];
        [_expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_expImageView.mas_right).offset(3);
        }];
    }
    return self;
}

@end
