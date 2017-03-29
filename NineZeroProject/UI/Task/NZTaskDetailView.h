//
//  NZTaskDetailView.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/29.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZTaskDetailView : UIView
@property(nonatomic, assign) float viewHeight;
- (instancetype)initWithFrame:(CGRect)frame withModel:(NSDictionary*)modal;
@end
