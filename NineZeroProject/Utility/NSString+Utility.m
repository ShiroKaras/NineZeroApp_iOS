//
//  NSString+Utility.m
//  NineZeroProject
//
//  Created by ronhu on 15/11/17.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "NSString+Utility.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Utility)

+ (NSString *)md5HexDigest:(NSString *)input {
	const char *str = [input UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];

	CC_MD5(str, (CC_LONG)strlen(str), result);
	
	NSMutableString* ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[ret appendFormat:@"%02x", result[i]];
	}
	return ret;
}

- (NSString *)md5 {
	const char *str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5(str, (CC_LONG)strlen(str), result);
	
	NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[ret appendFormat:@"%02x", result[i]];
	}
	return ret;
}

+ (NSString*)sha256HashFor:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (NSString *)sha256 {
    return [NSString sha256HashFor:self];
}

+ (NSString *)confusedString:(NSString *)string withSalt:(NSString *)salt {
    return [NSString stringWithFormat:@"%01$@%02$@%01$@%02$@%01$@%02$@", string, salt];
}

- (NSString *)confusedWithSalt:(NSString *)salt {
    return [NSString stringWithFormat:@"%01$@%02$@%01$@%02$@%01$@%02$@", self, salt];
}

@end
