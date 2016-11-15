//
//  SKMascotView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/14.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import "SKMascotView.h"
#import "HTUIHeader.h"

@interface SKMascotView ()
@property (nonatomic, strong) UIButton *fightButton;
@property (nonatomic, strong) UIButton *mascotdexButton;
@property (nonatomic, strong) UIButton *skillButton;
@property (nonatomic, strong) UIButton *infoButton;

@property (nonatomic, assign) SKMascotType mascotType;
@end

@implementation SKMascotView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType {
    self = [super initWithFrame:frame];
    if (self) {
        _mascotType = mascotType;
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
    [_skillButton addTarget:self action:@selector(skillButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)skillButtonClick:(UIButton*)sender {
    SKMascotSkillView *skillView = [[SKMascotSkillView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Type:_mascotType];
    [KEY_WINDOW addSubview:skillView];
}

@end



@interface SKMascotSkillView ()
@property (nonatomic, strong) NSArray *mascotNameArray;
@end

@implementation SKMascotSkillView

- (instancetype)initWithFrame:(CGRect)frame Type:(SKMascotType)mascotType {
    self = [super initWithFrame:frame];
    if (self) {
        _mascotNameArray = @[@"lingzai", @"envy", @"gluttony", @"greed", @"pride", @"sloth", @"wrath", @"lust"];
        [self createUIWithType:mascotType];
    }
    return self;
}

- (void)createUIWithType:(SKMascotType)mascotType {
    UIView *dimmingView = [UIView new];
    dimmingView.backgroundColor = [UIColor blackColor];
    dimmingView.alpha = 0.9;
    [self addSubview:dimmingView];
    [dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_levelpage_back_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@4);
    }];
    
    if (mascotType == SKMascotTypeDefault) {
        [self defaultSkillView];
    } else {
        [self sinSkillViewWithType:mascotType];
    }
}

- (void)defaultSkillView {
    //第一季
    
    UIButton *hintS1Button = [UIButton new];
    [hintS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue"] forState:UIControlStateNormal];
    [hintS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:hintS1Button];
    [hintS1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(70));
        make.height.equalTo(ROUND_HEIGHT(95));
        make.top.equalTo(ROUND_HEIGHT(143));
        make.left.equalTo(ROUND_WIDTH(59));
    }];
    
    UIButton *answerS1Button = [UIButton new];
    [answerS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution"] forState:UIControlStateNormal];
    [answerS1Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:answerS1Button];
    [answerS1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(hintS1Button);
        make.centerY.equalTo(hintS1Button.mas_centerY);
        make.left.equalTo(hintS1Button.mas_right).offset(ROUND_WIDTH_FLOAT(62));
    }];
    
    UILabel *label_2icon_season1 = [UILabel new];
    label_2icon_season1.text = @"2";
    label_2icon_season1.textColor = [UIColor whiteColor];
    label_2icon_season1.font = MOON_FONT_OF_SIZE(18);
    [label_2icon_season1 sizeToFit];
    [self addSubview:label_2icon_season1];
    [label_2icon_season1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintS1Button.mas_bottom).offset(6);
        make.centerX.equalTo(hintS1Button.mas_centerX).offset(12);
    }];
    
    UIImageView *imageView_icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_gold"]];
    [self addSubview:imageView_icon];
    [imageView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label_2icon_season1);
        make.right.equalTo(label_2icon_season1.mas_left).offset(-4);
    }];
    
    UILabel *label_200icon_season1 = [UILabel new];
    label_200icon_season1.text = @"200";
    label_200icon_season1.textColor = [UIColor whiteColor];
    label_200icon_season1.font = MOON_FONT_OF_SIZE(18);
    [label_200icon_season1 sizeToFit];
    [self addSubview:label_200icon_season1];
    [label_200icon_season1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(answerS1Button.mas_bottom).offset(6);
        make.centerX.equalTo(answerS1Button.mas_centerX).offset(12);
    }];
    
    UIImageView *imageView_icon_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_gold"]];
    [self addSubview:imageView_icon_2];
    [imageView_icon_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label_200icon_season1);
        make.right.equalTo(label_200icon_season1.mas_left).offset(-4);
    }];
    
    UIImageView *flagView_season1_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_season1"]];
    [self addSubview:flagView_season1_1];
    [flagView_season1_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(44));
        make.height.equalTo(ROUND_WIDTH(19));
        make.left.equalTo(hintS1Button.mas_left).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(hintS1Button.mas_bottom).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    UIImageView *flagView_season1_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_season1"]];
    [self addSubview:flagView_season1_2];
    [flagView_season1_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(flagView_season1_1);
        make.left.equalTo(answerS1Button).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(answerS1Button).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    //第二季
    
    UIButton *hintS2Button = [UIButton new];
    [hintS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue"] forState:UIControlStateNormal];
    [hintS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_clue_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:hintS2Button];
    [hintS2Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(hintS1Button);
        make.top.equalTo(imageView_icon.mas_bottom).offset(46);
        make.centerX.equalTo(hintS1Button.mas_centerX);
    }];
    
    UIButton *answerS2Button = [UIButton new];
    [answerS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution"] forState:UIControlStateNormal];
    [answerS2Button setBackgroundImage:[UIImage imageNamed:@"btn_lingzaiskillpage_solution_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:answerS2Button];
    [answerS2Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(hintS1Button);
        make.centerX.equalTo(answerS1Button);
        make.centerY.equalTo(hintS2Button);
    }];
    
    UILabel *label_2icon_season2 = [UILabel new];
    label_2icon_season2.text = @"2";
    label_2icon_season2.textColor = [UIColor whiteColor];
    label_2icon_season2.font = MOON_FONT_OF_SIZE(18);
    [label_2icon_season2 sizeToFit];
    [self addSubview:label_2icon_season2];
    [label_2icon_season2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintS2Button.mas_bottom).offset(6);
        make.centerX.equalTo(hintS2Button.mas_centerX).offset(12);
    }];
    
    UIImageView *imageView_diamond = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_diamonds"]];
    [self addSubview:imageView_diamond];
    [imageView_diamond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label_2icon_season2);
        make.right.equalTo(label_2icon_season2.mas_left).offset(-4);
    }];
    
    UILabel *label_200icon_season2 = [UILabel new];
    label_200icon_season2.text = @"200";
    label_200icon_season2.textColor = [UIColor whiteColor];
    label_200icon_season2.font = MOON_FONT_OF_SIZE(18);
    [label_200icon_season2 sizeToFit];
    [self addSubview:label_200icon_season2];
    [label_200icon_season2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(answerS2Button.mas_bottom).offset(6);
        make.centerX.equalTo(answerS2Button.mas_centerX).offset(12);
    }];
    
    UIImageView *imageView_diamond_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_diamonds"]];
    [self addSubview:imageView_diamond_2];
    [imageView_diamond_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label_200icon_season2);
        make.right.equalTo(label_200icon_season2.mas_left).offset(-4);
    }];
    
    UIImageView *flagView_season2_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_season2"]];
    [self addSubview:flagView_season2_1];
    [flagView_season2_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(flagView_season1_1);
        make.left.equalTo(hintS2Button).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(hintS2Button).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
    
    UIImageView *flagView_season2_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaiskillpage_season2"]];
    [self addSubview:flagView_season2_2];
    [flagView_season2_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(flagView_season1_1);
        make.left.equalTo(answerS2Button).offset(ROUND_WIDTH_FLOAT(40));
        make.bottom.equalTo(answerS2Button).offset(ROUND_HEIGHT_FLOAT(-82));
    }];
}

