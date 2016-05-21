//
//  SKLaunchAnimationViewController.h
//  NineZeroProject
//
//  Created by SinLemon on 16/5/21.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectedEnter)();

@interface SKLaunchAnimationViewController : UIViewController

@property (nonatomic, copy) DidSelectedEnter didSelectedEnter;

@end
