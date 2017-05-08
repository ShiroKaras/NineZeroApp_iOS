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
            UIView *view;
            if (i==0) {
                view = [[UIView alloc] initWithFrame:CGRectMake(16, titleImageView.bottom+24, self.width-32, 40)];
            } else {
                view = [[UIView alloc] initWithFrame:CGRectMake(16, titleImageView.bottom+24+60+40*(i-1), self.width-32, 30)];
            }
            view.backgroundColor = COMMON_RED_COLOR;
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

@end
