//
//  SKMascotView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/14.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKMascotView.h"
#import "HTUIHeader.h"

@interface SKMascotView ()
@property (nonatomic, strong) UIButton *fightButton;
@property (nonatomic, strong) UIButton *mascotdexButton;
@property (nonatomic, strong) UIButton *skillButton;
@property (nonatomic, strong) UIButton *infoButton;
@end

@implementation SKMascotView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUIWithType:mascotType];
    }
    return self;
}

- (void)createUIWithType:(SKMascotType)type {
    UIImageView *mBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mBackImageView.backgroundColor = [UIColor blackColor];
    [self addSubview:mBackImageView];
    
    _fightButton = [UIButton new];
    _fightButton.hidden = YES;
    [self addSubview:_fightButton];
    [_fightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@70);
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-30);
    }];
    
    _mascotdexButton = [UIButton new];
    [_mascotdexButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_albums"] forState:UIControlStateNormal];
    [_mascotdexButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_albums_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:_mascotdexButton];
    [_mascotdexButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@60);
        make.left.equalTo(@16);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
    }];
    
    _skillButton = [UIButton new];
    _skillButton.backgroundColor = [UIColor blackColor];
    [self addSubview:_skillButton];
    [_skillButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@60);
        make.right.equalTo(self.mas_right).offset(-16);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
    }];
    
    _infoButton = [UIButton new];
    [_infoButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_info"] forState:UIControlStateNormal];
    [_infoButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_info_highlight"] forState:UIControlStateHighlighted];
    [_infoButton sizeToFit];
    [self addSubview:_infoButton];
    [_infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.right.equalTo(self.mas_right).offset(-4);
    }];
    
    switch (type) {
        case SKMascotTypeDefault: {
            _fightButton.hidden = YES;
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_lingzaiskill"] forState:UIControlStateNormal];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_lingzaiskill_highlight"] forState:UIControlStateHighlighted];
            break;
        }
        case SKMascotTypeEnvy: {
            _fightButton.hidden = NO;
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_envyfight"] forState:UIControlStateNormal];
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_envyfight_highlight"] forState:UIControlStateHighlighted];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_envyskill"] forState:UIControlStateNormal];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_envyskill_highlight"] forState:UIControlStateHighlighted];
            break;
        }
        case SKMascotTypeGluttony: {
            _fightButton.hidden = NO;
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_gluttonyfight"] forState:UIControlStateNormal];
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_gluttonyfight_highlight"] forState:UIControlStateHighlighted];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_gluttonyskill"] forState:UIControlStateNormal];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_gluttonyskill_highlight"] forState:UIControlStateHighlighted];
            break;
        }
        case SKMascotTypeGreed: {
            _fightButton.hidden = NO;
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_greedfight"] forState:UIControlStateNormal];
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_greedfight_highlight"] forState:UIControlStateHighlighted];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_greedskill"] forState:UIControlStateNormal];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_greedskill_highlight"] forState:UIControlStateHighlighted];
            break;
        }
        case SKMascotTypePride: {
            _fightButton.hidden = NO;
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_pridefight"] forState:UIControlStateNormal];
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_pridefight_highlight"] forState:UIControlStateHighlighted];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_prideskill"] forState:UIControlStateNormal];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_prideskill_highlight"] forState:UIControlStateHighlighted];
            break;
        }
        case SKMascotTypeSloth: {
            _fightButton.hidden = NO;
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_slothfight"] forState:UIControlStateNormal];
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_slothfight_highlight"] forState:UIControlStateHighlighted];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_slothskill"] forState:UIControlStateNormal];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_slothskill_highlight"] forState:UIControlStateHighlighted];
            break;
        }
        case SKMascotTypeWrath: {
            _fightButton.hidden = NO;
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_wrathfight"] forState:UIControlStateNormal];
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_wrathfight_highlight"] forState:UIControlStateHighlighted];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_wrathskill"] forState:UIControlStateNormal];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_wrathskill_highlight"] forState:UIControlStateHighlighted];
            break;
        }
        case SKMascotTypeLust: {
            _fightButton.hidden = NO;
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_lustfight"] forState:UIControlStateNormal];
            [_fightButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_lustfight_highlight"] forState:UIControlStateHighlighted];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_lustskill"] forState:UIControlStateNormal];
            [_skillButton setBackgroundImage:[UIImage imageNamed:@"btn_lingzaipage_lustskill_highlight"] forState:UIControlStateHighlighted];
            break;
        }
        default:
            break;
    }
}


@end
