//
//  SKTopicService.h
//  NineZeroProject
//
//  Created by SinLemon on 2017/5/2.
//  Copyright © 2017年 SinLemon. All rights reserved.
//

#import "SKLogicHeader.h"
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "SKNetworkDefine.h"
#import "SKLogicHeader.h"
#import "CommonDefine.h"

@interface SKTopicService : NSObject

typedef void (^SKBannerListCallback) (BOOL success, NSArray<SKBanner*> *bannerList);
typedef void (^SKTopicListCallback) (BOOL success, NSArray<SKTopic*> *topicList);

- (void)getBannerListCallback:(SKBannerListCallback)callback;

- (void)getTopicListCallback:(SKTopicListCallback)callback;

- (void)getTopicDetailWithID:(NSString *)topicID callback:(void(^)(BOOL success, SKTopicDetail *topicDetail))callback;

- (void)submitCommentWithTopicID:(NSString*)topicID content:(NSString*)content callback:(SKResponseCallback)callback;

@end
