//
//  NZTaskCell.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/28.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKStronghold;

@interface NZTaskCell : UITableViewCell
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, strong) UILabel *distanceLabel;

- (void)loadDataWith:(SKStronghold*)stronghold;

@end
