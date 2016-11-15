//
//  SKActivityNotificationView.h
//  NineZeroProject
//
//  Created by SinLemon on 16/9/12.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKActivityNotificationView : UIView

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIButton    *adButton;

- (void)show;
@end
