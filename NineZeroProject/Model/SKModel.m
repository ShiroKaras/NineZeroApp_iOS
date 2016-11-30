//
//  SKModel.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKModel.h"
#import <MJExtension.h>

#define SKINIT(T) - (instancetype)init { \
if (self = [super init]) { \
[T setupReplacedKeyFromPropertyName:^NSDictionary *{ \
return [self propertyMapper]; \
}]; \
} \
return self; \
}

@implementation NSObject (PropertyPrint)

- (NSString *)debugDescription {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        const char *property = property_getName(properties[i]);
        NSString *propertyString = [NSString stringWithCString:property encoding:[NSString defaultCStringEncoding]];
        id obj = [self valueForKey:propertyString];
        [dict setValue:obj forKey:propertyString];
    }
    
    free(properties);
    return [NSString stringWithFormat:@"<%@ %p %@>",
            [self class],
            self,
            dict];
}

@end
