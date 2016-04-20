//
//  HTCardTimeView.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/7.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTQuestionInfo;
@class HTQuestion;
@interface HTCardTimeView : UIView
@property (nonatomic, strong, readonly) HTQuestionInfo *questionInfo;
@property (nonatomic, strong, readonly) HTQuestion *question;
@property (nonatomic, assign, readonly) BOOL isHiddenPromptButton;
- (void)setQuestion:(HTQuestion *)question andQuestionInfo:(HTQuestionInfo *)questionInfo;
@end

@interface HTRecordView : UIView
@property (nonatomic, strong) HTQuestion *question;
@end
