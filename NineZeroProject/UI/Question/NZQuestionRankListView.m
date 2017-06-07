//
//  NZQuestionRankListView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/10.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZQuestionRankListView.h"
#import "HTUIHeader.h"

@implementation NZQuestionRankListView

- (instancetype)initWithFrame:(CGRect)frame rankArray:(NSArray<SKUserInfo *> *)array{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COMMON_BG_COLOR;
        
        _rankScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _rankScrollView.bounces = NO;
        [self addSubview:_rankScrollView];
        
        self.viewHeight = 16+14+16+560;
        _rankScrollView.contentSize = CGSizeMake(frame.size.width, self.viewHeight);
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzledetailpage_ranking"]];
        [_rankScrollView addSubview:titleImageView];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
        }];
        
        for (int i=0; i<array.count; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 46+i*56, self.width-40, 40)];
            view.backgroundColor = [UIColor clearColor];
            [_rankScrollView addSubview:view];
            
            UILabel *rankLabel = [UILabel new];
            rankLabel.text = [NSString stringWithFormat:@"%d",i+1];
            rankLabel.textColor = COMMON_PINK_COLOR;
            rankLabel.font = MOON_FONT_OF_SIZE(16);
            [rankLabel sizeToFit];
            [view addSubview:rankLabel];
            [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.left.equalTo(view);
            }];
            
            UIImageView *avatarImageView = [[UIImageView alloc] init];
            avatarImageView.layer.cornerRadius = 20;
            avatarImageView.layer.masksToBounds = YES;
            [avatarImageView sd_setImageWithURL:[NSURL URLWithString:array[i].user_avatar] placeholderImage:[UIImage imageNamed:@"img_profile_photo_default"]];
            [view addSubview:avatarImageView];
            [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.centerY.equalTo(view);
                make.left.equalTo(view).offset(79);
            }];
            
            UILabel *userNameLabel = [UILabel new];
            userNameLabel.text = array[i].user_name;
            userNameLabel.textColor = [UIColor whiteColor];
            userNameLabel.font = PINGFANG_FONT_OF_SIZE(12);
            [userNameLabel sizeToFit];
            [view addSubview:userNameLabel];
            [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(view);
                make.left.equalTo(avatarImageView.mas_right).offset(9);
            }];
        }
    }
    return self;
}

@end
