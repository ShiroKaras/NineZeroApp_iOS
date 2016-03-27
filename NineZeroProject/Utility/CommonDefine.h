//
//  CommonDefine.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/22.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h
#import <UIKit/UIKit.h>

#define HT_DEBUG NO

#define IS_LANDSCAPE UIDeviceOrientationIsLandscape((UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation)
#define SCREEN_WIDTH (IOS_VERSION >= 8.0 ? [[UIScreen mainScreen] bounds].size.width : (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width))
#define SCREEN_HEIGHT (IOS_VERSION >= 8.0 ? [[UIScreen mainScreen] bounds].size.height : (IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height))
#define SCREEN_BOUNDS (CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define IPHONE6_PLUS_SCREEN_WIDTH  414
#define IPHONE6_SCREEN_WIDTH       375
#define IPHONE5_SCREEN_WIDTH       320

#define UIColorMake(r, g, b) [[UIColor alloc] initWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

// 布局换算比例
#define ROUND_WIDTH(w) @((w / 320.0) * SCREEN_WIDTH)
#define ROUND_HEIGHT(h) @((h / 568.0) * SCREEN_HEIGHT)

#define ROUND_WIDTH_FLOAT(w) (w / 320.0) * SCREEN_WIDTH
#define ROUND_HEIGHT_FLOAT(h) (h / 568.0) * SCREEN_HEIGHT

#define ARTICLE_URL_STRING @"http://115.159.115.215:8001/views/article.html"
#define ANSWER_URL_STRING @"http://115.159.115.215:8001/views/answer.html"

#define COMMON_BG_COLOR UIColorMake(14, 14, 14)
#define MOON_FONT_OF_SIZE(s) [UIFont fontWithName:@"Moon-Bold" size:s]
#define COMMON_GREEN_COLOR [UIColor colorWithHex:0x24ddb2]
#define COMMON_PINK_COLOR [UIColor colorWithHex:0xd40e88]
#define COMMON_SEPARATOR_COLOR [UIColor colorWithHex:0x1f1f1f]
#define KEYWINDS_ROOT_CONTROLLER [[[[UIApplication sharedApplication] delegate] window] rootViewController]
#define KEY_WINDOW [[[UIApplication sharedApplication] delegate] window]

#define NO_NETWORK ([[AFNetworkReachabilityManager sharedManager] isReachable] == NO)

#define UIViewParentController(__view) ({ \
    UIResponder *__responder = __view; \
    while ([__responder isKindOfClass:[UIView class]]) \
        __responder = [__responder nextResponder]; \
    (UIViewController *)__responder; \
})

#endif /* CommonDefine_h */
