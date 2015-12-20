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
        
        _dimmingView = [[UIView alloc] init];
        _dimmingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [self addSubview:_dimmingView];
        
        _bubbleImageView = [[UIImageView alloc] init];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    _dimmingView.frame = self.bounds;
    
}

@end
