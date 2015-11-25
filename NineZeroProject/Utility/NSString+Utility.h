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

// sha256
+ (NSString *)sha256HashFor:(NSString *)input;
- (NSString *)sha256;

// 混淆
+ (NSString *)confusedString:(NSString *)string withSalt:(NSString *)salt;
- (NSString *)confusedWithSalt:(NSString *)salt;

@end

