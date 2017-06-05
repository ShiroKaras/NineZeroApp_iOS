//
//  NZEvidenceView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/18.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZEvidenceView.h"
#import "HTUIHeader.h"

@interface NZEvidenceView ()
@property (nonatomic, strong) UIImageView *propImageView;
@property (nonatomic, strong) UIImageView *propTextImageView;
@property (nonatomic, strong) UILabel *propTextLabel;
@end

@implementation NZEvidenceView

- (instancetype)initWithFrame:(CGRect)frame withCrimeEvidence:(SKMascotEvidence *)evidence {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUIWithFrame:frame];
        
        [[[SKServiceManager sharedInstance] mascotService] getMascotEvidenceDetailWithID:evidence.id callback:^(BOOL success, SKMascotEvidence *evidence) {
            [_propImageView sd_setImageWithURL:[NSURL URLWithString:evidence.crime_pic]];
            [_propTextImageView sd_setImageWithURL:[NSURL URLWithString:evidence.crime_name]];
            _propTextLabel.text = evidence.crime_description;
            [_propTextLabel sizeToFit];
        }];
    }
    return self;
}

- (void)createUIWithFrame:(CGRect)frame {
    self.backgroundColor = [UIColor clearColor];
    UIView *alphaView = [[UIView alloc] initWithFrame:frame];
    alphaView.backgroundColor = COMMON_BG_COLOR;
    alphaView.alpha = 0.9;
    [self addSubview:alphaView];
    
    _propImageView = [UIImageView new];
    _propImageView.layer.cornerRadius = 2;
    _propImageView.layer.borderColor = COMMON_GREEN_COLOR.CGColor;
    [self addSubview:_propImageView];
    [_propImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(222), ROUND_WIDTH_FLOAT(222)));
        make.centerX.equalTo(alphaView.mas_centerX);
        make.top.equalTo(ROUND_HEIGHT(107.5));
    }];
    
    _propTextImageView = [UIImageView new];
    _propTextImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_propTextImageView];
    [_propTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 26));
        make.centerX.equalTo(alphaView.mas_centerX);
        make.top.equalTo(_propImageView.mas_bottom).offset(30);
    }];
    
    _propTextLabel = [UILabel new];
    _propTextLabel.textColor = [UIColor whiteColor];
    _propTextLabel.font = PINGFANG_FONT_OF_SIZE(14);
    _propTextLabel.textAlignment = NSTextAlignmentCenter;
    _propTextLabel.numberOfLines = 0;
    [self addSubview:_propTextLabel];
    [_propTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.right.equalTo(@-16);
        make.centerX.equalTo(alphaView.mas_centerX);
        make.top.equalTo(_propTextImageView.mas_bottom).offset(25);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    [self addGestureRecognizer:tap];
}

- (void)closeView {
    [self removeFromSuperview];
}

@end
