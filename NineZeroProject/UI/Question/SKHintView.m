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

@interface SKHintView () <SKMascotSkillDelegate>
@property (nonatomic, assign) NSInteger     season;
@property (nonatomic, strong) UILabel       *goldLabel;
@property (nonatomic, strong) UILabel       *gemLabel;
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
    
    [[[SKServiceManager sharedInstance] questionService] getHintListWithQuestionID:self.question.qid callback:^(BOOL success, NSInteger result, SKHintList *hintList) {
        _goldLabel.text = hintList.gold;
        
        self.hintList = hintList;
        ((UILabel*)[self viewWithTag:HINT_LABEL_1]).text = hintList.hint_one;
        ((UILabel*)[self viewWithTag:HINT_LABEL_2]).text = hintList.hint_two;
        ((UILabel*)[self viewWithTag:HINT_LABEL_3]).text = hintList.hint_three;
        
        if (![self.hintList.hint_one isEqualToString:@""]) {
            [self viewWithTag:HINT_BUTTON_1].hidden = YES;
        }
        if (![self.hintList.hint_two isEqualToString:@""]) {
            [self viewWithTag:HINT_BUTTON_2].hidden = YES;
        }
        if (![self.hintList.hint_three isEqualToString:@""]) {
            [self viewWithTag:HINT_BUTTON_3].hidden = YES;
        }
          
    }];
}

- (void)refreshData {
    [[[SKServiceManager sharedInstance] questionService] getQuestionDetailCluesWithQuestionID:self.question.qid callback:^(BOOL success, NSInteger result, SKHintList *hintList) {
        if (result==0) {
            self.hintList = hintList;
            
            ((UILabel*)[self viewWithTag:HINT_LABEL_1]).text = hintList.hint_one;
            ((UILabel*)[self viewWithTag:HINT_LABEL_2]).text = hintList.hint_two;
            ((UILabel*)[self viewWithTag:HINT_LABEL_3]).text = hintList.hint_three;
            
            if ([self.hintList.hint_one isEqualToString:@""]) {
                
            } else if ([self.hintList.hint_two isEqualToString:@""]) {
                [UIView animateWithDuration:0.3 animations:^{
                    [self viewWithTag:HINT_BUTTON_1].alpha = 0;
                } completion:^(BOOL finished) {
                    [self viewWithTag:HINT_BUTTON_1].hidden = 1;
                }];
            } else if ([self.hintList.hint_three isEqualToString:@""]) {
                [UIView animateWithDuration:0.3 animations:^{
                    [self viewWithTag:HINT_BUTTON_1].alpha = 0;
                    [self viewWithTag:HINT_BUTTON_2].alpha = 0;
                } completion:^(BOOL finished) {
                    [self viewWithTag:HINT_BUTTON_1].hidden = YES;
                    [self viewWithTag:HINT_BUTTON_2].hidden = YES;
                }];
            } else {
                [UIView animateWithDuration:0.3 animations:^{
                    [self viewWithTag:HINT_BUTTON_1].alpha = 0;
                    [self viewWithTag:HINT_BUTTON_2].alpha = 0;
                    [self viewWithTag:HINT_BUTTON_3].alpha = 0;
                } completion:^(BOOL finished) {
                    [self viewWithTag:HINT_BUTTON_1].hidden = YES;
                    [self viewWithTag:HINT_BUTTON_2].hidden = YES;
                    [self viewWithTag:HINT_BUTTON_3].hidden = YES;
                }];
            }

            //更新金币宝石数量
            
        }
    }];
}

