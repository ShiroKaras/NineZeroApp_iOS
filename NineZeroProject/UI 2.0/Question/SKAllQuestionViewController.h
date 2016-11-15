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

@property(nonatomic, strong) NSArray<HTQuestion*>* questionList;
@property(nonatomic, assign) BOOL isMonday;

@end
