//
//  HTModel.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/7.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTModel.h"
#import <MJExtension.h>

@implementation NSObject (PropertyPrint)

- (NSDictionary *)properties_aps {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:kCFStringEncodingUTF8];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [self properties_aps]];
}

@end

@implementation HTLoginUser
@end

@implementation HTQuestion

- (instancetype)init {
    if (self = [super init]) {
        [HTQuestion setupReplacedKeyFromPropertyName:^NSDictionary *{
            return [self propertyMapper];
        }];
    }
    return self;
}

- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"questionID" : @"qid",
                                     @"areaID" : @"area_id",
                                     @"rewardID" : @"reward_id",
                                     @"answers" : @"question_answer",
                                     @"chapterText" : @"chapter",
                                     @"questionDescription" : @"description",
                                     @"detailURL" : @"detail_url"
                                     };
    return propertyMapper;
}
@end
