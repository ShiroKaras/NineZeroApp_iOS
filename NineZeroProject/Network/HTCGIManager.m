//
//  HTCGIManager.m
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/9.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCGIManager.h"

#define CGI_EXTRA(e) [NSString stringWithFormat:@"%@e", NETWORK_HOST]

@implementation HTCGIManager

+ (NSString *)userBaseRegisterCGIKey {
    return [NSString stringWithFormat:@"%@Login/register/", NETWORK_HOST];
}

+ (NSString *)userBaseLoginCGIKey {
    return [NSString stringWithFormat:@"%@Login/login/", NETWORK_HOST];
}

+ (NSString *)userLoginThirdCGIKey {
    return [NSString stringWithFormat:@"%@Login/login_third", NETWORK_HOST];
}

+ (NSString *)sendMobileCodeCGIKey {
    return [NSString stringWithFormat:@"%@Login/sendCode/", NETWORK_HOST];
}

+ (NSString *)userBaseResetPwdCGIKey {
    return [NSString stringWithFormat:@"%@Login/reset/", NETWORK_HOST];
}

+ (NSString *)userBaseVerifyMobileCGIKey {
    return [NSString stringWithFormat:@"%@Login/check_mobile/", NETWORK_HOST];
}

+ (NSString *)getQiniuPrivateUploadTokenCGIKey {
    return [NSString stringWithFormat:@"%@Common/getQiniuToken", NETWORK_HOST];
}

+ (NSString *)getQiniuPublicUploadTokenCGIKey {
    return [NSString stringWithFormat:@"%@Common/getQiniuPublicToken", NETWORK_HOST];
}

+ (NSString *)getQiniuDownloadUrlCGIKey {
    return [NSString stringWithFormat:@"%@Common/getDownloadUrl", NETWORK_HOST];
}

+ (NSString *)getQuestionInfoCGIKey {
    return [NSString stringWithFormat:@"%@Question/info", NETWORK_HOST];
}

+ (NSString *)getQuestionListCGIKey {
    return [NSString stringWithFormat:@"%@Question/getList", NETWORK_HOST];
}

+ (NSString *)getRelaxDayInfoCGIKey {
    return [NSString stringWithFormat:@"%@Question/getRestPush", NETWORK_HOST];
}

+ (NSString *)getQuestionDetailCGIKey {
    return [NSString stringWithFormat:@"%@Question/detail", NETWORK_HOST];
}

+ (NSString *)shareQuestionCGIKey {
    return [NSString stringWithFormat:@"%@Question/shareQuestion", NETWORK_HOST];
}

+ (NSString *)getAnswerDetailCGIKey {
    return [NSString stringWithFormat:@"%@Question/getAnswerDetail", NETWORK_HOST];
}

+ (NSString *)getRankListCGIKey {
    return [NSString stringWithFormat:@"%@Question/getTopAnsweredUserList", NETWORK_HOST];
}

+ (NSString *)getUsersRandomListCGIKey {
    return [NSString stringWithFormat:@"%@Question/getAnsweredRandUserList", NETWORK_HOST];
}

+ (NSString *)getExtraHintCGIKey {
    return [NSString stringWithFormat:@"%@Question/getRestHint", NETWORK_HOST];
}

+ (NSString *)getRewardCGIKey {
    return [NSString stringWithFormat:@"%@Question/getReward", NETWORK_HOST];
}

+ (NSString *)getMascotsCGIKey {
    return [NSString stringWithFormat:@"%@Pet/getPets", NETWORK_HOST];
}

+ (NSString *)getMascotPropsCGIKey {
    return [NSString stringWithFormat:@"%@Pet/getProps", NETWORK_HOST];
}

+ (NSString *)getMascotInfoCGIKey {
    return [NSString stringWithFormat:@"%@Pet/getPetDetail", NETWORK_HOST];
}

+ (NSString *)getMascotPropInfoCGIKey {
    return [NSString stringWithFormat:@"%@Pet/getPropDetail", NETWORK_HOST];
}

+ (NSString *)exchangePropCGIKey {
    return [NSString stringWithFormat:@"%@Pet/exchangeProp", NETWORK_HOST];
}

+ (NSString *)verifyAnswerCGIKey {
    return [NSString stringWithFormat:@"%@Answer/answerText", NETWORK_HOST];
}

+ (NSString *)verifyOldAnswerCGIKey {
    return [NSString stringWithFormat:@"%@Answer/answerOldText", NETWORK_HOST];
}

+ (NSString *)verifyLocationCGIKey {
    return [NSString stringWithFormat:@"%@Answer/answerAR", NETWORK_HOST];
}

+ (NSString *)getProfileInfoCGIKey {
    return [NSString stringWithFormat:@"%@User/getUserInfo", NETWORK_HOST];
}

+ (NSString *)updateUserInfoCGIKey {
    return [NSString stringWithFormat:@"%@User/updateName", NETWORK_HOST];
}

+ (NSString *)updateFeedbackCGIKey {
    return [NSString stringWithFormat:@"%@User/feedback", NETWORK_HOST];
}

+ (NSString *)updateSettingCGIKey {
    return [NSString stringWithFormat:@"%@User/updateSetting", NETWORK_HOST];
}

+ (NSString *)getUserInfoCGIKey {
    return [NSString stringWithFormat:@"%@User/getBaseInfo", NETWORK_HOST];
}

+ (NSString *)getUserTicketsCGIKey {
    return [NSString stringWithFormat:@"%@User/getUserTickets", NETWORK_HOST];
}

+ (NSString *)getArticlesCGIKey {
    return [NSString stringWithFormat:@"%@Article/getArticles", NETWORK_HOST];
}

+ (NSString *)getArticleCGIKey {
    return [NSString stringWithFormat:@"%@Article/getArticle", NETWORK_HOST];
}

+ (NSString *)getCollectArticlesCGIKey {
    return [NSString stringWithFormat:@"%@Article/getMyArticles", NETWORK_HOST];
}

+ (NSString *)readArticleCGIKey {
    return [NSString stringWithFormat:@"%@Article/readArticle", NETWORK_HOST];
}

+ (NSString *)getUserNoticesCGIKey {
    return [NSString stringWithFormat:@"%@User/getNotice", NETWORK_HOST];
}

+ (NSString *)getIsMondayCGIKey {
    return [NSString stringWithFormat:@"%@Common/isMonday", NETWORK_HOST];
}

+ (NSString *)getCoverPictureCGIKey {
    return [NSString stringWithFormat:@"%@Question/getPicture", NETWORK_HOST];
}

+ (NSString *)getBadgesCGIKey {
    return [NSString stringWithFormat:@"%@Medal/getMedal", NETWORK_HOST];
}

+ (NSString *)getMyRankCGIKey {
    return [NSString stringWithFormat:@"%@User/getRank", NETWORK_HOST];
}

+ (NSString *)getAllRanksCGIKey {
    return [NSString stringWithFormat:@"%@User/getAllRank", NETWORK_HOST];
}

+ (NSString *)collectArticleCGIKey {
    return [NSString stringWithFormat:@"%@Article/collectArticle", NETWORK_HOST];
}

+ (NSString *)shareArticleCGIKey {
    return [NSString stringWithFormat:@"%@Article/shareArticle", NETWORK_HOST];
}

+ (NSString *)getVersionCGIKey {
    return [NSString stringWithFormat:@"%@Common/latestClientVersion", NETWORK_HOST];
}

@end
