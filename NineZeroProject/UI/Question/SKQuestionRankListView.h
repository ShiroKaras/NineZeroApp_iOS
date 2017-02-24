//
//  SKQuestionRankListView.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/19.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKUserInfo;

@interface SKQuestionRankListView : UIView

- (instancetype)initWithFrame:(CGRect)frame rankerList:(NSArray<SKUserInfo*>*)rankerList withButton:(UIButton*)button;

@end
