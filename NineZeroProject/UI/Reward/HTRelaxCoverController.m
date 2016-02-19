//
//  HTRelaxCoverController.m
//  NineZeroProject
//
//  Created by ronhu on 16/2/19.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTRelaxCoverController.h"
#import "HTRelaxController.h"

typedef NS_ENUM(NSInteger, HTButtonType) {
    HTButtonTypeShare = 0,
    HTButtonTypeCancel,
    HTButtonTypeWechat,
    HTButtonTypeMoment,
    HTButtonTypeWeibo,
    HTButtonTypeQQ,
};

@interface HTRelaxCoverController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBgImageView)];
    [self.bgImageView addGestureRecognizer:tap];
}

- (IBAction)didClickButton:(UIButton *)sender {
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
            
//            break;
        }
        case HTButtonTypeMoment: {
            
//            break;
        }
        case HTButtonTypeWeibo: {
            
//            break;
        }
        case HTButtonTypeQQ: {
            
//            break;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)setShareAppear:(BOOL)appear {
    _momentButton.alpha = appear;
    _weiboButton.alpha = appear;
    _qqButton.alpha = appear;
    _wechatButton.alpha = appear;
}

- (void)didClickBgImageView {
    HTRelaxController *relaxController = [[HTRelaxController alloc] init];
    relaxController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:relaxController animated:YES completion:nil];
}

@end
