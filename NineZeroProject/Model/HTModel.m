//
//  HTModel.m
//  NineZeroProject
//
//  Created by ronhu on 15/12/7.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import "HTModel.h"
#import <MJExtension.h>

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
