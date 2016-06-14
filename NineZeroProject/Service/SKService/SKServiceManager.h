//
//  SKServiceManager.h
//  NineZeroProject
//
//  Created by SinLemon on 16/6/14.
//  CopyrigSK © 2016年 ronhu. All rigSKs reserved.
//

#import <Foundation/Foundation.h>
#import "SKLoginService.h"
#import "SKQuestionService.h"
#import "SKMascotService.h"
#import "SKProfileService.h"
#import "HTStorageManager.h"
#import "HTModel.h"
#import <Qiniu/QiniuSDK.h>
#import <YTKKeyValueStore.h>
#import "CommonDefine.h"

@interface SKServiceManager : NSObject

+ (instancetype)sharedInstance;

/** loginService，负责登录相关业务 */
- (SKLoginService *)loginService;

/** questionService, 负责题目相关业务 */
- (SKQuestionService *)questionService;

/** mascotService, 负责零仔和道具相关业务 */
- (SKMascotService *)mascotService;

/** profileService, 负责个人中心相关业务 */
- (SKProfileService *)profileService;

/** qiniuService, 负责七牛相关的业务 */
- (QNUploadManager *)qiniuService;

/** 存储相关 */
- (HTStorageManager *)storageManager;

@end
