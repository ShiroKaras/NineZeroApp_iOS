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

#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <CommonCrypto/CommonDigest.h>

#define SHARE_URL(u) [NSString stringWithFormat:@"http://h5.90app.tv/app90/shareCrime?c_id=%@", (u)]

typedef NS_ENUM(NSInteger, HTButtonType) {
    HTButtonTypeShare = 0,
    HTButtonTypeCancel,
    HTButtonTypeWechat,
    HTButtonTypeMoment,
    HTButtonTypeWeibo,
    HTButtonTypeQQ
};

@implementation NZQuestionGiftView

- (instancetype)initWithFrame:(CGRect)frame withReward:(SKReward *)reward
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_scrollView];
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_puzzledetailpage_gift"]];
        [_scrollView addSubview:titleImageView];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@16);
            make.left.equalTo(@16);
        }];
        
        UIImageView *rankTextImageView;
        if (reward.rank<10) {
            rankTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_successtext2"]];
            [_scrollView addSubview:rankTextImageView];
            [rankTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                if (reward.ticket != nil)
                    make.top.equalTo(titleImageView.mas_bottom).offset(31);
                else
                    make.top.equalTo(titleImageView.mas_bottom).offset((self.height-152-64-49)/2);
            }];
            
            UILabel *percentLabel = [UILabel new];
            percentLabel.font = MOON_FONT_OF_SIZE(40);
            percentLabel.textColor = COMMON_PINK_COLOR;
            percentLabel.text = [NSString stringWithFormat:@"%ld",reward.rank];
            [percentLabel sizeToFit];
            [_scrollView addSubview:percentLabel];
            [percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(rankTextImageView.mas_left).offset(88.5);
                make.bottom.equalTo(rankTextImageView.mas_bottom).offset(-20);
            }];
        } else {
            rankTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_successtext1"]];
            [_scrollView addSubview:rankTextImageView];
            [rankTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                if (reward.ticket != nil)
                    make.top.equalTo(titleImageView.mas_bottom).offset(31);
                else
                    make.top.equalTo(titleImageView.mas_bottom).offset((self.height-152-64-49)/2);
            }];
            
            UILabel *percentLabel = [UILabel new];
            percentLabel.font = MOON_FONT_OF_SIZE(40);
            percentLabel.textColor = COMMON_PINK_COLOR;
            percentLabel.text = reward.rank>700? @"30%" : [[NSString stringWithFormat:@"%.1lf", 100. - reward.rank / 10.] stringByAppendingString:@"%"];
            [percentLabel sizeToFit];
            [_scrollView addSubview:percentLabel];
            [percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(rankTextImageView.mas_left).offset(98);
                make.bottom.equalTo(rankTextImageView.mas_bottom).offset(-27);
            }];
        }
        
        UIImageView *textImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_gettext"]];
        [_scrollView addSubview:textImageView1];
        [textImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rankTextImageView);
            make.top.equalTo(rankTextImageView.mas_bottom).offset(26);
        }];
        
        //金币
        UILabel *goldLabel = [UILabel new];
        goldLabel.text = reward.gold==nil?@"0":reward.gold;
        goldLabel.textColor = COMMON_PINK_COLOR;
        goldLabel.font = MOON_FONT_OF_SIZE(30);
        [goldLabel sizeToFit];
        [_scrollView addSubview:goldLabel];
        [goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textImageView1.mas_bottom).offset(13);
            make.right.equalTo(textImageView1);
        }];
        
        UIImageView *goldTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_gold"]];
        [_scrollView addSubview:goldTextImageView];
        [goldTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(goldLabel);
            make.left.equalTo(goldLabel.mas_right).offset(6);
        }];
        
        //宝石
        UILabel *gemLabel = [UILabel new];
        gemLabel.text = reward.gemstone==nil?@"0":reward.gemstone;
        gemLabel.textColor = COMMON_PINK_COLOR;
        gemLabel.font = MOON_FONT_OF_SIZE(30);
        [gemLabel sizeToFit];
        [_scrollView addSubview:gemLabel];
        [gemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(goldLabel.mas_bottom).offset(13);
            make.right.equalTo(textImageView1);
        }];
        
        UIImageView *gemTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_diamonds"]];
        [_scrollView addSubview:gemTextImageView];
        [gemTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(gemLabel);
            make.left.equalTo(gemLabel.mas_right).offset(6);
        }];
        
        //经验值
        UILabel *expLabel = [UILabel new];
        expLabel.text = reward.experience_value==nil?@"0":reward.experience_value;
        expLabel.textColor = COMMON_PINK_COLOR;
        expLabel.font = MOON_FONT_OF_SIZE(30);
        [expLabel sizeToFit];
        [_scrollView addSubview:expLabel];
        [expLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(gemLabel.mas_bottom).offset(13);
            make.right.equalTo(textImageView1);
        }];
        
        UIImageView *expTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_exp"]];
        [_scrollView addSubview:expTextImageView];
        [expTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(expLabel);
            make.left.equalTo(expLabel.mas_right).offset(6);
        }];
        
        [self layoutIfNeeded];
        
        _scrollView.contentSize = CGSizeMake(frame.size.width, expTextImageView.bottom+16);
        
        if (reward.ticket != nil) {
            SKTicketView *ticket = [[SKTicketView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/2, expTextImageView.bottom+31, 280, 108) reward:reward.ticket];
            [_scrollView addSubview:ticket];
            _scrollView.contentSize = CGSizeMake(frame.size.width, ticket.bottom+16);
        }
        
        
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
        
        if (reward.gold!=nil || reward.gemstone!=nil) {
            _dimmingView.alpha = 0;
            [UIView animateWithDuration:0.2 animations:^{
                _dimmingView.alpha = 1;
            }];
            
            UIImageView *rankTextImageView;
            if (reward.rank) {
                //排名
                if (reward.rank<10) {
                    rankTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_successtext2"]];
                    [_dimmingView addSubview:rankTextImageView];
                    [rankTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self);
                        make.top.equalTo(self).offset(ROUND_HEIGHT_FLOAT(157));
                    }];
                    
                    UILabel *percentLabel = [UILabel new];
                    percentLabel.font = MOON_FONT_OF_SIZE(40);
                    percentLabel.textColor = COMMON_PINK_COLOR;
                    percentLabel.text = [NSString stringWithFormat:@"%ld",(long)reward.rank];
                    [percentLabel sizeToFit];
                    [_dimmingView addSubview:percentLabel];
                    [percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(rankTextImageView.mas_left).offset(106);
                        make.bottom.equalTo(rankTextImageView.mas_bottom).offset(-20);
                    }];
                } else {
                    rankTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_successtext1"]];
                    [_dimmingView addSubview:rankTextImageView];
                    [rankTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self);
                        make.top.equalTo(self).offset(ROUND_HEIGHT_FLOAT(157));
                    }];
                    
                    UILabel *percentLabel = [UILabel new];
                    percentLabel.font = MOON_FONT_OF_SIZE(40);
                    percentLabel.textColor = COMMON_PINK_COLOR;
                    percentLabel.text = self.reward.rank>700? @"30%" : [[NSString stringWithFormat:@"%.1lf", 100. - self.reward.rank / 10.] stringByAppendingString:@"%"];
                    [percentLabel sizeToFit];
                    [_dimmingView addSubview:percentLabel];
                    [percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(rankTextImageView.mas_left).offset(106);
                        make.bottom.equalTo(rankTextImageView.mas_bottom).offset(-20);
                    }];
                }
            } else {
                //无排名
                rankTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_successtext1"]];
                [_dimmingView addSubview:rankTextImageView];
                [rankTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.top.equalTo(self).offset(ROUND_HEIGHT_FLOAT(157));
                }];
            }
            
            UIImageView *textImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_gettext"]];
            [_dimmingView addSubview:textImageView1];
            [textImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(rankTextImageView);
                make.top.equalTo(rankTextImageView.mas_bottom).offset(ROUND_HEIGHT_FLOAT(46));
            }];
            
            //金币
            UILabel *goldLabel = [UILabel new];
            goldLabel.text = reward.gold;
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
            gemLabel.text = reward.gemstone;
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
            expLabel.text = reward.experience_value;
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
                if (reward.petCoop !=nil) {
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMascot)];
                    tapGesture.numberOfTapsRequired = 1;
                    [_dimmingView addGestureRecognizer:tapGesture];
                } else {
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
                    tapGesture.numberOfTapsRequired = 1;
                    [_dimmingView addGestureRecognizer:tapGesture];
                }
            }
        } else {
            //无金币 宝石 经验值
            if (reward.ticket != nil) {
                [self showTicket];
            } else {
                if (reward.petCoop !=nil) {
                    [self showMascot];
                } else {
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
                    tapGesture.numberOfTapsRequired = 1;
                    [_dimmingView addGestureRecognizer:tapGesture];
                }
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
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    if (IPHONE5_SCREEN_WIDTH == SCREEN_WIDTH) {
        bgImageView.image = [UIImage imageNamed:@"img_img_popup_giftbg_640"];
    } else if (IPHONE6_SCREEN_WIDTH == SCREEN_WIDTH) {
        bgImageView.image = [UIImage imageNamed:@"img_img_popup_giftbg_750"];
    } else if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH) {
        bgImageView.image = [UIImage imageNamed:@"img_img_popup_giftbg_1242"];
    }
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.frame = _dimmingView.frame;
    [_dimmingView addSubview:bgImageView];
    
    SKTicketView *ticket = [[SKTicketView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/2, ROUND_HEIGHT_FLOAT(180), 280, 108) reward:_reward.ticket];
    [_dimmingView addSubview:ticket];
    
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_congratulations1"]];
    [_dimmingView addSubview:textImageView];
    textImageView.centerX = _dimmingView.centerX;
    textImageView.bottom = _dimmingView.bottom -ROUND_HEIGHT_FLOAT(154);
    
    for (UITapGestureRecognizer *tap in _dimmingView.gestureRecognizers) {
        [_dimmingView removeGestureRecognizer:tap];
    }
    
    if (self.reward.petCoop !=nil) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMascot)];
        tapGesture.numberOfTapsRequired = 1;
        [_dimmingView addGestureRecognizer:tapGesture];
    } else {
        UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
        tapGesture.numberOfTapsRequired = 1;
        [_dimmingView addGestureRecognizer:tapGesture];
    }
}

