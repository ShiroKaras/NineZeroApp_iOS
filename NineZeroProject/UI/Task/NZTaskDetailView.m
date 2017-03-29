//
//  NZTaskDetailView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/29.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZTaskDetailView.h"
#import "HTUIHeader.h"

@implementation NZTaskDetailView

- (instancetype)initWithFrame:(CGRect)frame withModel:(NSDictionary*)modal
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_monday_music_cover_default"]];
        titleImageView.layer.masksToBounds = YES;
        titleImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:titleImageView];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
            make.right.equalTo(@(-16));
            make.height.mas_equalTo((frame.size.width-32)/288*145);
        }];
        
        
    }
    return self;
}

@end
