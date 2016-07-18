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
        [T mj_setupReplacedKeyFromPropertyName:^NSDictionary *{ \
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

@implementation SKResponsePackage
SKINIT(SKResponsePackage)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"resultCode" : @"code"
                                     };
    return propertyMapper;
}
@end

@implementation SKLoginUser
@end

@implementation SKQuestionInfo
SKINIT(SKQuestionInfo)
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
    NSDictionary *propertyMapper = @{@"questionID" : @"id",
                                     @"areaID" : @"city_code",
                                     @"type" : @"category",
                                     @"content" : @"title",
                                     @"questionDescription" : @"description",
                                     @"descriptionPic" : @"description_pic.file_name",
                                     @"descriptionPicURL" : @"description_pic.url",
                                     @"rewardID" : @"reward_id",
                                     @"use_time" : @"time_taken",
                                     @"videoName" : @"video.resource.file_name",
                                     @"videoURL" : @"video.resource.url",
                                     @"videoCoverPic" : @"video.cover_picture.file_name",
                                     @"videoCoverPicURL" : @"video.cover_picture.url",
                                     @"answerBackgroundPic" : @"answer_background_picture.file_name",
                                     @"answerBackgroundPicURL" : @"answer_background_picture.url",
                                     @"answerPic" : @"answer_picture.file_name",
                                     @"answerPicURL" : @"answer_picture.url",
                                     @"endTime" : @"end_at"
//                                     @"answers" : @"question_answer",
//                                     @"detailURL" : @"detail_url",
                                     };
    return propertyMapper;
}
@end

@implementation SKRestDay
SKINIT(SKRestDay)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"backgroundPictureURL" : @"background_picture.url",
                                     @"endTime" : @"end_at_seconds",
                                     
                                     @"article_id" : @"article.id",
                                     @"article_title" : @"article.title",
                                     @"article_subtitle" : @"article.subtitle",
                                     @"article_iconURL" : @"article.icon.url",
                                     @"article_pictureURL" : @"article.picture.url",
                                     @"article_detailURL" : @"article.detail.url",
                                     @"article_petID" : @"article.pet_id",
                                     @"article_pushed" : @"article.pushed",
                                     @"article_pushTime" : @"article_pushed_at",
                                     
                                     @"video_id" : @"video.id",
                                     @"video_title" : @"video.title",
                                     @"video_coverURL" : @"video.cover_picture.url",
                                     @"video_resourceURL" : @"video.resource.url"
                                     };
    return propertyMapper;
}
@end

@implementation SKArticle
SKINIT(SKArticle)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"mascotID"  : @"pet_id",
                                     @"articleID" : @"id",              //缺
                                     @"articleURL" : @"content.url",
                                     @"articleTitle" : @"title"};
    return propertyMapper;
}
@end

@implementation SKMascot
SKINIT(SKMascot)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"mascotID" : @"id",
                                     @"mascotName" : @"name",
                                     @"getTime" : @"time",
                                     @"mascotPic" : @"picture.url",
                                     @"mascotGif" : @"gif.url",
                                     @"mascotDescription" : @"description"};
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
SKINIT(SKNotification)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"notice_id" : @"id",
                                     };
    return propertyMapper;
}
@end

//@implementation SKProfileAnswer
//@end

@implementation SKProfileInfo
- (instancetype)init {
    if (self = [super init]) {
        [SKProfileInfo mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"user_answers" : @"SKQuestion"};
        }];
        
        [SKProfileInfo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return [self propertyMapper];
        }];
    }
    return self;
}

- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"ticketCount" : @"ticket_count",
                                     @"medalCount"  : @"medal_count",
                                     @"propCount"   : @"prop_count",
                                     @"articleCount": @"article_collection_count",
                                     @"noticeCount" : @"message_unread_count"
                                     };
    return propertyMapper;
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
SKINIT(SKRanker)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"user_name"   : @"name",
                                     @"user_avatar" : @"avatar_url"
                                     };
    return propertyMapper;
}
@end

@implementation SKGoldRecord
SKINIT(SKGoldRecord)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"goldNumber"   : @"number",
                                     @"goldDescription" : @"description"
                                     };
    return propertyMapper;
}
@end

@implementation SKBadge
@end