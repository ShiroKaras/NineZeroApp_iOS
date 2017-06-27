//
//  NZTaskViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/28.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZTaskViewController : UIViewController
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) NSString *cityCode;

- (instancetype)initWithMascotID:(NSInteger)mid;

@end
