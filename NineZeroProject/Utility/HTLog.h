//
//  HTLog.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/16.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#ifndef HTLog_h
#define HTLog_h

#import <Foundation/Foundation.h>

#import <asl.h>

#define THIS_FILE [(@"" __FILE__) lastPathComponent]

//Do-while?
//https://stackoverflow.com/questions/1067226/c-multi-line-macro-do-while0-vs-scope-block

#define _NSLog(fmt,...) {                                               \
do                                                                      \
    {                                                                   \
    NSString *str = [NSString stringWithFormat:fmt, ##__VA_ARGS__];     \
    printf("%s\n",[str UTF8String]);                                    \
    asl_log(NULL, NULL, ASL_LEVEL_NOTICE, "%s", [str UTF8String]);      \
    }                                                                   \
    while (0);                                                          \
}


//#define NSLog(fmt, ...) _NSLog((@"[%@] " fmt), THIS_APP, ##__VA_ARGS__)

#ifdef DEBUG
    #define DLog(fmt, ...) _NSLog((@"[%@:%d][%s] " fmt),        \
    THIS_FILE,                                                  \
    __LINE__,                                                   \
    __FUNCTION__,                                               \
    ##__VA_ARGS__)
#else
    #define DLog(...)
#endif

#endif /* HTLog_h */
