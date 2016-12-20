//
//  SKMyBadgesViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/6.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKMyBadgesViewController : UIViewController

@end

@interface SKProfileProgressView : UIView
- (void)setProgress:(CGFloat)progress;
- (void)setCoverColor:(UIColor *)coverColor;
- (void)setBackColor:(UIColor *)backColor;
@end
