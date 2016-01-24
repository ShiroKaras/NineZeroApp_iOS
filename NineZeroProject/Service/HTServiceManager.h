//
//  HTServiceManager.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLoginService.h"
#import "HTQuestionService.h"
#import "HTMascotService.h"
#import "HTModel.h"
#import <Qiniu/QiniuSDK.h>
#import <YTKKeyValueStore.h>

@interface HTServiceManager : NSObject

+ (instancetype)sharedInstance;

/** loginService，负责登录相关业务 */
- (HTLoginService *)loginService;

/** questionService, 负责题目相关业务 */
- (HTQuestionService *)questionService;

/** mascotService, 负责零仔和道具相关业务 */
- (HTMascotService *)mascotService;

/** qiniuService, 负责七牛相关的业务 */
- (QNUploadManager *)qiniuService;

@end
