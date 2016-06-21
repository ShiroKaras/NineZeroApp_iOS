//
//  SKModel.m
//  NineZeroProject
//
//  Created by SinLemon on 16/6/20.
//  CopyrigSK © 2016年 ronhu. All rigSKs reserved.
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

@implementation NSObject (PropertyPrintf)

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

@implementation SKLoginUser
@end

@implementation SKQuestionInfo
//SKINIT(SKQuestionInfo)
- (instancetype)init {
    if (self = [super init]) {
        [SKQuestion setupReplacedKeyFromPropertyName:^NSDictionary *{
            return [self propertyMapper];
        }];
    }
    return self;
}
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"questionID" : @"current_question_id",
                                     @"endTime" : @"endtime",
                                     @"updateTime" : @"last_update_time",
                                     @"questionCount" : @"question_num"
                                     };
    return propertyMapper;
}
@end

@implementation SKQuestion
SKINIT(SKQuestion)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"questionID" : @"qid",
                                     @"areaID" : @"area_id",
                                     @"rewardID" : @"reward_id",
                                     @"answers" : @"question_answer",
                                     @"chapterText" : @"chapter",
                                     @"questionDescription" : @"description",
                                     @"detailURL" : @"detail_url",
                                     @"descriptionPic" : @"description_pic",
                                     @"videoName" : @"question_video"
                                     };
    return propertyMapper;
}
@end

@implementation SKResponsePackage
SKINIT(SKResponsePackage)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = nil;
    return propertyMapper;
}
@end

@implementation SKArticle
SKINIT(SKArticle)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"mascotID"  : @"pet_id",
                                     @"articleID" : @"article_id",
                                     @"articleURL" : @"article_url",
                                     @"articleTitle" : @"article_title"};
    return propertyMapper;
}
@end

@implementation SKMascot
SKINIT(SKMascot)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"mascotID" : @"pet_id",
                                     @"getTime" : @"time",
                                     @"mascotName" : @"pet_name",
                                     @"mascotPic" : @"pet_pic",
                                     @"mascotDescription" : @"pet_desc"};
    return propertyMapper;
}
@end

@implementation SKMascotProp
@end

@implementation SKReward
@end

@implementation SKTicket
@end

@implementation SKNotification
@end

//@implementation SKProfileAnswer
//@end

@implementation SKProfileInfo
- (instancetype)init {
    if (self = [super init]) {
        [SKProfileInfo setupObjectClassInArray:^NSDictionary *{
            return @{@"answer_list" : @"SKQuestion"};
        }];
    }
    return self;
}

@end

@implementation SKUserInfo
+ (NSArray *)ignoredPropertyNames {
    return @[];
}

- (id)copyWithZone:(NSZone *)zone {
    SKUserInfo *userInfo = [[SKUserInfo alloc] init];
    userInfo.user_name = [_user_name copy];
    userInfo.user_avatar = [_user_avatar copy];
    userInfo.user_avatar_url = [_user_avatar_url copy];
    userInfo.mobile = [_mobile copy];
    userInfo.address = [_address copy];
    userInfo.push_setting = _push_setting;
    userInfo.settingType = _settingType;
    return userInfo;
}

@end

@implementation SKRanker
@end

@implementation SKBadge
@end