- (void)showMascot {
    for (UIView *view in _dimmingView.subviews) {
        [view removeFromSuperview];
    }
    
    _dimmingView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _dimmingView.alpha = 1;
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    if (IPHONE5_SCREEN_WIDTH == SCREEN_WIDTH) {
        bgImageView.image = [UIImage imageNamed:@"img_img_popup_giftbg_640"];
    } else if (IPHONE6_SCREEN_WIDTH == SCREEN_WIDTH) {
        bgImageView.image = [UIImage imageNamed:@"img_img_popup_giftbg_750"];
    } else if (IPHONE6_PLUS_SCREEN_WIDTH == SCREEN_WIDTH) {
        bgImageView.image = [UIImage imageNamed:@"img_img_popup_giftbg_1242"];
    }
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.frame = _dimmingView.frame;
    [_dimmingView addSubview:bgImageView];
    
    UIImageView *mascotImageView = [UIImageView new];
    mascotImageView.width = ROUND_WIDTH_FLOAT(252);
    mascotImageView.height = ROUND_WIDTH_FLOAT(252);
    mascotImageView.top = ROUND_HEIGHT_FLOAT(80);
    mascotImageView.centerX = self.centerX;
    [self addSubview:mascotImageView];
    [mascotImageView sd_setImageWithURL:[NSURL URLWithString:self.reward.petCoop.crime_pic]];
    
    UIImageView *textImageView;
    if ([self.cityCode isEqualToString:@"999"]) {
        //luhan
        textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_specialpage_title"]];
    } else {
        textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_congratulations2"]];
    }
    [_dimmingView addSubview:textImageView];
    textImageView.centerX = _dimmingView.centerX;
    textImageView.bottom = _dimmingView.bottom -ROUND_HEIGHT_FLOAT(154);
    
    UIImageView *textImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_giftpage_addtime"]];
    [_dimmingView addSubview:textImageView2];
    textImageView2.left = textImageView.left+31;
    textImageView2.top = textImageView.bottom+39;
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.text = [self.reward.petCoop.hour stringByAppendingString:@"H"];
    timeLabel.textColor = COMMON_PINK_COLOR;
    timeLabel.font = MOON_FONT_OF_SIZE(30);
    [timeLabel sizeToFit];
    [_dimmingView addSubview:timeLabel];
    timeLabel.left = textImageView2.right+8;
    timeLabel.bottom = textImageView2.bottom+8;
    
    for (UITapGestureRecognizer *tap in _dimmingView.gestureRecognizers) {
        [_dimmingView removeGestureRecognizer:tap];
    }
    
    if ([self.cityCode isEqualToString:@"999"]) {
        //luhan
        UIButton *shareButton = [UIButton new];
        [shareButton addTarget:self action:@selector(shareMascot:) forControlEvents:UIControlEventTouchUpInside];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"btn_share_highlight"] forState:UIControlStateHighlighted];
        shareButton.size = CGSizeMake(_dimmingView.width, ROUND_HEIGHT_FLOAT(49));
        shareButton.bottom = _dimmingView.height;
        shareButton.centerX = _dimmingView.width/2;
        [_dimmingView addSubview:shareButton];
        
        UIButton *closeButton = [UIButton new];
        [closeButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setImage:[UIImage imageNamed:@"btn_puzzledetailpage_close"] forState:UIControlStateNormal];
        [closeButton setImage:[UIImage imageNamed:@"btn_puzzledetailpage_close_highlight"] forState:UIControlStateHighlighted];
        closeButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(27), ROUND_WIDTH_FLOAT(27));
        closeButton.left = ROUND_WIDTH_FLOAT(13.5);
        closeButton.top = ROUND_HEIGHT_FLOAT(28.5);
        [_dimmingView addSubview:closeButton];
    } else {
        UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
        tapGesture.numberOfTapsRequired = 1;
        [_dimmingView addGestureRecognizer:tapGesture];
    }
    
}

