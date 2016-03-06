//
//  HTCardCollectionCell.h
//  NineZeroProject
//
//  Created by ronhu on 16/3/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTCardCollectionCell;
@class HTQuestion;
@protocol HTCardCollectionCellDelegate <NSObject>
- (void)onClickedPlayButtonInCollectionCell:(HTCardCollectionCell *)cell;
@end

@interface HTCardCollectionCell : UICollectionViewCell
- (void)play;
- (void)stop;
@property (nonatomic, weak) id<HTCardCollectionCellDelegate> delegate;
@property (nonatomic, strong) HTQuestion *question;
@end
