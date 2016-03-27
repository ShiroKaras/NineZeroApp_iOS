//
//  HTProfileRecordCell.h
//  NineZeroProject
//
//  Created by ronhu on 16/3/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTProfileRecordCell;
@protocol HTProfileRecordCellDelegate <NSObject>
- (void)onClickedPlayButtonInCollectionCell:(HTProfileRecordCell *)cell;
@end

@interface HTProfileRecordCell : UICollectionViewCell
@property (nonatomic, weak) id<HTProfileRecordCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *coverImageView;
@end
