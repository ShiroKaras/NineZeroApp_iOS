//
//  HTServiceManager.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/9.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLoginService.h"
#import "HTQuestionService.h"
#import "HTMascotService.h"
#import "HTProfileService.h"
#import "HTStorageManager.h"
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

/** profileService, 负责个人中心相关业务 */
- (HTProfileService *)profileService;

/** qiniuService, 负责七牛相关的业务 */
- (QNUploadManager *)qiniuService;

/** 存储相关 */
- (HTStorageManager *)storageManager;

@end
