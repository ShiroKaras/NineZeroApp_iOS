//
//  NZRankCell.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/30.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKRanker;

typedef enum : NSUInteger {
    NZRankListTypeQuestion,
    NZRankListTypeHunter
} NZRankListType;

@interface NZRankCell : UITableViewCell
@property (nonatomic, assign) float cellHeight;

- (void)setRanker:(SKRanker *)ranker;
- (void)setRanker:(SKRanker *)ranker isMe:(BOOL)isMe;
- (void)setRanker:(SKRanker *)ranker isMe:(BOOL)isMe withType:(NZRankListType)type;
@end
