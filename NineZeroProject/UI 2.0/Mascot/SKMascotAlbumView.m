//
//  SKMascotAlbumView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/26.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKMascotAlbumView.h"
#import "HTUIHeader.h"

@interface SKMascotAlbumView ()
@property (nonatomic, strong) NSArray *mascotIndexArray;
@end

@implementation SKMascotAlbumView

- (instancetype)initWithFrame:(CGRect)frame withMascotArray:(NSArray<SKPet*>*)mascotArray {
    self = [super initWithFrame:frame];
    if (self) {
        _mascotArray = mascotArray;
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
    backView.backgroundColor = [UIColor clearColor];
    backView.center = self.center;
    [self addSubview:backView];
    
    UIImageView *mascot_greed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_greed"]];
    [mascot_greed sizeToFit];
    [backView addSubview:mascot_greed];
    [mascot_greed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ROUND_WIDTH(112));
        make.top.equalTo(backView);
        make.width.equalTo(ROUND_WIDTH(392));
        make.height.equalTo(ROUND_WIDTH(369.5));
    }];
    UIImageView *mascot_greed_completed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_greed_completed"]];
    [mascot_greed_completed sizeToFit];
    [backView addSubview:mascot_greed_completed];
    [mascot_greed_completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(mascot_greed);
        make.center.equalTo(mascot_greed);
    }];
    
    UIImageView *mascot_lust = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_lust"]];
    [mascot_lust sizeToFit];
    [backView addSubview:mascot_lust];
    [mascot_lust mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ROUND_WIDTH(5));
        make.top.equalTo(ROUND_HEIGHT(66));
        make.width.equalTo(ROUND_WIDTH(147));
        make.height.equalTo(ROUND_WIDTH(60.5));
    }];
    UIImageView *mascot_lust_completed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_lust_completed"]];
    [mascot_lust_completed sizeToFit];
    [backView addSubview:mascot_lust_completed];
    [mascot_lust_completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(mascot_lust);
        make.center.equalTo(mascot_lust);
    }];
    
    UIImageView *mascot_pride = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_pride"]];
    [mascot_pride sizeToFit];
    [backView addSubview:mascot_pride];
    [mascot_pride mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ROUND_WIDTH(85.5));
        make.top.equalTo(ROUND_HEIGHT(146));
        make.width.equalTo(ROUND_WIDTH(103.5));
        make.height.equalTo(ROUND_WIDTH(223.5));
    }];
    UIImageView *mascot_pride_completed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_pride_completed"]];
    [mascot_pride_completed sizeToFit];
    [backView addSubview:mascot_pride_completed];
    [mascot_pride_completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(mascot_pride);
        make.center.equalTo(mascot_pride);
    }];
    
    UIImageView *mascot_wrath = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_wrath"]];
    [mascot_wrath sizeToFit];
    [backView addSubview:mascot_wrath];
    [mascot_wrath mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ROUND_WIDTH(-182.5));
        make.bottom.equalTo(ROUND_HEIGHT(-43));
        make.width.equalTo(ROUND_WIDTH(160));
        make.height.equalTo(ROUND_WIDTH(128));
    }];
    UIImageView *mascot_wrath_completed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_wrath_completed"]];
    [mascot_wrath_completed sizeToFit];
    [backView addSubview:mascot_wrath_completed];
    [mascot_wrath_completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(mascot_wrath);
        make.center.equalTo(mascot_wrath);
    }];
    
    UIImageView *mascot_gluttony = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_gluttony"]];
    [mascot_gluttony sizeToFit];
    [backView addSubview:mascot_gluttony];
    [mascot_gluttony mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ROUND_WIDTH(-12));
        make.top.equalTo(ROUND_HEIGHT(234.5));
        make.width.equalTo(ROUND_WIDTH(126.5));
        make.height.equalTo(ROUND_WIDTH(142.5));
    }];
    UIImageView *mascot_gluttony_completed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_gluttony_completed"]];
    [mascot_gluttony_completed sizeToFit];
    [backView addSubview:mascot_gluttony_completed];
    [mascot_gluttony_completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(mascot_gluttony);
        make.center.equalTo(mascot_gluttony);
    }];
    
    UIImageView *mascot_sloth = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_sloth"]];
    [mascot_sloth sizeToFit];
    [backView addSubview:mascot_sloth];
    [mascot_sloth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ROUND_WIDTH(-49));
        make.bottom.equalTo(ROUND_HEIGHT(-18.5));
        make.width.equalTo(ROUND_WIDTH(133));
        make.height.equalTo(ROUND_WIDTH(83.5));
    }];
    UIImageView *mascot_sloth_completed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_sloth_completed"]];
    [mascot_sloth_completed sizeToFit];
    [backView addSubview:mascot_sloth_completed];
    [mascot_sloth_completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(mascot_sloth);
        make.center.equalTo(mascot_sloth);
    }];
    
    UIImageView *mascot_lingzai = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_lingzai"]];
    [mascot_lingzai sizeToFit];
    [backView addSubview:mascot_lingzai];
    [mascot_lingzai mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ROUND_WIDTH(94));
        make.bottom.equalTo(ROUND_HEIGHT(-4.5));
        make.width.equalTo(ROUND_WIDTH(59));
        make.height.equalTo(ROUND_WIDTH(84.5));
    }];
    UIImageView *mascot_lingzai_completed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_lingzai_completed"]];
    [mascot_lingzai_completed sizeToFit];
    [backView addSubview:mascot_lingzai_completed];
    [mascot_lingzai_completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(mascot_lingzai);
        make.center.equalTo(mascot_lingzai);
    }];
    
    UIImageView *mascot_envy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_envy"]];
    [mascot_envy sizeToFit];
    [backView addSubview:mascot_envy];
    [mascot_envy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ROUND_WIDTH(-7));
        make.bottom.equalTo(ROUND_HEIGHT(0));
        make.width.equalTo(ROUND_WIDTH(56));
        make.height.equalTo(ROUND_WIDTH(70));
    }];
    UIImageView *mascot_envy_completed = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_lingzaipage_albums_envy_completed"]];
    [mascot_envy_completed sizeToFit];
    [backView addSubview:mascot_envy_completed];
    [mascot_envy_completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(mascot_envy);
        make.center.equalTo(mascot_envy);
    }];
    
    mascot_greed_completed.hidden = YES;
    mascot_lingzai_completed.hidden     = !self.mascotArray[0].user_haved;
    mascot_sloth_completed.hidden       = !self.mascotArray[1].user_haved;
    mascot_pride_completed.hidden       = !self.mascotArray[2].user_haved;
    mascot_wrath_completed.hidden       = !self.mascotArray[3].user_haved;
    mascot_gluttony_completed.hidden    = !self.mascotArray[4].user_haved;
    mascot_lust_completed.hidden        = !self.mascotArray[5].user_haved;
    mascot_envy_completed.hidden        = !self.mascotArray[6].user_haved;
}

- (void)closeButtonClick:(UIButton*)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
