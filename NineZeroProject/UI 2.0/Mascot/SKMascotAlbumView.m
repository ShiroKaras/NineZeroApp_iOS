//
//  SKMascotAlbumView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/26.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKMascotAlbumView.h"
#import "HTUIHeader.h"

@implementation SKMascotAlbumView

- (instancetype)initWithFrame:(CGRect)frame withMascotArray:(NSArray<SKPet*>*)mascotArray {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIView *alphaView = [[UIView alloc] initWithFrame:self.frame];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.9;
    [self addSubview:alphaView];
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@4);
    }];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(320), ROUND_HEIGHT_FLOAT(413))];
    backView.backgroundColor = [UIColor lightGrayColor];
    backView.center = self.center;
    [self addSubview:backView];
    
    UIImageView *mascot_greed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_greed"]];
    [mascot_greed sizeToFit];
    [backView addSubview:mascot_greed];
    [mascot_greed mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}

- (void)closeButtonClick:(UIButton*)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
