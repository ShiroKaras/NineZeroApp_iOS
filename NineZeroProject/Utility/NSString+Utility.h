//
//  NSString+Utility.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/17.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)

// md5加密
- (NSString *)md5;
+ (NSString *)md5HexDigest:(NSString *)input;

@end
