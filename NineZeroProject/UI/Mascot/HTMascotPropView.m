//
//  HTMascotPropView.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/21.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTMascotPropView.h"
#import "HTUIHeader.h"
#import "HTDescriptionView.h"

@interface HTMascotPropView ()
@property (nonatomic, strong) NSMutableArray<HTMascotPropItem *> *items;
@property (nonatomic, strong) UIButton *moreButton;
@end

@implementation HTMascotPropView {
    CGFloat marginX;
    CGFloat marginY;
}

- (instancetype)initWithProps:(NSArray<HTMascotProp *> *)props {
    if (self = [super init]) {
        _props = props;
        _items = [[NSMutableArray alloc] init];
        [self buildProps];
    }
    return self;
}

- (void)setProps:(NSArray<HTMascotProp *> *)props {
    _props = props;
    [self buildProps];
    [self setNeedsUpdateConstraints];
}

- (void)buildProps {
    [_items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_items removeAllObjects];
    NSInteger count = MIN(_props.count, 3);
    for (int i = 0; i != count; i++) {
        HTMascotPropItem *item = [[HTMascotPropItem alloc] init];
        item.prop = _props[i];
        [self addSubview:item];
        [_items addObject:item];
    }
    
    if (!_moreButton && _props.count > 3) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"img_mascot_prop_arrow_down_grey"] forState:UIControlStateNormal];
        [_moreButton setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
        [_moreButton addTarget:self action:@selector(onClickMoreButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreButton];
    }
}

- (void)onClickMoreButton {
    [self.delegate didClickBottomArrowInMascotPropView:self];
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
            make.right.equalTo(self.mas_centerX).offset(-ROUND_WIDTH_FLOAT(49));
        }];
        [_items[1] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(topOffset);
            make.left.equalTo(self.mas_centerX).offset(ROUND_WIDTH_FLOAT(49));
        }];
    } else if (_props.count >= 3) {
        _moreButton.hidden = NO;
        [_items[1] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(topOffset);
            make.centerX.equalTo(self.mas_centerX);
        }];
        [_items[0] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(topOffset);
            make.right.equalTo(_items[1].mas_left).offset(-ROUND_WIDTH_FLOAT(50));
        }];
        [_items[2] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(topOffset);
            make.left.equalTo(_items[1].mas_right).offset(ROUND_WIDTH_FLOAT(50));
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

@interface HTMascotPropItem () <HTDescriptionViewDelegate>
@property (nonatomic, strong) UIImageView *exChangedView;
@property (nonatomic, strong) UIImageView *icon;
@end

@implementation HTMascotPropItem
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorMake(32, 32, 32);
        self.layer.cornerRadius = 22.5;
//        self.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        
        _icon = [[UIImageView alloc] init];
        [self addSubview:_icon];
        
        _exChangedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_prop_redeemed"]];
        _exChangedView.hidden = YES;
        [self addSubview:_exChangedView];
        
        [self addTarget:self action:@selector(onClickPropItem) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setProp:(HTMascotProp *)prop {
    _prop = prop;
    [_icon sd_setImageWithURL:[NSURL URLWithString:prop.prop_icon] placeholderImage:[UIImage imageNamed:@"img_mascot_prop_demo"]];
    if (prop.used) {
        _icon.alpha = 0.39;
        _exChangedView.hidden = NO;
    } else {
        _icon.alpha = 1.0;
        _exChangedView.hidden = YES;
    }
    [self setNeedsLayout];
}

- (void)onClickPropItem {
    [MobClick event:@"toy"];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    HTDescriptionView *descView = [[HTDescriptionView alloc] initWithURLString:nil andType:HTDescriptionTypeProp];
    [descView setProp:_prop];
    descView.delegate = self;
    [KEY_WINDOW addSubview:descView];
    [descView showAnimated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _exChangedView.right = self.width + 5;
    _exChangedView.bottom = 15;
    _icon.centerX = self.width / 2;
    _icon.centerY = self.height / 2;
    _icon.width = self.width - 10;
    _icon.height = self.height - 10;
    _icon.layer.cornerRadius = _icon.width / 2;
    _icon.layer.masksToBounds = YES;
}

- (void)descriptionView:(HTDescriptionView *)descView didChangeProp:(HTMascotProp *)prop {
    [self setProp:prop];
}

@end

