//
//  SKAnswerDetailView.h
//  NineZeroProject
//
//  Created by SinLemon on 16/7/4.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKAnswerDetailView;

@protocol SKAnswerDetailViewDelegate <NSObject>
- (void)didClickArticleWithID:(NSInteger)articleID;
@end

@interface SKAnswerDetailView : UIView
@property (nonatomic, weak) id<SKAnswerDetailViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame questionID:(uint64_t)questionID;

@end
