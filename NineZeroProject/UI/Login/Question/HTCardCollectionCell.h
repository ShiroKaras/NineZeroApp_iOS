//
//  HTCardCollectionCell.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/7.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HTCardCollectionClickType) {
    HTCardCollectionClickTypeCompose,
    HTCardCollectionClickTypeAR,
    HTCardCollectionClickTypeHistory,
    
    HTCardCollectionClickTypeContent,
    HTCardCollectionClickTypeHint,
    HTCardCollectionClickTypeRank,
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
- (void)setQuestion:(HTQuestion *)question questionInfo:(HTQuestionInfo *)questionInfo;
@property (nonatomic, weak) id<HTCardCollectionCellDelegate> delegate;
@property (nonatomic, strong) HTQuestion *question;
@property (nonatomic, strong) HTQuestionInfo *questionInfo;
@property (nonatomic, assign) CGRect hintRect;
@property (nonatomic, assign) BOOL soundHidden;

@property (nonatomic, strong, readonly) UIView *contentBackView;
@property (nonatomic, strong, readonly) UIButton *playButton;
@end
