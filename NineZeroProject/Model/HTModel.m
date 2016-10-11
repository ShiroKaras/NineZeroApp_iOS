//
//  HTModel.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/12/7.
//  Copyright © 2015年 HHHHTTTT. All rights researrayed.
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
                                     @"videoName" : @"question_video"
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

@implementation HTAnswerDetail
HTINIT(HTAnswerDetail)
//- (instancetype)init {
//    if (self = [super init]) {
//        [HTAnswerDetail setupObjectClassInArray:^NSDictionary *{
//            return @{@"answer_list" : @"HTArticle"};
//        }];
//    }
//    return self;
//}

- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"headerImageURL" : @"answer_detail.article_pic_1",
                                     @"backgroundImageURL" : @"answer_detail.article_pic",
                                     @"contentText" : @"answer_detail.article_desc"
                                     };
    return propertyMapper;
}

@end

@implementation HTMascot
HTINIT(HTMascot)
//+ (NSDictionary *)objectClassInArray{
//    return @{
//             @"articles" : @"HTArticle",
//             };
//}

- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"mascotID" : @"pet_id",
                                     @"getTime" : @"time",
                                     @"mascotName" : @"pet_name",
                                     @"mascotPic" : @"pet_pic",
                                     @"mascotDescription" : @"pet_desc",
                                     @"articles" : @"articles"};
    return propertyMapper;
}
@end

@implementation HTMascotProp
@end

@implementation HTReward
@end

@implementation HTTicket
@end

@implementation HTNotification
@end

//@implementation HTProfileAnswer
//@end

@implementation HTProfileInfo
- (instancetype)init {
    if (self = [super init]) {
        [HTProfileInfo setupObjectClassInArray:^NSDictionary *{
            return @{@"answer_list" : @"HTQuestion"};
        }];
    }
    return self;
}

@end

@implementation HTUserInfo
+ (NSArray *)ignoredPropertyNames {
    return @[];
}

- (id)copyWithZone:(NSZone *)zone {
    HTUserInfo *userInfo = [[HTUserInfo alloc] init];
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

@implementation HTRanker
@end

@implementation HTBadge
@end

@implementation HTScanning
@end
