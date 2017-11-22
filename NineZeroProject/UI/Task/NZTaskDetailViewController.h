//
//  NZTaskDetailViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/28.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZTaskDetailViewController : UIViewController
@property (nonatomic, strong) NSString *cityCode;
- (instancetype)initWithID:(NSString*)sid;

@end
