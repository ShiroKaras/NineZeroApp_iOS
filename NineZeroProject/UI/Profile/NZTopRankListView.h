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

- (void)didClickRankButton;
- (void)didClickHunterRankButton;

@end

@interface NZTopRankListView : UIView
@property(nonatomic, strong) NSArray<SKRanker*> *rankerArray;
@property(nonatomic, weak) id<NZTopRankListViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withRankers:(NSArray<SKRanker*>*)rankers;

@end


//单行View
@interface NZRankCellView : UIView
@property (nonatomic, strong) UILabel *rankOrderLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *expLabel;
@end
