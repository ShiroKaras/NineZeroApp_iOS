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

- (void)setCellWithQuetion:(SKQuestion *)question;

@end
