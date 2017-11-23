//
//  NZEvidenceView.m
//  NineZeroProject
//
//  Created by SinLemon on 2017/4/18.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "NZEvidenceView.h"
#import "HTUIHeader.h"

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

@interface NZEvidenceView ()
@property (nonatomic, strong) SKMascotEvidence *evidence;
@property (nonatomic, strong) UIImageView *propImageView;
@property (nonatomic, strong) UIImageView *propTextImageView;
@property (nonatomic, strong) UILabel *propTextLabel;
@end

@implementation NZEvidenceView

- (instancetype)initWithFrame:(CGRect)frame withCrimeEvidence:(SKMascotEvidence *)evidence {
    self = [super initWithFrame:frame];
    if (self) {
        //[self createUIWithFrame:frame];
        [self createLuhanUIWithFrame:frame];
        [[[SKServiceManager sharedInstance] mascotService] getMascotEvidenceDetailWithID:evidence.id callback:^(BOOL success, SKMascotEvidence *evidence) {
            self.evidence = evidence;
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
    _propImageView.layer.borderWidth = 2;
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
    _propTextLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
    _propTextLabel.textAlignment = NSTextAlignmentCenter;
    _propTextLabel.numberOfLines = 0;
    [self addSubview:_propTextLabel];
    [_propTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.right.equalTo(@-16);
        make.centerX.equalTo(alphaView.mas_centerX);
        make.top.equalTo(_propTextImageView.mas_bottom).offset(ROUND_HEIGHT_FLOAT(25));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    [self addGestureRecognizer:tap];
}

- (void)createLuhanUIWithFrame:(CGRect)frame {
    self.backgroundColor = [UIColor clearColor];
    UIView *alphaView = [[UIView alloc] initWithFrame:frame];
    alphaView.backgroundColor = COMMON_BG_COLOR;
    alphaView.alpha = 0.9;
    [self addSubview:alphaView];
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:[UIImage imageNamed:@"btn_puzzledetailpage_close"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"btn_puzzledetailpage_close_highlight"] forState:UIControlStateHighlighted];
    closeButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(27), ROUND_WIDTH_FLOAT(27));
    closeButton.left = ROUND_WIDTH_FLOAT(13.5);
    closeButton.top = ROUND_HEIGHT_FLOAT(28.5);
    [self addSubview:closeButton];
    
    UIImageView *mTitleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_special_crimename1"]];
    mTitleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:mTitleImageView];
    [mTitleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(256), ROUND_WIDTH_FLOAT(26)));
        make.top.mas_equalTo(ROUND_WIDTH_FLOAT(99));
        make.centerX.equalTo(self);
    }];
    
    _propImageView = [UIImageView new];
    _propImageView.layer.borderWidth = 2;
    _propImageView.layer.borderColor = COMMON_GREEN_COLOR.CGColor;
    [self addSubview:_propImageView];
    [_propImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(222), ROUND_WIDTH_FLOAT(222)));
        make.centerX.equalTo(alphaView.mas_centerX);
        make.top.equalTo(ROUND_HEIGHT(161));
    }];
    
    _propTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_special_crimename2"]];
    _propTextImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_propTextImageView];
    [_propTextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ROUND_WIDTH_FLOAT(260), ROUND_WIDTH_FLOAT(20)));
        make.centerX.equalTo(self);
        make.top.equalTo(_propImageView.mas_bottom).offset(ROUND_HEIGHT_FLOAT(26));
    }];
    
    _propTextLabel = [UILabel new];
    _propTextLabel.textColor = [UIColor whiteColor];
    _propTextLabel.font = PINGFANG_ROUND_FONT_OF_SIZE(14);
    _propTextLabel.textAlignment = NSTextAlignmentCenter;
    _propTextLabel.numberOfLines = 0;
    [self addSubview:_propTextLabel];
    [_propTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.right.equalTo(@-16);
        make.centerX.equalTo(alphaView.mas_centerX);
        make.top.equalTo(_propTextImageView.mas_bottom).offset(ROUND_HEIGHT_FLOAT(13));
    }];
    
    //luhan
    UIButton *shareButton = [UIButton new];
    [shareButton addTarget:self action:@selector(shareMascot:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"btn_share_highlight"] forState:UIControlStateHighlighted];
    shareButton.size = CGSizeMake(self.width, ROUND_HEIGHT_FLOAT(49));
    shareButton.bottom = self.height;
    shareButton.centerX = self.width/2;
    [self addSubview:shareButton];
}

- (void)closeView {
    [self removeFromSuperview];
}

