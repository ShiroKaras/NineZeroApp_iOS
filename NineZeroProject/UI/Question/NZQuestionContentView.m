//
//  NZQuestionContentView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/6.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZQuestionContentView.h"
#import "HTUIHeader.h"

@implementation NZQuestionContentView

- (instancetype)initWithFrame:(CGRect)frame content:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzledetailpage_story"]];
        [self addSubview:titleImageView];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
        }];
        
        UILabel *contentLabel = [UILabel new];
        contentLabel.text = content;
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.font = PINGFANG_FONT_OF_SIZE(12);
        contentLabel.numberOfLines = 0;
        [contentLabel sizeToFit];
        [self addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@16);
            make.right.equalTo(self).offset(-16);
            make.top.equalTo(titleImageView.mas_bottom).offset(16);
        }];
        
        [self layoutIfNeeded];
        self.viewHeight = contentLabel.bottom;
    }
    return self;
}

@end
