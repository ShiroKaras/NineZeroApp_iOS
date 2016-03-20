//
//  UIViewController+HTTips.m
//  NineZeroProject
//
//  Created by ronhu on 16/3/19.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "HTUIHeader.h"

#import "UIViewController+HTTips.h"

@implementation UIViewController (HTTips)
- (void)showTipsWithText:(NSString *)text {
    UIView *tipsBackView = [[UIView alloc] init];
    tipsBackView.backgroundColor = COMMON_PINK_COLOR;
    tipsBackView.hidden = YES;
    [self.view addSubview:tipsBackView];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = [UIFont systemFontOfSize:16];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor whiteColor];
    [tipsBackView addSubview:tipsLabel];
    
    [tipsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.navigationController == nil || self.navigationController.navigationBar.hidden == YES) {
            make.top.equalTo(self.view).offset(20);
        } else {
            make.top.equalTo(self.view).offset(0);
        }
        make.width.equalTo(self.view);
        make.height.equalTo(@30);
    }];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tipsBackView);
    }];
    
    tipsLabel.text = text;
    CGFloat tipsBottom = tipsBackView.bottom;
    tipsBackView.bottom = 0;
    [UIView animateWithDuration:0.3 animations:^{
        tipsBackView.hidden = NO;
        tipsBackView.bottom = tipsBottom;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                tipsBackView.bottom = 0;
            } completion:^(BOOL finished) {
                tipsBackView.bottom = tipsBottom;
                tipsBackView.hidden = YES;
            }];
        });
    }];
}
@end
