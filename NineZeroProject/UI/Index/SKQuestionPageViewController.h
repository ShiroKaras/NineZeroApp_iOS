//
//  SKQuestionPageViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 16/9/2.
//  Copyright © 2016年 ShiroKaras. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTUIHeader.h"

@interface SKQuestionPageViewController : UIViewController

@property(nonatomic, strong) NSArray<HTQuestion*>* questionList;
@property(nonatomic, assign) BOOL isMonday;

@end
