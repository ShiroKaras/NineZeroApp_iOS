//
//  AppDelegate.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/2.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SKHomepageViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SKHomepageViewController *mainController;
@property (nonatomic, strong) NSString *cityCode;
@property (atomic) bool active;

@end

