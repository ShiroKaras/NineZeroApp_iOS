//
//  HTProfileRankCell.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/2.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SKRankViewTypeSeason1   =0,
    SKRankViewTypeSeason2   =1
} SKRankViewType;

@interface HTProfileProgressView : UIView
- (void)setProgress:(CGFloat)progress;
- (void)setCoverColor:(UIColor *)coverColor;
- (void)setBackColor:(UIColor *)backColor;
@end

@class SKRanker;
@interface HTProfileRankCell : UITableViewCell

@property (nonatomic, strong) SKRanker *ranker;
@property (nonatomic, strong) NSArray<SKRanker*>* topThreeRankers;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UIView *backView;

- (void)showWithMe:(BOOL)me;
- (void)showCorner:(BOOL)show;
- (void)setTopThreeRankers:(NSArray<SKRanker *> *)topThreeRankers withType:(SKRankViewType)type;
- (void)setRanker:(SKRanker *)ranker withType:(SKRankViewType)type;
@end
