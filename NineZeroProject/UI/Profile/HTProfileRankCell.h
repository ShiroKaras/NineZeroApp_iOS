//
//  HTProfileRankCell.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/2.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTProfileProgressView : UIView
- (void)setProgress:(CGFloat)progress;
- (void)setCoverColor:(UIColor *)coverColor;
- (void)setBackColor:(UIColor *)backColor;
@end

@class HTRanker;
@interface HTProfileRankCell : UITableViewCell

@property (nonatomic, strong) HTRanker *ranker;

- (void)showWithMe:(BOOL)me;

@end
