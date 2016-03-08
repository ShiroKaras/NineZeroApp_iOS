//
//  HTCardTimeView.h
//  NineZeroProject
//
//  Created by ronhu on 16/3/7.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTQuestionInfo;
@class HTQuestion;
@interface HTCardTimeView : UIView
@property (nonatomic, strong, readonly) HTQuestionInfo *questionInfo;
@property (nonatomic, strong, readonly) HTQuestion *question;
- (void)setQuestion:(HTQuestion *)question andQuestionInfo:(HTQuestionInfo *)questionInfo;
@end
