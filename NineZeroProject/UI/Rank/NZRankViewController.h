//
//  NZRankViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/30.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZRankCell.h"

@interface NZRankViewController : UIViewController
@property (nonatomic, strong) UIImageView *titleImageView;

- (instancetype)initWithType:(NZRankListType)type;

@end
