//
//  NZQuestionListCell.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/3/30.
//  Copyright © 2017年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKQuestion;

@interface NZQuestionListCell : UITableViewCell
@property (nonatomic, assign) float cellHeight;

@property (nonatomic, strong) UIImageView *questionCoverImageView;
@property (nonatomic, strong) UIImageView *timeLabelImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) time_t deltaTime;

- (void)setCellWithQuetion:(SKQuestion *)question;

@end
