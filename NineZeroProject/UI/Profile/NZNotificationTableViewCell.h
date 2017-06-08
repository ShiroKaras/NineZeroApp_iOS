//
//  NZNotificationTableViewCell.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/8.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKNotification;

@interface NZNotificationTableViewCell : UITableViewCell
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, strong) UIView *bottomLine;

- (void)setNotification:(SKNotification *)notification;
+ (CGFloat)calculateCellHeightWithText:(NSString *)text;
@end
