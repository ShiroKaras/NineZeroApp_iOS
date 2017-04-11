//
//  NZQuestionGiftView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/10.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import "NZQuestionGiftView.h"
#import "HTUIHeader.h"

#import "SKTicketView.h"

@implementation NZQuestionGiftView

- (instancetype)initWithFrame:(CGRect)frame withReward:(SKReward *)reward
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:scrollView];
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzledetailpage_gift"]];
        [scrollView addSubview:titleImageView];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
        }];
        
        UIImageView *rankTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_successtext1"]];
        [scrollView addSubview:rankTextImageView];
        [rankTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(titleImageView.mas_bottom).offset(31);
        }];
        
        UIImageView *textImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_gettext"]];
        [scrollView addSubview:textImageView1];
        [textImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rankTextImageView);
            make.top.equalTo(rankTextImageView.mas_bottom).offset(26);
        }];
        
        //金币
        UILabel *goldLabel = [UILabel new];
        goldLabel.text = @"5";
        goldLabel.textColor = COMMON_PINK_COLOR;
        goldLabel.font = MOON_FONT_OF_SIZE(30);
        [goldLabel sizeToFit];
        [scrollView addSubview:goldLabel];
        [goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textImageView1.mas_bottom).offset(13);
            make.right.equalTo(textImageView1);
        }];
        
        UIImageView *goldTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_gold"]];
        [scrollView addSubview:goldTextImageView];
        [goldTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(goldLabel);
            make.left.equalTo(goldLabel.mas_right).offset(6);
        }];
        
        //宝石
        UILabel *gemLabel = [UILabel new];
        gemLabel.text = @"5";
        gemLabel.textColor = COMMON_PINK_COLOR;
        gemLabel.font = MOON_FONT_OF_SIZE(30);
        [gemLabel sizeToFit];
        [scrollView addSubview:gemLabel];
        [gemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(goldLabel.mas_bottom).offset(13);
            make.right.equalTo(textImageView1);
        }];
        
        UIImageView *gemTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_diamonds"]];
        [scrollView addSubview:gemTextImageView];
        [gemTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(gemLabel);
            make.left.equalTo(gemLabel.mas_right).offset(6);
        }];
        
        //经验值
        UILabel *expLabel = [UILabel new];
        expLabel.text = @"5";
        expLabel.textColor = COMMON_PINK_COLOR;
        expLabel.font = MOON_FONT_OF_SIZE(30);
        [expLabel sizeToFit];
        [scrollView addSubview:expLabel];
        [expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(gemLabel.mas_bottom).offset(13);
            make.right.equalTo(textImageView1);
        }];
        
        UIImageView *expTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_exp"]];
        [scrollView addSubview:expTextImageView];
        [expTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(expLabel);
            make.left.equalTo(expLabel.mas_right).offset(6);
        }];
        
        [self layoutIfNeeded];
        
        SKTicketView *ticket = [[SKTicketView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/2, expTextImageView.bottom+31, 280, 108) reward:reward.ticket];
        [scrollView addSubview:ticket];
        
        scrollView.contentSize = CGSizeMake(frame.size.width, ticket.bottom);
    }
    return self;
}

@end


@interface NZQuestionFullScreenGiftView ()
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) SKReward *reward;
@end

@implementation NZQuestionFullScreenGiftView

