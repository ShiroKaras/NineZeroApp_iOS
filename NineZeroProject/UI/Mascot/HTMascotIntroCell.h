//
//  HTMascotIntroCell.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/31.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTMascot;

@interface HTMascotIntroCell : UITableViewCell

@property (nonatomic, strong) HTMascot *mascot;

+ (CGFloat)calculateCellHeightWithMascot:(HTMascot *)mascot;

@end
