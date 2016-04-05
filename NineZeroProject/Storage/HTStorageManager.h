//
//  HTStorageManager.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 15/11/25.
//  Copyright © 2015年 HHHHTTTT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLoginUser;
@class HTUserInfo;
@class HTProfileInfo;

@interface HTStorageManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) HTUserInfo *userInfo;
@property (nonatomic, strong) HTProfileInfo *profileInfo;

@property (nonatomic, strong) NSString *qiniuPublicToken;

- (void)updateLoginUser:(HTLoginUser *)loginUser;
- (HTLoginUser *)getLoginUser;
- (void)clearLoginUser;

// user_id
- (void)updateUserID:(NSString *)userID;
- (NSString *)getUserID;
- (void)clearUserID;

// password salt
- (void)updatePwdSalt:(NSString *)salt;
- (NSString *)getPwdSalt;

// 七牛Token
- (void)updateQiniuToken:(NSString *)token;
- (NSString *)getQiniuToken;

@end
