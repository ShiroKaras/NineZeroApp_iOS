//
//  SKCGIManager.m
//  NineZeroProject
//
//  Created by SinLemon on 16/6/16.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKCGIManager.h"

#define CGI_EXTRA(e) [NSString stringWithFormat:@"%@%@", NETWORK_HOST,e]

@implementation SKCGIManager

+ (NSString *)userBaseLoginCGIKey {
    return CGI_EXTRA(@"api/login");
}

+ (NSString *)userBaseRegisterCGIKey {
    return CGI_EXTRA(@"api/register");
}

+ (NSString *)userResetPasswordCGIKey {
    return CGI_EXTRA(@"api/reset_password");
}


+ (NSString *)userBaseInfoCGIKey {
    return CGI_EXTRA(@"api/user");
}

+ (NSString *)userProfileCGIKey {
    return CGI_EXTRA(@"api/profile");
}

+ (NSString *)userRankCGIKey {
    return CGI_EXTRA(@"api/rank");
}


+ (NSString *)questionCGIKey {
    return CGI_EXTRA(@"api/question");
}

+ (NSString *)messageCGIKey {
    return CGI_EXTRA(@"api/message");
}

+ (NSString *)restdayCGIKey {
    return CGI_EXTRA(@"api/restday");
}

+ (NSString *)rewardCGIKey {
    return CGI_EXTRA(@"api/restday");
}

+ (NSString *)answerCGIKey {
    return CGI_EXTRA(@"api/answer");
}


+ (NSString *)resourceCGIKey {
    return CGI_EXTRA(@"api/resource");
}

#pragma mark - Actions

#pragma mark 登录
+ (NSString *)login_Phonenumber_Action {
    return @"phone_password_login";
}

+ (NSString *)login_ThirdPlatform_Action {
    return @"third_party_id_login";
}

#pragma mark 注册
+ (NSString *)register_newService_Action {
    return @"new_registeration";
}

+ (NSString *)register_sendVerificationCode_Action {
    return @"send_verification_code";
}

+ (NSString *)register_checkVerificaitonCode_Action {
    return @"check_verification_code";
}

+ (NSString *)register_create_Action {
    return @"create_user";
}

#pragma mark 修改密码
+ (NSString *)resetPassword_newService_Action {
    return @"new_reset_password";
}

+ (NSString *)resetPassword_sendVerificationCode_Action {
    return @"send_verification_code";
}

+ (NSString *)resetPassword_checkVerificationCode_Action {
    return @"check_verification_code";
}

+ (NSString *)resetPassword_update_Action {
    return @"update_user_password";
}

#pragma mark 修改用户名
+ (NSString *)resetUserName_Action {
    return @"update_user_name";
}

#pragma mark 修改头像
+ (NSString *)updateAvatar_newService_Action {
    return @"new_update_user_avatar";
}

+ (NSString *)updateAvatar_update_Action {
    return @"update_user_avatar";
}

#pragma mark 个人主页
+ (NSString *)profile_getProfile_Action {
    return @"get_user_profile";
}

+ (NSString *)profile_getRankList_Action {
    return @"get_list";
}

+ (NSString *)profile_getGoldRecords_Action {
    return @"get_user_gold_records";
}

+ (NSString *)profile_getCollectionAticles_Action {
    return @"get_user_article_collections";
}

+ (NSString *)profile_getMascot_Action {
    return @"get_pet_collections";
}

+ (NSString *)profile_getAnswerRecords_Action {
    return @"get_success_question";
}

+ (NSString *)profile_getMessageList_Action {
    return @"get_affiche";
}

#pragma mark 停赛日
+ (NSString *)restday_isRestday_Action {
    return @"is_rest_day";
}

+ (NSString *)restday_getRestday_Action {
    return @"get_rest_day";
}

#pragma mark 题目
+ (NSString *)question_getCurrentQuestion_Action {
    return @"get_current_question";
}

+ (NSString *)question_getQuestionList_Action {
    return @"get_list";
}

+ (NSString *)question_checkAnswer_Action {
    return @"check_answer";
}

#pragma mark 题目奖励
+ (NSString *)reward_getReward_Action {
    return @"get_reward";
}

#pragma mark 以下API不需要登录
+ (NSString *)resource_getMascot_Action {
    return @"get_pets";
}

+ (NSString *)resource_getMedals_Action {
    return @"get_medals";
}

@end