- (void)sinSkillViewWithType:(SKMascotType)mascotType {
    UIImageView *compoundImageView = [UIImageView new];
    [self addSubview:compoundImageView];
    [compoundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(276));
        make.height.equalTo(ROUND_WIDTH(276));
        make.centerX.equalTo(self);
        make.top.equalTo(ROUND_HEIGHT(69));
    }];
    
    UIButton *exchangeButton = [UIButton new];
    [self addSubview:exchangeButton];
    [exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(136));
        make.height.equalTo(ROUND_WIDTH(136));
        make.center.equalTo(compoundImageView);
    }];
    
    UIImageView *summonImageView = [UIImageView new];
    [self addSubview:summonImageView];
    [summonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(106));
        make.height.equalTo(ROUND_HEIGHT(58));
        make.top.equalTo(compoundImageView.mas_bottom).offset(ROUND_HEIGHT_FLOAT(28));
        make.centerX.equalTo(compoundImageView);
    }];
    
    UILabel *introduceLabel = [UILabel new];
    introduceLabel.textColor = [UIColor whiteColor];
    introduceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [self addSubview:introduceLabel];
    [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ROUND_WIDTH(280));
        make.height.equalTo(ROUND_HEIGHT(75));
        make.top.equalTo(summonImageView.mas_bottom).offset(20);
        make.centerX.equalTo(summonImageView.mas_centerX);
    }];
    
    compoundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_skillpage_%@compound", _mascotNameArray[mascotType]]];
    [exchangeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_skillpage_%@compound_completed", _mascotNameArray[mascotType]]] forState:UIControlStateNormal];
    [exchangeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_skillpage_%@compound_completed_highlight", _mascotNameArray[mascotType]]] forState:UIControlStateHighlighted];
    summonImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_skillpage_%@", _mascotNameArray[mascotType]]];
}

- (void)closeButtonClick:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