- (void)createUIWithFrame:(CGRect)frame {
    UIView *alphaView = [[UIView alloc] initWithFrame:frame];
    alphaView.backgroundColor = COMMON_BG_COLOR;
    alphaView.alpha = 0.9;
    [self addSubview:alphaView];
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_close"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_puzzledetailpage_close_highlight"] forState:UIControlStateHighlighted];
    [self addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@33.5);
        make.left.equalTo(@13.5);
    }];
    
    //金币宝石数量
    UIImageView *goldImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzlepage_gold"]];
    [self addSubview:goldImageView];
    [goldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@31.5);
        make.right.equalTo(self).offset(-16);
    }];
    
    _goldLabel = [UILabel new];
    _goldLabel.text = @"9999";
    _goldLabel.textColor = [UIColor whiteColor];
    _goldLabel.font = MOON_FONT_OF_SIZE(16);
    [_goldLabel sizeToFit];
    [self addSubview:_goldLabel];
    [_goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goldImageView);
        make.right.equalTo(goldImageView.mas_left).offset(-6);
    }];
    
    //线索
    
    for (int i = 0; i<3; i++) {
        UIImageView *hintBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_helppage_clue2"]];
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
        hintLabel.numberOfLines = 2;
        [hintBackgroundView addSubview:hintLabel];
        [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(hintBackgroundView);
            make.width.equalTo(@240);
        }];
        
        NSString *intString;
        if (i == 0) {
            intString = @"消耗5金币";
        } else if (i == 1){
            intString = @"消耗10金币";
        } else {
            intString = @"消耗20金币";
        }
        UIButton *hintButton = [UIButton new];
        hintButton.tag = 200+i;
        [hintButton setTitle:[NSString stringWithFormat:@"线索%@",intString] forState:UIControlStateNormal];
        [hintButton addTarget:self action:@selector(getHintButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [hintButton setBackgroundImage:[UIImage imageNamed:@"btn_helppage_clue1"] forState:UIControlStateNormal];
        hintButton.adjustsImageWhenHighlighted = NO;
        [self addSubview:hintButton];
        [hintButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(hintBackgroundView);
            make.center.equalTo(hintBackgroundView);
        }];
    }
}

- (void)showPromptWithText:(NSString *)text {
    [[self viewWithTag:9002] removeFromSuperview];
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_article_prompt"]];
    [promptImageView sizeToFit];
    
    UIView *promptView = [UIView new];
    promptView.tag = 9002;
    promptView.size = promptImageView.size;
    promptView.center = self.center;
    promptView.alpha = 0;
    [self addSubview:promptView];
    
    promptImageView.frame = CGRectMake(0, 0, promptView.width, promptView.height);
    [promptView addSubview:promptImageView];
    
    UILabel *promptLabel = [UILabel new];
    promptLabel.text = text;
    promptLabel.textColor = [UIColor colorWithHex:0xD9D9D9];
    promptLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [promptLabel sizeToFit];
    [promptView addSubview:promptLabel];
    promptLabel.frame = CGRectMake(8.5, 11, promptView.width-17, 57);
    
    promptView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        promptView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:1.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            promptView.alpha = 0;
        } completion:^(BOOL finished) {
            [promptView removeFromSuperview];
        }];
    }];
}

//关闭
- (void)closeButtonClick:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

//获取提示
- (void)getHintButtonClick:(UIButton *)sender {
    [[[SKServiceManager sharedInstance] questionService] getHintWithQuestionID:_question.qid number:(int)sender.tag-200 callback:^(BOOL success, SKResponsePackage *response) {
        [self loadData];
    }];
}

- (void)showNumberLabelWithButton:(UIButton *)sender {
    UILabel *numberLabel = [UILabel new];
    numberLabel.text = @"-1";
    if (self.season == 1) {
        numberLabel.textColor = COMMON_GREEN_COLOR;
    } else if (self.season == 2)
        numberLabel.textColor = COMMON_PINK_COLOR;
    numberLabel.font = MOON_FONT_OF_SIZE(24);
    [numberLabel sizeToFit];
    [self addSubview:numberLabel];
    numberLabel.centerX = sender.centerX;
    numberLabel.centerY = sender.centerY;
    
    [UIView animateWithDuration:1 animations:^{
        numberLabel.centerY -= 100;
        numberLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [numberLabel removeFromSuperview];
    }];
}

- (void)addButtonClick:(UIButton *)sender {
    SKMascotSkillView *purchaseView = [[SKMascotSkillView alloc] initWithFrame:self.frame Type:SKMascotTypeDefault isHad:YES];
    purchaseView.delegate = self;
    purchaseView.alpha = 0;
    [self addSubview:purchaseView];
    [UIView animateWithDuration:0.3 animations:^{
        purchaseView.alpha = 1;
    }];
}

#pragma mark - SKMascotSkillDelegate

- (void)didClickCloseButtonMascotSkillView:(SKMascotSkillView *)view {
    [self loadData];
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
