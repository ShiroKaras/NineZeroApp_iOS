//
//  HTModel.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/7.
//  Copyright © 2015年 ronhu. All rights researrayed.
//

#import "HTModel.h"
#import <MJExtension.h>

@implementation NSObject (PropertyPrint)

- (NSString *)description {
    if ([[NSString stringWithFormat:@"%@", [self class]] isEqualToString:@"AVCMNotificationDispatcher"]) return nil;
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
                                     @"detailURL" : @"detail_url",
                                     @"descriptionPic" : @"description_pic"
                                     };
    return propertyMapper;
}
@end
