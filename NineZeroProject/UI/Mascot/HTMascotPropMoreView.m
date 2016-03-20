//
//  HTMascotPropMoreView.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/22.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTMascotPropMoreView.h"
#import "HTMascotPropView.h"
#import "HTUIHeader.h"

NSInteger kPageItemCount = 15;

@interface HTMascotPropMoreView ()
@property (nonatomic, strong) NSMutableArray<HTMascotPropItem *> *propItems;
@property (nonatomic, strong) NSArray<HTMascotProp *> *props;
@property (nonatomic, strong) UIButton *topArraw;
@property (nonatomic, strong) UIButton *bottomArraw;
@property (nonatomic, assign, readwrite) NSInteger pageCount;
@end

@implementation HTMascotPropMoreView
- (instancetype)initWithProps:(NSArray<HTMascotProp *> *)props andPageCount:(NSInteger)pageCount {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        _pageCount = pageCount;
        _props = props;
        self.backgroundColor = COMMON_BG_COLOR;
        
        _topArraw = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topArraw setImage:[UIImage imageNamed:@"img_mascot_prop_arrow_up_grey"] forState:UIControlStateNormal];
        [_topArraw setImage:[UIImage imageNamed:@"img_mascot_prop_arrow_up_grey_highlight"] forState:UIControlStateHighlighted];
        [_topArraw addTarget:self action:@selector(onClickTopArraw) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_topArraw];
        
        _bottomArraw = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomArraw setImage:[UIImage imageNamed:@"img_mascot_prop_arrow_down_grey"] forState:UIControlStateNormal];
        [_bottomArraw setImage:[UIImage imageNamed:@"img_mascot_prop_arrow_down_grey_highlight"] forState:UIControlStateHighlighted];
        [_bottomArraw addTarget:self action:@selector(onClickBottomArraw) forControlEvents:UIControlEventTouchUpInside];
        _bottomArraw.hidden = !(_props.count - pageCount * kPageItemCount > kPageItemCount);
        [self addSubview:_bottomArraw];
        
        _decorateView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_prop_title"]];
        [self addSubview:_decorateView];
        
        [self buildPropItemsWithProps:props];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)buildPropItemsWithProps:(NSArray<HTMascotProp *> *)props {
    NSInteger count = MIN(props.count - _pageCount * kPageItemCount, kPageItemCount);
    _propItems = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i != count; i++) {
        HTMascotPropItem *item = [[HTMascotPropItem alloc] init];
        item.prop = props[i + _pageCount * kPageItemCount];
        item.index = i;
        [self addSubview:item];
        [_propItems addObject:item];
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)onClickTopArraw {
    [self.delegate didClickTopArrawInPropMoreView:self];
}

- (void)onClickBottomArraw {
    [self.delegate didClickBottomArrawInPropMoreView:self];
}

- (void)updateConstraints {
    [_decorateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ROUND_WIDTH(19));
        make.top.equalTo(ROUND_HEIGHT(37));
    }];
    
    [_topArraw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_decorateView);
    }];
    
    [_bottomArraw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ROUND_HEIGHT(-61));
        make.centerX.equalTo(_topArraw);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_mascot_prop_arrow_up_grey"]];
    CGFloat itemsMargin = (SCREEN_HEIGHT - ROUND_HEIGHT_FLOAT(37) - ROUND_HEIGHT_FLOAT(61) - arrowImageView.height * 2 - 54 - 45 * 5) / 4;
    for (HTMascotPropItem *item in _propItems) {
        NSInteger line = item.index / 3;  // 行
        NSInteger row = item.index % 3;   // 列
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@45);
            if (line == 0 && row == 1) {
                make.top.equalTo(_topArraw.mas_bottom).offset(27);
                make.centerX.equalTo(self.mas_centerX);
            } else if (line == 0 && row == 0) {
                make.top.equalTo(_propItems[1]);
                make.right.equalTo(_propItems[1].mas_left).offset(-ROUND_WIDTH_FLOAT(50));
            } else if (line == 0 && row == 2) {
                make.top.equalTo(_propItems[1]);
                make.left.equalTo(_propItems[1].mas_right).offset(ROUND_WIDTH_FLOAT(50));
            } else {
                HTMascotPropItem *topItem = _propItems[row + 3 * (line - 1)];
                make.top.equalTo(topItem.mas_bottom).offset(itemsMargin);
                make.centerX.equalTo(topItem.mas_centerX);
            }
        }];
    }
    
    [super updateConstraints];
}

@end
