//
//  SKHintView.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/18.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKQuestion;
@class SKHintList;

@interface SKHintView : UIView

- (instancetype)initWithFrame:(CGRect)frame questionID:(SKQuestion*)question season:(NSInteger)season;

@end
