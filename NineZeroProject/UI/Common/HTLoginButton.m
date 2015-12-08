//
//  HTLoginButton.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/24.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTLoginButton.h"
#import "CommonUI.h"

@implementation HTLoginButton

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled == YES) {
        self.backgroundColor = [UIColor colorWithHex:0x24ddb2];
        self.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor colorWithHex:0x0a3e32];
        self.titleLabel.textColor = [UIColor colorWithHex:0xffffff];
    }
}

- (void)showNextTipImage:(BOOL)show {
    if (show == YES) {
        self.titleLabel.text = @"";
        [self setImage:[UIImage imageNamed:@"ico_btnanchor_right"] forState:UIControlStateNormal];
    } else {
        [self setImage:nil forState:UIControlStateNormal];
    }
}

@end