- (void)shareMascot:(UIButton*)sender {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    alphaView.backgroundColor = COMMON_BG_COLOR;
    alphaView.alpha = 0.9;
    [self addSubview:alphaView];
    self.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
    
    UIButton *closeButton = [UIButton new];
    [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:[UIImage imageNamed:@"btn_puzzledetailpage_close"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"btn_puzzledetailpage_close_highlight"] forState:UIControlStateHighlighted];
    closeButton.size = CGSizeMake(ROUND_WIDTH_FLOAT(27), ROUND_WIDTH_FLOAT(27));
    closeButton.left = ROUND_WIDTH_FLOAT(13.5);
    closeButton.top = ROUND_HEIGHT_FLOAT(28.5);
    [self addSubview:closeButton];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ROUND_WIDTH_FLOAT(115.5), ROUND_WIDTH_FLOAT(20))];
    titleImageView.image = [UIImage imageNamed:@"img_speciallabsharepage_title"];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    titleImageView.centerX = self.width/2;
    titleImageView.top = ROUND_HEIGHT_FLOAT(207);
    [self addSubview:titleImageView];
    
    UIButton *wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatButton setImage:[UIImage imageNamed:@"btn_sharepage_wechat"] forState:UIControlStateNormal];
    [wechatButton setImage:[UIImage imageNamed:@"btn_sharepage_wechat_highlight"] forState:UIControlStateHighlighted];
    [wechatButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [wechatButton sizeToFit];
    wechatButton.tag = HTButtonTypeWechat;
    wechatButton.alpha = 1;
    [self addSubview:wechatButton];
    
    UIButton *momentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [momentButton setImage:[UIImage imageNamed:@"btn_sharepage_friendcircle"] forState:UIControlStateNormal];
    [momentButton setImage:[UIImage imageNamed:@"btn_sharepage_friendcircle_highlight"] forState:UIControlStateHighlighted];
    [momentButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [momentButton sizeToFit];
    momentButton.tag = HTButtonTypeMoment;
    momentButton.alpha = 1;
    [self addSubview:momentButton];
    
    UIButton *weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [weiboButton setImage:[UIImage imageNamed:@"btn_sharepage_weibo"] forState:UIControlStateNormal];
    [weiboButton setImage:[UIImage imageNamed:@"btn_sharepage_weibo_highlight"] forState:UIControlStateHighlighted];
    [weiboButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [weiboButton sizeToFit];
    weiboButton.tag = HTButtonTypeWeibo;
    weiboButton.alpha = 1;
    [self addSubview:weiboButton];
    
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqButton setImage:[UIImage imageNamed:@"btn_sharepage_qq"] forState:UIControlStateNormal];
    [qqButton setImage:[UIImage imageNamed:@"btn_sharepage_qq_highlight"] forState:UIControlStateHighlighted];
    [qqButton addTarget:self action:@selector(shareWithThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
    [qqButton sizeToFit];
    qqButton.tag = HTButtonTypeQQ;
    qqButton.alpha = 1;
    [self addSubview:qqButton];
    
    __weak UIView *weakShareView = self;
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
            NSArray *imageArray = @[self.evidence.crime_pic];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"九零携手“鹿晗愿望季”，用AR探索城市传统文化"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(self.evidence.id)]
                                                  title:@"我捕捉到“鹿”版特别零仔！"
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatSession
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     DLog(@"State -> %lu", (unsigned long)state);
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self closeView];
                             
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
            
            NSArray *imageArray = @[self.evidence.crime_pic];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"九零携手“鹿晗愿望季”，用AR探索城市传统文化"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(self.evidence.id)]
                                                  title:@"我捕捉到“鹿”版特别零仔！"
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self closeView];
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
            
            NSArray *imageArray = @[self.evidence.crime_pic];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ %@ 来自@九零APP",@"九零携手“鹿晗愿望季”，用AR探索城市传统文化", SHARE_URL(self.evidence.id)]
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(self.evidence.id)]
                                                  title:@"我捕捉到“鹿”版特别零仔！"
                                                   type:SSDKContentTypeImage];
                [ShareSDK share:SSDKPlatformTypeSinaWeibo
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self closeView];
                             
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
            
            NSArray *imageArray = @[self.evidence.crime_pic];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"九零携手“鹿晗愿望季”，用AR探索城市传统文化"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:SHARE_URL(self.evidence.id)]
                                                  title:@"我捕捉到“鹿”版特别零仔！"
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeQQFriend
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess: {
                             [self closeView];
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