- (void)removeView {
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(didHideFullScreenGiftView)]) {
        [self.delegate didHideFullScreenGiftView];
    }
}

- (void)shareMascot:(UIButton*)sender {
    for (UIView *view in _dimmingView.subviews) {
        [view removeFromSuperview];
    }
    _dimmingView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _dimmingView.alpha = 1;
    }];
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:[UIImage imageNamed:@"btn_puzzledetailpage_close"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"btn_puzzledetailpage_close_highlight"] forState:UIControlStateHighlighted];
    closeButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(27), ROUND_WIDTH_FLOAT(27));
    closeButton.left = ROUND_WIDTH_FLOAT(13.5);
    closeButton.top = ROUND_HEIGHT_FLOAT(28.5);
    [_dimmingView addSubview:closeButton];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(115.5), ROUND_WIDTH_FLOAT(20))];
    titleImageView.image = [UIImage imageNamed:@"img_speciallabsharepage_title"];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    titleImageView.centerX = _dimmingView.width/2;
    titleImageView.top = ROUND_HEIGHT_FLOAT(207);
    [_dimmingView addSubview:titleImageView];
    
    UIButton *wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatButton setImage:[UIImage imageNamed:@"btn_sharepage_wechat"] forState:UIControlStateNormal];
    [wechatButton setImage:[UIImage imageNamed:@"btn_sharepage_wechat_highlight"] forState:UIControlStateHighlighted];
    [wechatButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [wechatButton sizeToFit];
    wechatButton.tag = HTButtonTypeWechat;
    wechatButton.alpha = 1;
    [_dimmingView addSubview:wechatButton];
    
    UIButton *momentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [momentButton setImage:[UIImage imageNamed:@"btn_sharepage_friendcircle"] forState:UIControlStateNormal];
    [momentButton setImage:[UIImage imageNamed:@"btn_sharepage_friendcircle_highlight"] forState:UIControlStateHighlighted];
    [momentButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [momentButton sizeToFit];
    momentButton.tag = HTButtonTypeMoment;
    momentButton.alpha = 1;
    [_dimmingView addSubview:momentButton];
    
    UIButton *weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [weiboButton setImage:[UIImage imageNamed:@"btn_sharepage_weibo"] forState:UIControlStateNormal];
    [weiboButton setImage:[UIImage imageNamed:@"btn_sharepage_weibo_highlight"] forState:UIControlStateHighlighted];
    [weiboButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [weiboButton sizeToFit];
    weiboButton.tag = HTButtonTypeWeibo;
    weiboButton.alpha = 1;
    [_dimmingView addSubview:weiboButton];
    
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqButton setImage:[UIImage imageNamed:@"btn_sharepage_qq"] forState:UIControlStateNormal];
    [qqButton setImage:[UIImage imageNamed:@"btn_sharepage_qq_highlight"] forState:UIControlStateHighlighted];
    [qqButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [qqButton sizeToFit];
    qqButton.tag = HTButtonTypeQQ;
    qqButton.alpha = 1;
    [_dimmingView addSubview:qqButton];
    
    __weak UIView *weakShareView = _dimmingView;
    float padding = (SCREEN_WIDTH - wechatButton.width * 4) / 5;
    
    [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakShareView.mas_left).mas_offset(padding);
        make.top.equalTo(titleImageView.mas_bottom).mas_offset(80);
    }];
    
    [momentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wechatButton.mas_right).mas_offset(padding);
        make.top.equalTo(titleImageView.mas_bottom).mas_offset(80);
    }];
    
    [weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(momentButton.mas_right).mas_offset(padding);
        make.top.equalTo(titleImageView.mas_bottom).mas_offset(80);
    }];
    
    [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weiboButton.mas_right).mas_offset(padding);
        make.top.equalTo(titleImageView.mas_bottom).mas_offset(80);
    }];
    
}

