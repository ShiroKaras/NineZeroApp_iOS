//
//  HTNotificationCell.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/29.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKNotification;
@interface HTNotificationCell : UITableViewCell
- (void)setNotification:(SKNotification *)notification;
+ (CGFloat)calculateCellHeightWithText:(NSString *)text;
@end