- (instancetype)initWithFrame:(CGRect)frame withReward:(SKReward *)reward {
    self = [super initWithFrame:frame];
    if (self) {
        self.reward = reward;
        
        self.backgroundColor = [UIColor clearColor];
        UIView *alphaView = [[UIView alloc] initWithFrame:frame];
        alphaView.backgroundColor = COMMON_BG_COLOR;
        alphaView.alpha = 0.86;
        [self addSubview:alphaView];
        
        _dimmingView = [[UIView alloc] initWithFrame:frame];
        _dimmingView.backgroundColor = [UIColor clearColor];
        [self addSubview:_dimmingView];
        
        UILabel *bottomTextLabel = [UILabel new];
        bottomTextLabel.text = @"点击任意区域关闭";
        bottomTextLabel.textColor = [UIColor whiteColor];
        bottomTextLabel.font = PINGFANG_FONT_OF_SIZE(12);
        [bottomTextLabel sizeToFit];
        [self addSubview:bottomTextLabel];
        [bottomTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-16);
        }];
        
        UIImageView *rankTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_successtext1"]];
        [_dimmingView addSubview:rankTextImageView];
        [rankTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(ROUND_HEIGHT_FLOAT(157));
        }];
        
        UIImageView *textImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_gettext"]];
        [_dimmingView addSubview:textImageView1];
        [textImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rankTextImageView);
            make.top.equalTo(rankTextImageView.mas_bottom).offset(ROUND_HEIGHT_FLOAT(46));
        }];
        
        //金币
        UILabel *goldLabel = [UILabel new];
        goldLabel.text = @"5";
        goldLabel.textColor = COMMON_PINK_COLOR;
        goldLabel.font = MOON_FONT_OF_SIZE(30);
        [goldLabel sizeToFit];
        [_dimmingView addSubview:goldLabel];
        [goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textImageView1.mas_bottom).offset(13);
            make.right.equalTo(textImageView1);
        }];
        
        UIImageView *goldTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_gold"]];
        [_dimmingView addSubview:goldTextImageView];
        [goldTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(goldLabel);
            make.left.equalTo(goldLabel.mas_right).offset(6);
        }];
        
        //宝石
        UILabel *gemLabel = [UILabel new];
        gemLabel.text = @"5";
        gemLabel.textColor = COMMON_PINK_COLOR;
        gemLabel.font = MOON_FONT_OF_SIZE(30);
        [gemLabel sizeToFit];
        [_dimmingView addSubview:gemLabel];
        [gemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(goldLabel.mas_bottom).offset(13);
            make.right.equalTo(textImageView1);
        }];
        
        UIImageView *gemTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_diamonds"]];
        [_dimmingView addSubview:gemTextImageView];
        [gemTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(gemLabel);
            make.left.equalTo(gemLabel.mas_right).offset(6);
        }];
        
        //经验值
        UILabel *expLabel = [UILabel new];
        expLabel.text = @"5";
        expLabel.textColor = COMMON_PINK_COLOR;
        expLabel.font = MOON_FONT_OF_SIZE(30);
        [expLabel sizeToFit];
        [_dimmingView addSubview:expLabel];
        [expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(gemLabel.mas_bottom).offset(13);
            make.right.equalTo(textImageView1);
        }];
        
        UIImageView *expTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_exp"]];
        [_dimmingView addSubview:expTextImageView];
        [expTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(expLabel);
            make.left.equalTo(expLabel.mas_right).offset(6);
        }];
        
        [self layoutIfNeeded];
        
        if (reward.ticket != nil) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTicket)];
            tapGesture.numberOfTapsRequired = 1;
            [_dimmingView addGestureRecognizer:tapGesture];
        } else {
            if (reward.piece != nil) {
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTicket)];
                tapGesture.numberOfTapsRequired = 1;
                [_dimmingView addGestureRecognizer:tapGesture];
            } else {
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
                tapGesture.numberOfTapsRequired = 1;
                [_dimmingView addGestureRecognizer:tapGesture];
            }
        }
    }
    return self;
}

- (void)showTicket {
    for (UIView *view in _dimmingView.subviews) {
        [view removeFromSuperview];
    }
    
    _dimmingView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _dimmingView.alpha = 1;
    }];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [_dimmingView addSubview:backImageView];
    
    SKTicketView *ticket = [[SKTicketView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/2, ROUND_HEIGHT_FLOAT(180), 280, 108) reward:_reward.ticket];
    [_dimmingView addSubview:ticket];
    
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_congratulations1"]];
    [_dimmingView addSubview:textImageView];
    textImageView.centerX = _dimmingView.centerX;
    textImageView.bottom = _dimmingView.bottom -ROUND_HEIGHT_FLOAT(154);
}

- (void)showMascot {
    
    
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_congratulations2"]];
    [_dimmingView addSubview:textImageView];
    textImageView.centerX = _dimmingView.centerX;
    textImageView.bottom = _dimmingView.bottom -ROUND_HEIGHT_FLOAT(154);
    
    UIImageView *textImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_congratulations2"]];
    [_dimmingView addSubview:textImageView2];
    textImageView2.left = textImageView.left+31;
    textImageView2.top = textImageView.bottom+39;
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.text = @"24H";
    timeLabel.textColor = COMMON_PINK_COLOR;
    timeLabel.font = MOON_FONT_OF_SIZE(30);
    [timeLabel sizeToFit];
    timeLabel.left = textImageView2.right +4;
    timeLabel.bottom = textImageView2.bottom;
}

- (void)removeView {
    [self removeFromSuperview];
}

@end

