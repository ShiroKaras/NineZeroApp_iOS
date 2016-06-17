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
@class HTMascot;

@interface HTStorageManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) HTUserInfo *userInfo;
@property (nonatomic, strong) HTProfileInfo *profileInfo;
@property (nonatomic, strong) HTMascot *mascotInfo;

@property (nonatomic, strong) NSString *qiniuPublicToken;

- (void)updateLoginUser:(HTLoginUser *)loginUser;
- (HTLoginUser *)getLoginUser;
- (void)clearLoginUser;

// user_id
- (void)updateUserID:(NSString *)userID;
- (NSString *)getUserID;
- (void)clearUserID;

// user_token
- (void)updateUserToken:(NSString *)token;
- (NSString *)getUserToken;
- (void)clearUserToken;

// password salt
- (void)updatePwdSalt:(NSString *)salt;
- (NSString *)getPwdSalt;

// 七牛Token
- (void)updateQiniuToken:(NSString *)token;
- (NSString *)getQiniuToken;

- (void)setMascotInfo:(HTMascot *)mascotInfo withIndex:(NSUInteger)index;
- (HTMascot *)getMascotInfoWithIndex:(NSUInteger)index;

@end
