//
//  SKHintView.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/18.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKHintView.h"
#import "HTUIHeader.h"

#import "SKMascotView.h"

#define HINT_LABEL_1 100
#define HINT_LABEL_2 101
#define HINT_LABEL_3 102

#define HINT_BUTTON_1 200
#define HINT_BUTTON_2 201
#define HINT_BUTTON_3 202

@interface SKHintView ()
@property (nonatomic, assign) NSInteger     season;
@property (nonatomic, assign) NSInteger     hintPropCount;
@property (nonatomic, strong) UIImageView   *iconImageView;     //标记
@property (nonatomic, strong) UIButton      *addButton;
@property (nonatomic, strong) UILabel       *propCountLabel;
@property (nonatomic, strong) SKQuestion    *question;
@property (nonatomic, strong) SKHintList    *hintList;
@end

@implementation SKHintView

- (instancetype)initWithFrame:(CGRect)frame questionID:(SKQuestion*)question season:(NSInteger)season {
    self = [super initWithFrame:frame];
    if (self) {
        self.season = season;
        self.question = question;
        [self createUIWithFrame:frame];
        [self loadData];
    }
    return self;
}

- (void)loadData {
    //关卡线索列表
    [[[SKServiceManager sharedInstance] questionService] getQuestionDetailCluesWithQuestionID:self.question.qid callback:^(BOOL success, NSInteger result, SKHintList *hintList) {
        if (result==0) {
            self.hintList = hintList;
            
            ((UILabel*)[self viewWithTag:HINT_LABEL_1]).text = hintList.hint_one;
            ((UILabel*)[self viewWithTag:HINT_LABEL_2]).text = hintList.hint_two;
            ((UILabel*)[self viewWithTag:HINT_LABEL_3]).text = hintList.hint_three;
            
            if ([self.hintList.hint_one isEqualToString:@""]) {

            } else if ([self.hintList.hint_two isEqualToString:@""]) {
                [self viewWithTag:HINT_BUTTON_1].hidden = YES;
            } else if ([self.hintList.hint_three isEqualToString:@""]) {
                [self viewWithTag:HINT_BUTTON_1].hidden = YES;
                [self viewWithTag:HINT_BUTTON_2].hidden = YES;
            } else {
                [self viewWithTag:HINT_BUTTON_1].hidden = YES;
                [self viewWithTag:HINT_BUTTON_2].hidden = YES;
                [self viewWithTag:HINT_BUTTON_3].hidden = YES;
            }
            
            //更新道具数量
            DLog(@"%ld", hintList.num);
            self.hintPropCount = self.hintList.num;
            if (self.hintPropCount==0) {
                _iconImageView.image = [UIImage imageNamed:@"btn_detailspage_clue_add"];
            } else {
                _iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"btn_detailspage_clue_season%lu",(unsigned long)_season]];
            }
            _propCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.hintPropCount];
        }
    }];
}

