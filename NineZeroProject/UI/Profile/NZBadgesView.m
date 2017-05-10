//
//  NZBadgesView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/9.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZBadgesView.h"
#import "HTUIHeader.h"

@implementation NZBadgesView

- (instancetype)initWithFrame:(CGRect)frame badges:(NSArray<SKBadge*>*)badges
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COMMON_BG_COLOR;
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_userpage_achievement"]];
        [self addSubview:titleImageView];
        titleImageView.left = 16;
        titleImageView.top = 16;
        
        for (int i=0; i<17; i++) {
            
        }
        
        _viewHeight = 1000;
    }
    return self;
}

@end
