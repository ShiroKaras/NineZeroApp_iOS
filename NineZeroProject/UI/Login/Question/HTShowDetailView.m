//
//  HTShowDetailView.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/20.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTShowDetailView.h"
#import "HTUIHeader.h"

@interface HTShowDetailView ()

@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) UILabel *bubbleLabel;

@end

@implementation HTShowDetailView {
    CGRect _showInRect;
}

- (instancetype)initWithDetailText:(NSString *)text andShowInRect:(CGRect)rect {
    if (self = [super initWithFrame:CGRectZero]) {
        _showInRect = rect;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickCancelButton)];
        _dimmingView = [[UIView alloc] init];
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [_dimmingView addGestureRecognizer:tap];
        [self addSubview:_dimmingView];
        
        _bubbleImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"img_popover_hint_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 15, 20) resizingMode:UIImageResizingModeStretch]];
        [_dimmingView addSubview:_bubbleImageView];
        
        _bubbleLabel = [[UILabel alloc] init];
        _bubbleLabel.text = text;
        _bubbleLabel.font = [UIFont systemFontOfSize:13];
        _bubbleLabel.numberOfLines = 0;
        _bubbleLabel.lineBreakMode = NSLineBreakByClipping;
        _bubbleLabel.textColor = [UIColor colorWithHex:0xd9d9d9];
        [_bubbleImageView addSubview:_bubbleLabel];
    }
    return self;
}

- (void)didClickCancelButton {
     [self removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _dimmingView.frame = self.bounds;
    CGSize size = [_bubbleLabel.text boundingRectWithSize:CGSizeMake(_bubbleImageView.width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13] } context:nil].size;
    _bubbleImageView.height = size.height + 20;
    _bubbleImageView.left = CGRectGetMinX(_showInRect) + 20;
    _bubbleImageView.width = size.width + 20;
    _bubbleImageView.bottom = CGRectGetMinY(_showInRect) + 30;
    _bubbleLabel.width = size.width;
    _bubbleLabel.height = size.height + 3;
    _bubbleLabel.left = 10;
    _bubbleLabel.top = 7;

    
}

@end
