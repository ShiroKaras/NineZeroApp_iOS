//
//  SKModel.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/1.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKModel.h"
#import <MJExtension.h>

#define HTINIT(T) - (instancetype)init { \
if (self = [super init]) { \
[T setupReplacedKeyFromPropertyName:^NSDictionary *{ \
return [self propertyMapper]; \
}]; \
} \
return self; \
}

@implementation SKResponsePackage
@end

@implementation SKLoginUser
@end

@implementation SKUserInfo
@end

@implementation SKProfileInfo 
@end

@implementation SKUserSetting
@end

@implementation SKIndexInfo
HTINIT(SKIndexInfo)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"question_end_time" : @"question_info.end_time",
                                     @"qid"               : @"question_info.qid",
                                     @"answered_status"   : @"question_info.answered_status",
                                     @"monday_end_time"   : @"Monday.end_time",
                                     @"adv_pic"           : @"advertising.adv_pic"
                                     };
    return propertyMapper;
}
@end

@implementation SKQuestion
HTINIT(SKQuestion)
- (NSDictionary *)propertyMapper {
    NSDictionary *propertyMapper = @{@"description_url" : @"description"
                                     };
    return propertyMapper;
}
@end

@implementation SKHintList
@end

@implementation SKAnswerDetail
@end

@implementation SKMascotProp
@end

@implementation SKTicket
@end

@implementation SKPiece
@end

@implementation SKPet
@end

@implementation SKReward
@end

@implementation SKBadge
@end
