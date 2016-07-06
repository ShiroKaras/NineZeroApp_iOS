//
//  HTCGIManager.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/9.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NETWORK_HOST @"http://101.201.39.169:8992/"

@interface HTCGIManager : NSObject

/**
 -1001	模块名未定义
 -2000	注册失败，请重试
 -2001	注册失败，手机号已注册
 -2002	注册失败，用户名已存在
 -2004	登录失败，请重试
 -2005	重置密码失败
 */

/**
 * @brief 注册
 ￼1. {
 2. "user_name":"90",
 3. "user_password":"*******"
 4. "user_mobile":"13212345678"
 5. "user_email":"test@qq.com"
 6. "user_avatar":"http://www.baidu.com/"
 7. "user_area_id":1,
 8. "code":"4578"
 9. }
 */
+ (NSString *)userBaseRegisterCGIKey;

/**
 *  @brief 验证手机号是否已经被注册
 *  "user_mobile" : "11111111111"
 */
+ (NSString *)userBaseVerifyMobileCGIKey;

/**
 *  @brief 获取手机验证码
 *  "user_mobile" : "11111111111"
 */
+ (NSString *)sendMobileCodeCGIKey;

/**
 * @brief 登录
 1. {
 2. "user_name":"90",
 3. "user_password":"*******"
 4. }
 */
+ (NSString *)userBaseLoginCGIKey;

/**
 * @brief 第三方登录
 1. {
 2. "user_name":"90",
 3. "user_avatar":"http://www.baidu.com/"
 4. "user_area_id":1,
 5. "third_id":"123123123"
 6. }
 */

+ (NSString *)userLoginThirdCGIKey;

/**
 * @brief 重置密码
1.  {
2.  "user_mobile":"13212345678",
3.  "code":"4578",
4.  "user_password":"*******"
5.  }
 */
+ (NSString *)userBaseResetPwdCGIKey;

/**
 *  @brief 获取题目相关的总体信息
 *  "area_id":"1"
 */
+ (NSString *)getQuestionInfoCGIKey;

/**
 *  @brief 获取题目列表
 *  "area_id":"1"
 *  "page":"1"
 *  "count":"10"
 */
+ (NSString *)getQuestionListCGIKey;

/**
 *  @brief 获取题目详情
 *  "question_id":"2015120423201902904"
 */
+ (NSString *)getQuestionDetailCGIKey;

/**
 *  @brief 获取答案详情
 */
+ (NSString *)getAnswerDetail;

/**
 *  @brief 获取额外的提示
 */
+ (NSString *)getExtraHintCGIKey;

/**
 *  @brief 获取奖励详情
 *  "reward_id" : 1
 */
+ (NSString *)getRewardCGIKey;
/**
 *  @brief 获取已经获得的零仔
 *  "user_id" : "1111111"
 */
+ (NSString *)getMascotsCGIKey;
/**
 *  @brief 获取已经获得的道具
 *  "user_id" : "1111111"
 */
+ (NSString *)getMascotPropsCGIKey;
/**
 *  @brief 获取零仔的额外信息
 *  "user_id" : "111111"
 *  "pet_id"  : "1"
 */
+ (NSString *)getMascotInfoCGIKey;
/**
 *  @brief 获取道具详情
 *  "user_id" : "111111"
 *  "prop_id" : "1"
 */
+ (NSString *)getMascotPropInfoCGIKey;
/**
 *  @brief 兑换道具
 */
+ (NSString *)exchangePropCGIKey;
/**
 *  @brief 验证回答答案
 *  "question_id" : "2015120423201902904"
 *  "answer" : "testtest"
 */
+ (NSString *)verifyAnswerCGIKey;
/**
 *  @brief 验证ar位置
 *  "location" : ""x":100 ,"y": 100"
 */
+ (NSString *)verifyLocationCGIKey;
/**
 *  @brief 获取七牛token
 *  "key" : "video.mp4"
 */
+ (NSString *)getQiniuPrivateUploadTokenCGIKey;
/**
 *  @brief 获取七牛公开空间token
 */
+ (NSString *)getQiniuPublicUploadTokenCGIKey;
/**
 *  @brief 获取七牛下载链接
 *  "url_array" : {"key" : "flower.jpg", "key2" : "flower2.jpg"}
 */
+ (NSString *)getQiniuDownloadUrlCGIKey;

/**
 *  @brief 获取个人主页信息
 *  "user_id"
 */
+ (NSString *)getProfileInfoCGIKey;

/**
 *  @brief 获取礼券
 *  "user_id"
 */
+ (NSString *)getUserTicketsCGIKey;

/**
 *  @brief 获取通知列表
 *  "user_id"
 *  "pet_id"
 */
+ (NSString *)getUserNoticesCGIKey;

/**
 *  @brief 获取封面图片
 */
+ (NSString *)getCoverPictureCGIKey;

/**
 *  @brief 获取个人信息
 *  "user_id"
 */
+ (NSString *)getUserInfoCGIKey;

/**
 *  @brief 更新设置
 *  "user_id"
 *  "address"      可选
 *  "mobile"       可选
 *  "push_setting" 可选
 */
+ (NSString *)updateSettingCGIKey;

/**
 *  @brief 更新个人信息
 *  "user_id"
 *  "user_name"   可选
 *  "user_avatar" 可选
 */
+ (NSString *)updateUserInfoCGIKey;

/**
 *  @brief 意见反馈
 *  "content"
 *  "contact"
 */
+ (NSString *)updateFeedbackCGIKey;

/**
 *  @brief 获取往期文章
 *  "page"
 *  "count"
 */
+ (NSString *)getArticlesCGIKey;

/**
 *  @brief 获取文章
 *  "article_id"
 */
+ (NSString *)getArticleCGIKey;

/**
 *  @brief 获取收藏文章
 *  "user_id"
 *  "page"
 *  "count"
 */
+ (NSString *)getCollectArticlesCGIKey;

/**
 *  @brief 收藏文章
 *  "user_id"
 *  "article_id"
 */
+ (NSString *)collectArticleCGIKey;

/**
 *  @brief 获取勋章
 *  "user_id"
 */
+ (NSString *)getBadgesCGIKey;

/**
 *  @brief 获取自己的排名
 *  "user_id"
 */
+ (NSString *)getMyRankCGIKey;

/**
 *  @brief 获取比赛休息日
 */
+ (NSString *)getRelaxDayInfoCGIKey;

/**
 *  @brief 是否是休息日
 */
+ (NSString *)getIsMondayCGIKey;

/**
 *  @brief 获取前100名的排名列表
 */
+ (NSString *)getAllRanksCGIKey;

@end
