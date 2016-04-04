//
//  HTProfileBadgeCollectionCell.m
//  NineZeroProject
//
//  Created by ronhu on 16/3/12.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTProfileBadgeCollectionCell.h"
#import "HTUIHeader.h"

@interface HTProfileBadgeCollectionCell ()
@property (nonatomic, strong) UIImageView *badgeImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation HTProfileBadgeCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHex:0x1a1a1a];
    
        _badgeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_badge_1"]];
        [self addSubview:_badgeImageView];
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = [UIColor whiteColor];
        [self addSubview:_tipLabel];
    }
    return self;
}

- (void)setBadge:(HTBadge *)badge {
    _badge = badge;
    [_badgeImageView sd_setImageWithURL:[NSURL URLWithString:badge.medal_icon] placeholderImage:[UIImage imageNamed:@"img_badge_1"]];
    _tipLabel.text = badge.medal_name;
    [_tipLabel sizeToFit];
    if (badge.have) {
        _badgeImageView.alpha = 1.0;
        _tipLabel.alpha = 1.0;
    } else {
        _badgeImageView.alpha = 0.3;
        _tipLabel.alpha = 0.3;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat badgeWidth = 87;
    _badgeImageView.frame = CGRectMake(self.width / 2 - badgeWidth / 2 , 14, badgeWidth, badgeWidth);
    _tipLabel.frame = CGRectMake(0, _badgeImageView.bottom + 8, self.width, _tipLabel.height);
    // 调整位置
    CGFloat totalHeight = _tipLabel.bottom - _badgeImageView.top;
    CGFloat supposedOffsetY = (self.height - totalHeight) / 2;
    _badgeImageView.top = supposedOffsetY;
    _tipLabel.top = _badgeImageView.bottom + 8;
    // end
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

@end
