//
//  HTMascotIntroCell.h
//  NineZeroProject
//
//  Created by ronhu on 16/1/31.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTMascot;

@interface HTMascotIntroCell : UITableViewCell

@property (nonatomic, strong) HTMascot *mascot;

+ (CGFloat)calculateCellHeightWithMascot:(HTMascot *)mascot;

@end
