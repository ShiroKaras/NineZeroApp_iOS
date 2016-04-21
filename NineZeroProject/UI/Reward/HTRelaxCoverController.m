//
//  HTRelaxCoverController.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/19.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import "HTRelaxCoverController.h"
#import "HTRelaxController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

typedef NS_ENUM(NSInteger, HTButtonType) {
    HTButtonTypeShare = 0,
    HTButtonTypeCancel,
    HTButtonTypeWechat,
    HTButtonTypeMoment,
    HTButtonTypeWeibo,
    HTButtonTypeQQ,
};

@interface HTRelaxCoverController ()

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *momentButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *weiboButton;
@end

@implementation HTRelaxCoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImageView.userInteractionEnabled = YES;
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBgImageView)];
    [self.bgImageView addGestureRecognizer:tap];
}

- (IBAction)didClickButton:(UIButton *)sender {
    [self saveToPhotoLibrary];
//    [self share:sender];
}

- (void)share:(UIButton*)sender {
    HTButtonType type = (HTButtonType)sender.tag;
    switch (type) {
        case HTButtonTypeShare: {
            [UIView animateWithDuration:0.3 animations:^{
                _shareButton.alpha = 0;
                _cancelButton.alpha = 1.0;
                [self setShareAppear:YES];
            } completion:^(BOOL finished) {
            }];
            break;
        }
        case HTButtonTypeCancel: {
            [UIView animateWithDuration:0.3 animations:^{
                _cancelButton.alpha = 0;
                _shareButton.alpha = 1.0;
                [self setShareAppear:NO];
            } completion:^(BOOL finished) {
            }];
            break;
        }
        case HTButtonTypeWechat: {
            NSArray* imageArray = @[_bgImageView.image];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"分享内容test"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:@"http://www.mob.com"]
                                                  title:@"分享文章"
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@",error]
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
            NSArray* imageArray = @[_bgImageView.image];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"分享内容test"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:@"http://www.mob.com"]
                                                  title:@"分享文章"
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@",error]
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
            NSArray* imageArray = @[_bgImageView.image];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"分享内容test http://www.baidu.com"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:@"http://www.mob.com"]
                                                  title:@"分享文章"
                                                   type:SSDKContentTypeImage];
                [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@",error]
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
            NSArray* imageArray = @[@"http://ww2.sinaimg.cn/mw690/94d94f1ajw8etrbq63k87j2078078mxl.jpg"];
            if (imageArray) {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:@"分享内容test"
                                                 images:imageArray
                                                    url:[NSURL URLWithString:@"http://www.mob.com"]
                                                  title:@"分享文章"
                                                   type:SSDKContentTypeAuto];
                [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    switch (state) {
                        case SSDKResponseStateSuccess:
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                message:nil
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil];
                            [alertView show];
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@",error]
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
    }
}

- (void)saveToPhotoLibrary {
    UIImageWriteToSavedPhotosAlbum(_bgImageView.image, nil, nil, nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储照片成功"
                                                    message:@"您已将照片存储于图片库中，打开照片库即可查看。"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)setShareAppear:(BOOL)appear {
    _momentButton.alpha = appear;
    _weiboButton.alpha = appear;
    _qqButton.alpha = appear;
    _wechatButton.alpha = appear;
}

- (void)didClickBgImageView {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
