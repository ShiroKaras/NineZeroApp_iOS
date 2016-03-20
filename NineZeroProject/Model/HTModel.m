//
//  HTModel.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/7.
//  Copyright © 2015年 ronhu. All rights researrayed.
//

#import "HTModel.h"
#import <MJExtension.h>

#define HTINIT(T) - (instancetype)init { \
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

@implementation HTLoginUser
@end

@implementation HTQuestionInfo
HTINIT(HTQuestionInfo)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"questionID" : @"current_question_id",
                                     @"endTime" : @"endtime",
                                     @"updateTime" : @"last_update_time",
                                     @"questionCount" : @"question_num"
                                     };
    return propertyMapper;
}

@end

@implementation HTQuestion
HTINIT(HTQuestion)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"questionID" : @"qid",
                                     @"areaID" : @"area_id",
                                     @"rewardID" : @"reward_id",
                                     @"answers" : @"question_answer",
                                     @"chapterText" : @"chapter",
                                     @"questionDescription" : @"description",
                                     @"detailURL" : @"detail_url",
                                     @"descriptionPic" : @"description_pic",
                                     @"vedioURL" : @"question_video"
                                     };
    return propertyMapper;
}
@end

@implementation HTResponsePackage
HTINIT(HTResponsePackage)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"resultCode" : @"result"};
    return propertyMapper;
}

@end

@implementation HTArticle
HTINIT(HTArticle)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"mascotID"  : @"pet_id",
                                     @"articleID" : @"article_id",
                                     @"articleURL" : @"article_url",
                                     @"articleTitle" : @"article_title"};
    return propertyMapper;
}
@end

@implementation HTMascot
HTINIT(HTMascot)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"mascotID" : @"pet_id",
                                     @"getTime" : @"time",
                                     @"mascotName" : @"pet_name",
                                     @"mascotPic" : @"pet_pic",
                                     @"mascotDescription" : @"pet_desc"};
    return propertyMapper;
}
@end

@implementation HTMascotProp
HTINIT(HTMascotProp);
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"propID" : @"prop_id",
                                     @"getTime" : @"time",
                                     @"exchangedTime" : @"exchange_time",
                                     @"iconName" : @"prop_icon",
                                     @"propPicName" : @"prop_pic",
                                     @"propName" : @"prop_name",
                                     @"isExchanged" : @"prop_exchange",
                                     @"isUsed" : @"used",
                                     @"propDescription" : @"prop_desc"};
    return propertyMapper;
}
@end

@implementation HTReward
@end

@implementation HTNotification
@end

@implementation HTProfileInfo
@end

@implementation HTUserInfo
@end

@implementation HTRanker
@end

@implementation HTBadge
@end
