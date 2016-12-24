//
//  SKAllQuestionViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/11.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTUIHeader.h"

@interface SKAllQuestionViewController : UIViewController

@property(nonatomic, strong) NSArray<SKQuestion*>* questionList_season1;
@property(nonatomic, strong) NSArray<SKQuestion*>* questionList_season2;
@property(nonatomic, assign) BOOL isMonday;
@property(nonatomic, strong) SKIndexInfo *indexInfo;

@end
