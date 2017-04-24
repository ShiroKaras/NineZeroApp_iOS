//
//  SKServiceManager.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTLogicHeader.h"

#import "SKLoginService.h"
#import "SKQuestionService.h"
#import "SKProfileService.h"
#import "SKPropService.h"
#import "SKMascotService.h"
#import "SKAnswerService.h"
#import "SKCommonService.h"
#import "SKScanningService.h"
#import "SKSecretaryService.h"
#import "SKStrongHoldService.h"
#import <Qiniu/QiniuSDK.h>

@interface SKServiceManager : NSObject

+ (instancetype)sharedInstance;

/** loginService，负责登录相关业务 */
- (SKLoginService *)loginService;

/** questionService, 负责题目相关业务 */
- (SKQuestionService *)questionService;

/** profileService, 负责个人主页相关业务 */
- (SKProfileService *)profileService;

/** profileService, 负责道具相关业务 */
- (SKPropService *)propService;

/** profileService, 负责零仔相关业务 */
- (SKMascotService *)mascotService;

/** profileService, 负责答题相关业务 */
- (SKAnswerService *)answerService;

/** scanningService, 负责扫一扫相关业务 */
- (SKScanningService *)scanningService;

/** commonService, 负责公共部分相关业务 */
- (SKCommonService *)commonService;

/** secretaryService, 负责秘书部分相关业务 */
- (SKSecretaryService *)secretaryService;

/** strongholdService, 负责据点部分相关业务 */
- (SKStrongHoldService *)strongholdService;

/** qiniuService, 负责七牛相关的业务 */
- (QNUploadManager *)qiniuService;

@end
