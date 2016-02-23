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

#define UIViewParentController(__view) ({ \
    UIResponder *__responder = __view; \
    while ([__responder isKindOfClass:[UIView class]]) \
        __responder = [__responder nextResponder]; \
    (UIViewController *)__responder; \
})

#endif /* CommonDefine_h */
