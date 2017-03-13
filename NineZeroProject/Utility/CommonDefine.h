//
//  CommonDefine.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/12/22.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#define HT_DEBUG NO

#define IS_LANDSCAPE UIDeviceOrientationIsLandscape((UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation)
#define SCREEN_WIDTH (IOS_VERSION >= 8.0 ? [[UIScreen mainScreen] bounds].size.width : (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width))
#define SCREEN_HEIGHT (IOS_VERSION >= 8.0 ? [[UIScreen mainScreen] bounds].size.height : (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height))
#define SCREEN_BOUNDS (CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define IPHONE6_PLUS_SCREEN_WIDTH 414
#define IPHONE6_SCREEN_WIDTH 375
#define IPHONE5_SCREEN_WIDTH 320
#define IPHONE4_SCREEN_HEIGHT 480

#define UIColorMake(r, g, b) [[UIColor alloc] initWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]

//Masonry
#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;

// 布局换算比例
#define ROUND_WIDTH(w) @((w / 320.0) * SCREEN_WIDTH)
#define ROUND_HEIGHT(h) @((h / 568.0) * SCREEN_HEIGHT)

#define ROUND_WIDTH_FLOAT(w) (w / 320.0) * SCREEN_WIDTH
#define ROUND_HEIGHT_FLOAT(h) (h / 568.0) * SCREEN_HEIGHT

//#define ARTICLE_URL_STRING @"http://101.201.39.169:8001/views/article.html"
//#define ANSWER_URL_STRING @"http://101.201.39.169:8001/views/answer.html"

#define MOON_FONT_OF_SIZE(s) [UIFont fontWithName:@"Moon-Bold" size:s]
#define PINGFANG_FONT_OF_SIZE(s) [UIFont fontWithName:@"PingFangSC-Regular" size:s]

//#define COMMON_BG_COLOR UIColorMake(14, 14, 14)
#define COMMON_BG_COLOR [UIColor colorWithHex:0x0E0E0E]
#define COMMON_TITLE_BG_COLOR [UIColor colorWithHex:0x1A1A1A]
#define COMMON_GREEN_COLOR [UIColor colorWithHex:0x24ddb2]
#define COMMON_PINK_COLOR [UIColor colorWithHex:0xd40e88]
#define COMMON_SEPARATOR_COLOR [UIColor colorWithHex:0x1f1f1f]
#define COMMON_RED_COLOR [UIColor colorWithHex:0xed203b]

#define KEYWINDS_ROOT_CONTROLLER [[[[UIApplication sharedApplication] delegate] window] rootViewController]
#define KEY_WINDOW [[[UIApplication sharedApplication] delegate] window]
#define APPLICATION_DELEGATE [[UIApplication sharedApplication] delegate]
#define AppDelegateInstance ((AppDelegate *)([UIApplication sharedApplication].delegate))

#define NO_NETWORK ([[AFNetworkReachabilityManager sharedManager] isReachable] == NO)

#define UIViewParentController(__view) ({                  \
	UIResponder *__responder = __view;                 \
	while ([__responder isKindOfClass:[UIView class]]) \
		__responder = [__responder nextResponder]; \
	(UIViewController *)__responder;                   \
})

#define UD [NSUserDefaults standardUserDefaults]

#define HAVE_NEW_MASCOT [UD boolForKey:@"newMascot"]
#define RESET_NEW_MASCOT [UD setBool:NO forKey:@"newMascot"]
#define GET_NEW_MASCOT [UD setBool:YES forKey:@"newMascot"]

#define kMascots_Dict @"kMascotsArray"

#define FIRST_LAUNCH [UD boolForKey:@"firstLaunch"]

#define FIRST_COACHMARK_TYPE_1 ![UD boolForKey:@"firstLaunchTypePlayToEnd"]
#define FIRST_COACHMARK_TYPE_2 ![UD boolForKey:@"firstLaunchTypeThreeWrongAnswer"]

#define FIRST_LAUNCH_AR ![UD boolForKey:@"firstLaunchTypeAR"]
#define FIRST_LAUNCH_QUESTIONLIST ![UD boolForKey:@"firstLaunchQuestionList"]
#define FIRST_LAUNCH_QUESTIONVIEW ![UD boolForKey:@"firstLaunchQuestionView"]
#define FIRST_LAUNCH_MASCOTVIEW ![UD boolForKey:@"firstLaunchMascotView"]
#define EVER_LAUNCHED_MASCOTVIEW [UD setBool:YES forKey:@"firstLaunchMascotView"];

#define kQuestionWrongAnswerCountSeason1 @"kQuestionWrongAnswerCountSeason1"
#define kQuestionWrongAnswerCountSeason2 @"kQuestionWrongAnswerCountSeason2"

#define kBadgeLevels @"kBadgeLevels"

#define EVERYDAY_FIRST_ACTIVITY_NOTIFICATION @"EVERYDAY_FIRST_ACTIVITY_NOTIFICATION"
#define ACTIVITY_NOTIFICATION_PIC_NAME @"ACTIVITY_NOTIFICATION_PIC_NAME"

#define NOTIFICATION_COUNT @"NOTIFICATION_COUNT"
#define SECRETARY_COUNT @"SECRETARY_COUNT"

#endif /* CommonDefine_h */
