//
//  NZTopRankListView.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/8.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKRanker;

@protocol NZTopRankListViewDelegate <NSObject>

- (void)didClickHunterRankButton;

@end

@interface NZTopRankListView : UIView

@property(nonatomic, weak) id<NZTopRankListViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withRankers:(NSArray<SKRanker*>*)rankers;

@end