#pragma mark - Share

- (void)shareWithThirdPlatform:(UIButton *)sender {
    [TalkingData trackEvent:@"share"];
    HTButtonType type = (HTButtonType)sender.tag;
    switch (type) {
        case HTButtonTypeWechat: {
            if (![WXApi isWXAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            NSArray *imageArray = @[self.reward.petCoop.crime_pic];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@""
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(self.reward.petCoop.id)]
                                                  title:nil
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatSession
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     DLog(@"State -> %lu", (unsigned long)state);
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self removeView];
                             
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil, nil];
                             [alert show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            break;
        }
        case HTButtonTypeMoment: {
            if (![WXApi isWXAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray *imageArray = @[self.reward.petCoop.crime_pic];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:nil
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(self.reward.petCoop.id)]
                                                  title:@""
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self removeView];
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil, nil];
                             [alert show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            break;
        }
        case HTButtonTypeWeibo: {
            if (![WeiboSDK isWeiboAppInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray *imageArray = @[self.reward.petCoop.crime_pic];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ %@ 来自@九零APP",@"", SHARE_URL(self.reward.petCoop.id)]
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(self.reward.petCoop.id)]
                                                  title:nil
                                                   type:SSDKContentTypeImage];
                [ShareSDK share:SSDKPlatformTypeSinaWeibo
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self removeView];
                             
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil, nil];
                             [alert show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            break;
        }
        case HTButtonTypeQQ: {
            if (![QQApiInterface isQQInstalled]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:@"未安装客户端"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            NSArray *imageArray = @[self.reward.petCoop.crime_pic];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@""
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(self.reward.petCoop.id)]
                                                  title:nil
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeQQFriend
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self removeView];
                             break;
                         }
                         case SSDKResponseStateFail: {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil, nil];
                             [alert show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - ToolMethod

- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0],
            result[1],
            result[2],
            result[3],
            result[4],
            result[5],
            result[6],
            result[7],
            result[8],
            result[9],
            result[10],
            result[11],
            result[12],
            result[13],
            result[14],
            result[15]];
}

@end

