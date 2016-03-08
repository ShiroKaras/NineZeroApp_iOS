//
//  HTCardCollectionCell.h
//  NineZeroProject
//
//  Created by ronhu on 16/3/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HTCardCollectionClickType) {
    HTCardCollectionClickTypeCompose,
    HTCardCollectionClickTypeAR,
    HTCardCollectionClickTypeContent,
    HTCardCollectionClickTypeHint,
    HTCardCollectionClickTypeReward,
    HTCardCollectionClickTypeAnswer,
    HTCardCollectionClickTypePlay,
    HTCardCollectionClickTypePause,
};


@class HTCardCollectionCell;
@class HTQuestion;
@class HTQuestionInfo;
@protocol HTCardCollectionCellDelegate <NSObject>
- (void)collectionCell:(HTCardCollectionCell *)cell didClickButtonWithType:(HTCardCollectionClickType)type;
@end

@interface HTCardCollectionCell : UICollectionViewCell
- (void)play;
- (void)stop;
@property (nonatomic, weak) id<HTCardCollectionCellDelegate> delegate;
@property (nonatomic, strong) HTQuestion *question;
@property (nonatomic, strong) HTQuestionInfo *questionInfo;
@property (nonatomic, assign) CGRect hintRect;
@property (nonatomic, assign) BOOL soundHidden;
@end
