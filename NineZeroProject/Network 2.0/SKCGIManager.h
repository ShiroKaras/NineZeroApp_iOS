//
//  SKCGIManager.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_HOST @"http://112.74.133.183:8082"

@interface SKCGIManager : NSObject

+ (NSString *)loginBaseCGIKey;

+ (NSString *)questionBaseCGIKey;

+ (NSString *)profileBaseCGIKey;

+ (NSString *)propBaseCGIKey;
@end
