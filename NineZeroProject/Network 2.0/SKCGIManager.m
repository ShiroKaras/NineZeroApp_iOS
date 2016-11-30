//
//  SKCGIManager.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKCGIManager.h"

@implementation SKCGIManager

+ (NSString *)loginBaseCGIKey {
    return [NSString stringWithFormat:@"%@Login/appIndex",APP_HOST];
}

+ (NSString *)questionBaseCGIKey {
    return [NSString stringWithFormat:@"%@Question/appIndex",APP_HOST];    
}

@end
