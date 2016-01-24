//
//  HTMascotPropView.m
//  NineZeroProject
//
//  Created by ronhu on 16/1/21.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTMascotPropView.h"
#import "HTUIHeader.h"

@interface HTMascotPropView ()
@property (nonatomic, strong) NSArray<HTMascotProp *> *props;
@property (nonatomic, strong) NSMutableArray<HTMascotPropItem *> *items;
@property (nonatomic, strong) UIButton *moreButton;
@end

@implementation HTMascotPropView

- (instancetype)initWithProps:(NSArray<HTMascotProp *> *)props {
    if (self = [super init]) {
        _props = props;
        _items = [[NSMutableArray alloc] init];
        [self buildProps];
    }
    return self;
}

- (void)buildProps {
    NSInteger count = MIN(_props.count, 3);
    for (int i = 0; i != count; i++) {
        HTMascotPropItem *item = [[HTMascotPropItem alloc] init];
        item.prop = _props[i];
        [item setImage:[UIImage imageNamed:@"img_mascot_prop_demo"] forState:UIControlStateNormal];
        [self addSubview:item];
        [_items addObject:item];
    }
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreButton setImage:[UIImage imageNamed:@"img_mascot_prop_arrow_down_grey"] forState:UIControlStateNormal];
    [_moreButton setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    [self addSubview:_moreButton];
}

- (void)updateConstraints {
    CGFloat topOffset = 26;
    if (_props.count == 1) {
        _moreButton.hidden = YES;
        [_items[0] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(topOffset);
        }];
    } else if (_props.count == 2) {
        _moreButton.hidden = YES;
        [_items[0] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(topOffset);
            make.right.equalTo(self.mas_centerX).offset(-49);
        }];
        [_items[1] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(topOffset);
            make.left.equalTo(self.mas_centerX).offset(49);
        }];
    } else if (_props.count >= 3) {
        _moreButton.hidden = NO;
        [_items[1] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(topOffset);
            make.centerX.equalTo(self.mas_centerX);
        }];
        [_items[0] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(topOffset);
            make.right.equalTo(_items[1].mas_left).offset(-50);
        }];
        [_items[2] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(topOffset);
            make.left.equalTo(_items[1].mas_right).offset(50);
        }];
        [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_items[1].mas_bottom).offset(16);
            make.centerX.equalTo(self.mas_centerX);
        }];
    }
    for (HTMascotPropItem *item in _items) {
        [item mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@45);
            make.height.equalTo(@45);
        }];
    }
    [super updateConstraints];
}

@end

@interface HTMascotPropItem ()
@end

@implementation HTMascotPropItem
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorMake(32, 32, 32);
        self.layer.cornerRadius = 22.5;
        self.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);

    }
    return self;
}
@end

