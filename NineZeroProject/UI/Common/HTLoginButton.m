//
//  HTLoginButton.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/24.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import "HTLoginButton.h"
#import "CommonUI.h"
#import "CommonDefine.h"

@implementation HTLoginButton

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled == YES) {
        self.backgroundColor = COMMON_GREEN_COLOR;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchDragExit];
    } else {
        self.backgroundColor = [UIColor colorWithHex:0x0a3e32];
        self.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.28];
        [self setTitleColor:[UIColor colorWithWhite:1 alpha:0.28] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithWhite:1 alpha:0.28] forState:UIControlStateDisabled];
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

- (void)touchDown {
    self.backgroundColor = COMMON_PINK_COLOR;
}

- (void)touchUpInside {
    self.backgroundColor = COMMON_GREEN_COLOR;
}
@end
