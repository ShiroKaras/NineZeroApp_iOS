//
//  HTNotificationCell.h
//  NineZeroProject
//
//  Created by ronhu on 16/2/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTNotification;
@interface HTNotificationCell : UITableViewCell
- (void)setNotification:(HTNotification *)notification;
+ (CGFloat)calculateCellHeightWithText:(NSString *)text;
@end
