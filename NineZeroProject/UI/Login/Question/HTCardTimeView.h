//
//  HTCardTimeView.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/3/7.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKQuestionInfo;
@class SKQuestion;
@interface HTCardTimeView : UIView
//@property (nonatomic, strong, readonly) SKQuestion *questionInfo;
//@property (nonatomic, strong, readonly) SKQuestion *question;
- (void)setQuestion:(SKQuestion *)question andQuestionInfo:(SKQuestion *)questionInfo;
@end

@interface HTRecordView : UIView
@property (nonatomic, strong) SKQuestion *question;
@end
