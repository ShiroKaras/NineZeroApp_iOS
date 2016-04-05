//
//  HTNotificationCell.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/2/29.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTNotification;
@interface HTNotificationCell : UITableViewCell
- (void)setNotification:(HTNotification *)notification;
+ (CGFloat)calculateCellHeightWithText:(NSString *)text;
@end
