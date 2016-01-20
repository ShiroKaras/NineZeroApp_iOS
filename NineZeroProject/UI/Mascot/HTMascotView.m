//
//  HTMascotView.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/20.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTMascotView.h"
#import <Masonry.h>
#import <math.h>
#import "HTUIHeader.h"
#import <objc/runtime.h>

#define MASCOT_ITEMS_COUNT 8

const char *kTapItemAssociatedKey;

@interface HTMascotView ()
@property (nonatomic, strong) NSMutableArray<HTMascotItem *> *mascotItems;
@property (nonatomic, strong) NSMutableArray<HTMascotTipView *> *mascotTips;
@property (nonatomic, strong) NSArray<NSNumber *> *mascotLayers;
@end

@implementation HTMascotView

- (instancetype)initWithShowMascotIndexs:(NSArray<NSNumber *> *)indexs {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        _currentDisplayIndexs = indexs;
        _mascotItems = [NSMutableArray arrayWithCapacity:MASCOT_ITEMS_COUNT];
        _mascotTips = [NSMutableArray arrayWithCapacity:MASCOT_ITEMS_COUNT];
        // 零仔展示层级对应的index关系
        _mascotLayers = @[@7, @6, @4, @3, @2, @1, @5, @0];
        [self buildViews];
        [self reloadDisplayMascots];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)buildViews {
    [_mascotItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_mascotItems removeAllObjects];
    [_mascotTips makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_mascotTips removeAllObjects];
    // 构造零仔
    for (int i = 0; i != MASCOT_ITEMS_COUNT; i++) {
        HTMascotItem *item = [[HTMascotItem alloc] init];
        item.index = i;
        item.hidden = YES;
        item.userInteractionEnabled = YES;
        item.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_mascot_%d_animation_1", (i + 1)]];
        [item sizeToFit];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mascotItemDidTap:)];
        [item addGestureRecognizer:tap];
        objc_setAssociatedObject(tap, kTapItemAssociatedKey, item, OBJC_ASSOCIATION_RETAIN);
        [_mascotItems addObject:item];
    }
    // 零仔层级调整
    for (int i = 0; i != MASCOT_ITEMS_COUNT; i++) {
        NSInteger layerIndex = [_mascotLayers[i] integerValue];
        HTMascotItem *item = _mascotItems[layerIndex];
        [self addSubview:item];
    }
    // 零仔附属的tips构造
    for (int i = 0; i != MASCOT_ITEMS_COUNT; i++) {
        HTMascotTipView *tip = [[HTMascotTipView alloc] initWithIndex:i];
        [tip setTipNumber:2];
        tip.index = i;
        tip.hidden = YES;
        [_mascotTips addObject:tip];
        [self addSubview:tip];
    }
}

- (void)reloadDisplayMascots {
    for (NSNumber *index in _currentDisplayIndexs) {
        NSInteger displayIndex = [index integerValue];
        _mascotItems[displayIndex].hidden = NO;
    }
}

- (void)updateConstraints {
    if (_mascotItems.count < MASCOT_ITEMS_COUNT) {
        [super updateConstraints];
        return;
    }
    [_mascotItems[0] mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(ROUND_WIDTH(81.0));
       make.bottom.equalTo(ROUND_HEIGHT(-180));
       make.width.equalTo(@99);
       make.height.equalTo(@99);
    }];
    [_mascotItems[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ROUND_WIDTH(152.0));
        make.bottom.equalTo(ROUND_HEIGHT(-184));
        make.width.equalTo(@140);
        make.height.equalTo(@140);
    }];
    [_mascotItems[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ROUND_WIDTH(63));
        make.bottom.equalTo(ROUND_HEIGHT(-196));
        make.width.equalTo(@203);
        make.height.equalTo(@203);
    }];
    [_mascotItems[3] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ROUND_WIDTH(0));
        make.bottom.equalTo(ROUND_HEIGHT(-196));
        make.width.equalTo(@177);
        make.height.equalTo(@177);
    }];
    [_mascotItems[4] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ROUND_WIDTH(0));
        make.bottom.equalTo(ROUND_HEIGHT(-191));
        make.width.equalTo(@105);
        make.height.equalTo(@105);
    }];
    [_mascotItems[5] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ROUND_WIDTH(5));
        make.bottom.equalTo(ROUND_HEIGHT(-360));
        make.width.equalTo(@150);
        make.height.equalTo(@150);
    }];
    [_mascotItems[6] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ROUND_WIDTH(167));
        make.bottom.equalTo(ROUND_HEIGHT(-213));
        make.width.equalTo(@153);
        make.height.equalTo(@153);
    }];
    [_mascotItems[7] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ROUND_WIDTH(0));
        make.bottom.equalTo(ROUND_HEIGHT(-187));
        make.width.equalTo(@284);
        make.height.equalTo(@315);
    }];
    if (_mascotTips.count < MASCOT_ITEMS_COUNT) {
        [super updateConstraints];
        return;
    }
    [_mascotTips[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_mascotItems[0]);
        make.top.equalTo(_mascotItems[0].mas_top).offset(-20);
    }];
    [_mascotTips[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_mascotItems[1]);
        make.top.equalTo(_mascotItems[1].mas_top).offset(1);
    }];
    [_mascotTips[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mascotItems[2].mas_left).offset(86);
        make.top.equalTo(_mascotItems[2].mas_top).offset(-28);
    }];
    [_mascotTips[3] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mascotItems[3].mas_left).offset(70);
        make.top.equalTo(_mascotItems[3].mas_top).offset(-22);
    }];
    [_mascotTips[4] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_mascotItems[4].mas_right).offset(-29);
        make.top.equalTo(_mascotItems[4].mas_top).offset(-12);
    }];
    [_mascotTips[5] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_mascotItems[5]);
        make.top.equalTo(_mascotItems[5].mas_top).offset(-7);
    }];
    [_mascotTips[6] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_mascotItems[6].mas_right).offset(-62);
        make.top.equalTo(_mascotItems[6].mas_top).offset(-17);
    }];
    [_mascotTips[7] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_mascotItems[7].mas_right).offset(-45);
        make.top.equalTo(_mascotItems[7].mas_top).offset(-32);
    }];
    
    [super updateConstraints];
}

- (void)mascotItemDidTap:(UITapGestureRecognizer *)gesture {
    HTMascotItem *item = objc_getAssociatedObject(gesture, kTapItemAssociatedKey);
    if (item) {
        for (HTMascotTipView *tip in _mascotTips) {
            if (tip.index == item.index) {
                tip.hidden = NO;
            } else {
                tip.hidden = YES;
            }
        }
    }
}

@end

@implementation HTMascotItem
@end

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
    if (tipNumber <= 0) return;
    if (tipNumber == 1) {
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
        _tipLabel.font = [UIFont fontWithName:@"Moon-Bold" size:20];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
     }
    [self setImage:[UIImage imageNamed:@"img_mascot_notification"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"img_mascot_notification_highlight"] forState:UIControlStateHighlighted];
    [self sizeToFit];
}

@end