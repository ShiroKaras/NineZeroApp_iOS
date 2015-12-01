//
//  HTServiceManager.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLoginService.h"
#import "HTLoginUser.h"
#import <Qiniu/QiniuSDK.h>
#import <YTKKeyValueStore.h>

@interface HTServiceManager : NSObject

+ (instancetype)sharedInstance;

/** loginService，负责登录相关流程 */
- (HTLoginService *)loginService;

/** qiniuService, 负责七牛相关的业务 */
- (QNUploadManager *)qiniuService;

@end
