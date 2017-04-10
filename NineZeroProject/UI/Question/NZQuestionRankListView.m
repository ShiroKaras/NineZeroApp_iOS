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
        self.viewHeight = 16+14+16+560;
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzledetailpage_ranking"]];
        [self addSubview:titleImageView];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
        }];
        
        for (int i=0; i<10; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 46+i*56, self.width-40, 40)];
            [self addSubview:view];
            
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
            
            UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_profile_photo_default"]];
            [view addSubview:avatarImageView];
            [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.centerY.equalTo(view);
                make.left.equalTo(view).offset(79);
            }];
            
            UILabel *userNameLabel = [UILabel new];
            userNameLabel.text = @"默认用户";
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