- (void)createUIWithFrame:(CGRect)frame {
    UIView *alphaView = [[UIView alloc] initWithFrame:frame];
    alphaView.backgroundColor = [UIColor colorWithHex:0x0e0e0e];
    alphaView.alpha = 0.9;
    [self addSubview:alphaView];
    
    UIView *rightCornerBackView = [UIView new];
    rightCornerBackView.layer.cornerRadius = 15;
    rightCornerBackView.layer.masksToBounds = YES;
    rightCornerBackView.backgroundColor = [UIColor blackColor];
    [self addSubview:rightCornerBackView];
    [rightCornerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(97+15));
        make.height.equalTo(@30);
        make.right.equalTo(self).offset(15);
        make.top.equalTo(@13);
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
    
    //线索数量
    _iconImageView = [UIImageView new];
    if (self.hintPropCount==0) {
        _iconImageView.image = [UIImage imageNamed:@"btn_detailspage_clue_add"];
    } else {
        _iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"btn_detailspage_clue_season%lu",(unsigned long)_season]];
    }
    [rightCornerBackView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.left.equalTo(rightCornerBackView).offset(2.5);
        make.centerY.equalTo(rightCornerBackView);
    }];
    
    
    _addButton = [UIButton new];
    [_addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightCornerBackView addSubview:_addButton];
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(rightCornerBackView);
        make.center.equalTo(rightCornerBackView);
    }];
    
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_popup_solution_text"]];
    [textImageView sizeToFit];
    [rightCornerBackView addSubview:textImageView];
    [textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(6);
        make.centerY.equalTo(_iconImageView);
    }];
    
    _propCountLabel = [UILabel new];
    _propCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.hintPropCount];
    _propCountLabel.textColor = [UIColor whiteColor];
    _propCountLabel.font = MOON_FONT_OF_SIZE(18);
    [_propCountLabel sizeToFit];
    [rightCornerBackView addSubview:_propCountLabel];
    [_propCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textImageView.mas_right).offset(4);
        make.centerY.equalTo(textImageView);
    }];
    
    for (int i = 0; i<3; i++) {
        UIImageView *hintBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detailspage_cluebg"]];
        [self addSubview:hintBackgroundView];
        [hintBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@260);
            make.height.equalTo(@75);
            make.top.equalTo(@(ROUND_HEIGHT_FLOAT(132) + (75+ROUND_HEIGHT_FLOAT(70))*i));
            make.centerX.equalTo(self);
        }];
        
        UILabel *hintLabel = [UILabel new];
        hintLabel.tag = 100+i;
        hintLabel.text = @"";
        hintLabel.textColor = [UIColor whiteColor];
        hintLabel.font = PINGFANG_FONT_OF_SIZE(16);
        [hintBackgroundView addSubview:hintLabel];
        [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(hintBackgroundView);
        }];
        
        NSString *intString;
        if (i == 0) {
            intString = @"一";
        } else if (i == 1){
            intString = @"二";
        } else {
            intString = @"三";
        }
        UIButton *hintButton = [UIButton new];
        hintButton.tag = 200+i;
        [hintButton setTitle:[NSString stringWithFormat:@"线索%@",intString] forState:UIControlStateNormal];
        [hintButton addTarget:self action:@selector(getHintButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [hintButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_detailspage_season%lu",(unsigned long)_season]] forState:UIControlStateNormal];
        hintButton.adjustsImageWhenHighlighted = NO;
        [self addSubview:hintButton];
        [hintButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(hintBackgroundView);
            make.center.equalTo(hintBackgroundView);
        }];
    }
}

- (void)showAlertViewWithText:(NSString *)text {
    UIView *alertViewBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    alertViewBackView.backgroundColor = [UIColor clearColor];
    [self addSubview:alertViewBackView];
    
    UIImageView *propmtImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_article_prompt"]];
    [propmtImageView sizeToFit];
    [alertViewBackView addSubview:propmtImageView];
    [propmtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(alertViewBackView);
    }];
    
    UILabel *_promptLabel = [UILabel new];
    _promptLabel.text = text;
    _promptLabel.textColor = [UIColor colorWithHex:0xD9D9D9];
    _promptLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    [_promptLabel sizeToFit];
    [propmtImageView addSubview:_promptLabel];
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(propmtImageView);
        make.centerY.equalTo(propmtImageView).offset(10);
    }];
    
    [UIView animateWithDuration:0.5 delay:3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        alertViewBackView.alpha = 0;
    } completion:^(BOOL finished) {
        [alertViewBackView removeFromSuperview];
    }];
}

//关闭
- (void)closeButtonClick:(UIButton *)sender {
    [self removeFromSuperview];
}

//获取提示
- (void)getHintButtonClick:(UIButton *)sender {
    if (self.hintPropCount == 0) {
        [self showAlertViewWithText:@"线索道具已用完"];
    } else {
        if ([self.hintList.hint_one isEqualToString:@""]) {
            if (sender.tag == HINT_BUTTON_2 || sender.tag == HINT_BUTTON_3) {
                [self showAlertViewWithText:@"请先解锁前面的线索"];
                return;
            }
        } else if ([self.hintList.hint_two isEqualToString:@""]) {
            if (sender.tag == HINT_BUTTON_3) {
                [self showAlertViewWithText:@"请先解锁前面的线索"];
                return;
            }
        }
        
        [[[SKServiceManager sharedInstance] questionService] purchaseQuestionClueWithQuestionID:self.question.qid callback:^(BOOL success, SKResponsePackage *response) {
            if (response.result == 0) {
                [[self viewController] showTipsWithText:@"获得新的线索"];
            } else if (response.result == -3007) {
                [[self viewController] showTipsWithText:@"已经获得所有线索"];
            } else if (response.result == -3008) {
                [[self viewController] showTipsWithText:@"线索道具不足"];
            }
            [self loadData];
        }];
    }
}

- (void)addButtonClick:(UIButton *)sender {
    SKMascotSkillView *purchaseView = [[SKMascotSkillView alloc] initWithFrame:self.frame Type:SKMascotTypeDefault isHad:YES];
    [self addSubview:purchaseView];
}

//获取view对应的控制器
- (UIViewController*)viewController {
    for (UIView* nextVC = [self superview]; nextVC; nextVC = nextVC.superview) {
        UIResponder* nextResponder = [nextVC nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
