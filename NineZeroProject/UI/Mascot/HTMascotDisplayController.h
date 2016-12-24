//
//  HTMascotDisplayController.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/17.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTMascot;

@interface HTMascotDisplayController : UIViewController
@property (nonatomic, strong) NSMutableArray<HTMascot *> *mascots;
// 重置状态
- (void)reloadDisplayMascotsWithIndex:(NSUInteger)index;
- (void)reloadAllData;
@end
