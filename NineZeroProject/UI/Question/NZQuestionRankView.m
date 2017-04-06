//
//  NZQuestionRankView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/6.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZQuestionRankView.h"
#import "HTUIHeader.h"

@implementation NZQuestionRankView

- (instancetype)initWithRankArray:(NSArray<SKUserInfo *> *)array {
    self = [super init];
    if (self) {
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzledetailpage_ranking"]];
        [self addSubview:titleImageView];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
        }];
    }
    return self;
}

@end
