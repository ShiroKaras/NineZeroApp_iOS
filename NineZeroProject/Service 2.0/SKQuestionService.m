//
//  SKQuestionService.m
//  NineZeroProject
//
//  Created by SinLemon on 2016/11/29.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import "SKQuestionService.h"
#import "SKServiceManager.h"

@implementation SKQuestionService

- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"90appbundle" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}

- (void)questionBaseRequestWithParam:(NSDictionary *)dict callback:(SKResponseCallback)callback {
    // Create manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setSecurityPolicy:[self customSecurityPolicy]];
    
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];// (NSTimeInterval) time = 1427189152.313643
    long long int currentTime=(long long int)time;      //NSTimeInterval返回的是double类型
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [mDict setValue:[NSString stringWithFormat:@"%lld",currentTime] forKey:@"time"];
    [mDict setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"edition"];
    [mDict setValue:@"iOS" forKey:@"client"];
    [mDict setValue:[[SKStorageManager sharedInstance] getUserID]  forKey:@"user_id"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DLog(@"Json ParamString: %@", jsonString);
    
    NSDictionary *param = @{@"data" : [NSString encryptUseDES:jsonString key:nil]};
    
    [manager POST:[SKCGIManager questionBaseCGIKey] parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSString *desString = [NSString decryptUseDES:responseObject[@"data"] key:nil];
//        NSDictionary *desDict = [desString dictionaryWithJsonString];
        DLog(@"Response:%@",responseObject);
        SKResponsePackage *package = [SKResponsePackage objectWithKeyValues:responseObject];
        callback(YES, package);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        DLog(@"%@", error);
        callback(NO, nil);
    }];
}

//全部关卡
- (void)getAllQuestionListCallback:(SKQuestionListCallback)callback {
    NSDictionary *param = @{
                            @"method"   :   @"getList",
                            @"area_id"  :   @"010"
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray<SKQuestion *> *questions_season1 = [[NSMutableArray alloc] init];
        NSMutableArray<SKQuestion *> *questions_season2 = [[NSMutableArray alloc] init];
        for (int i = 0; i != [response.data[@"first_season"] count]; i++) {
            SKQuestion *question = [SKQuestion objectWithKeyValues:[response.data[@"first_season"] objectAtIndex:i]];
            [questions_season1 insertObject:question atIndex:0];
        }
        for (int i = 0; i != [response.data[@"second_season"] count]; i++) {
            SKQuestion *question = [SKQuestion objectWithKeyValues:[response.data[@"second_season"] objectAtIndex:i]];
            [questions_season2 insertObject:question atIndex:0];
        }
        _questionList = questions_season2;
        callback (YES, (long)response.data[@"first_season_answered"], (long)response.data[@"second_season_answered"], questions_season1, questions_season2);
    }];
}

//极难题列表
- (void)getDifficultQuestionListCallback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"   :   @"difficultProblem",
                            @"area_id"  :   @"010"
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//题目详情
- (void)getQuestionDetailWithQuestionID:(NSString*)questionID callback:(SKQuestionDetialCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"detail",
                            @"area_id"      :   @"010",
                            @"qid"          :   questionID
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        SKQuestion *question = [SKQuestion objectWithKeyValues:[response.data keyValues]];
        NSMutableArray<NSString *> *downloadKeys = [NSMutableArray array];
        if (question.question_video) [downloadKeys addObject:question.question_video];
        if (question.question_video_cover) [downloadKeys addObject:question.question_video_cover];
        if (question.description_pic) [downloadKeys addObject:question.description_pic];
        if (question.question_ar_pet) [downloadKeys addObject:question.question_ar_pet];
        [[[SKServiceManager sharedInstance] commonService] getQiniuDownloadURLsWithKeys:downloadKeys callback:^(BOOL success, SKResponsePackage *response) {
            if (success) {
                if (question.question_video) question.question_video_url = response.data[question.question_video];
                if (question.question_video_cover) question.question_video_cover = response.data[question.question_video_cover];
                if (question.description_pic) question.description_pic = response.data[question.description_pic];
                if (question.question_ar_pet) question.question_ar_pet_url = response.data[question.question_ar_pet];
                callback(success, question);
            } else {
                callback(false, question);
            }
        }];
    }];
}

//关卡线索列表
- (void)getQuestionDetailCluesWithQuestionID:(NSString*)questionID callback:(SKQuestionHintListCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"clueList",
                            @"area_id"      :   @"010",
                            @"qid"          :   questionID
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        SKHintList *hintList = [SKHintList objectWithKeyValues:[response.data keyValues]];
        callback(success, response.result, hintList);
    }];
}

//购买线索
- (void)purchaseQuestionClueWithQuestionID:(NSString*)questionID callback:(SKResponseCallback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getClue",
                            @"area_id"      :   @"010",
                            @"qid"          :   questionID
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        callback(success, response);
    }];
}

//查看答案
- (void)getQuestionAnswerDetailWithQuestionID:(NSString *)questionID callback:(SKQuestionAnswerDetail)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getAnswerDetail",
                            @"area_id"      :   @"010",
                            @"qid"          :   questionID
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        SKAnswerDetail *answerDetail = [SKAnswerDetail objectWithKeyValues:[response.data keyValues]];
        NSMutableArray<NSString *> *downloadKeys = [NSMutableArray array];
        if (answerDetail.article_Illustration) [downloadKeys addObject:answerDetail.article_Illustration];
        if (answerDetail.article_Illustration_cover) [downloadKeys addObject:answerDetail.article_Illustration_cover];
        [[[SKServiceManager sharedInstance] commonService] getQiniuDownloadURLsWithKeys:downloadKeys callback:^(BOOL success, SKResponsePackage *response) {
            if (success) {
                if (answerDetail.article_Illustration) answerDetail.article_Illustration_url = response.data[answerDetail.article_Illustration];
                if (answerDetail.article_Illustration_cover) answerDetail.article_Illustration_cover_url = response.data[answerDetail.article_Illustration_cover];
                callback(success, answerDetail);
            } else {
                callback(false, answerDetail);
            }
        }];

        callback(success, answerDetail);
    }];
}

- (void)getQuestionTop10WithQuestionID:(NSString *)questionID callback:(SKQuestionTop10Callback)callback {
    NSDictionary *param = @{
                            @"method"       :   @"getTopAnsweredUserList",
                            @"area_id"      :   @"010",
                            @"qid"          :   questionID
                            };
    [self questionBaseRequestWithParam:param callback:^(BOOL success, SKResponsePackage *response) {
        NSMutableArray *rankList = [NSMutableArray array];
        for (int i=0; i<[response.data count]; i++) {
            SKUserInfo *userInfo = [SKUserInfo objectWithKeyValues:response.data[i]];
            [rankList addObject:userInfo];
        }
        callback(success, rankList);
    }];
}

@end
