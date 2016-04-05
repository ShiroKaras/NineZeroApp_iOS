//
//  HTMascotTipView.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTMascotTipView.h"
#import "HTUIHeader.h"

@implementation HTMascotTipView {
    UIImageView *_arrawView;
    UILabel *_tipLabel;
}

- (instancetype)initWithIndex:(NSInteger)index {
    if (self = [super init]) {
        [self setImage:[UIImage imageNamed:@"img_mascot_notification"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"img_mascot_notification_highlight"] forState:UIControlStateHighlighted];
        [self sizeToFit];
        [self buildViewsIfNeed];
    }
    return self;
}

- (void)setTipNumber:(NSInteger)tipNumber {
    _tipNumber = tipNumber;
    if (tipNumber <= 1) {
        _arrawView.hidden = NO;
        _tipLabel.hidden = YES;
    } else {
        _arrawView.hidden = YES;
        _tipLabel.hidden = NO;
        _tipLabel.text = [NSString stringWithFormat:@"%ld", tipNumber];
    }
}

- (void)updateConstraints {
    [_arrawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(7);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(4);
    }];
    self.userInteractionEnabled = YES;
    [super updateConstraints];
}

- (void)buildViewsIfNeed {
    if (_arrawView == nil) {
        _arrawView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mascot_notification_arrow"]];
        [self addSubview:_arrawView];
    }
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = MOON_FONT_OF_SIZE(20);
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
     }
    [self setImage:[UIImage imageNamed:@"img_mascot_notification"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"img_mascot_notification_highlight"] forState:UIControlStateHighlighted];
    [self sizeToFit];
}

@end