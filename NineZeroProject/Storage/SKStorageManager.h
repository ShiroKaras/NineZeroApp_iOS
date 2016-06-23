//
//  SKStorageManager.h
//  NineZeroProject
//
//  Created by SinLemon on 16/6/22.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKLoginUser;
@class SKUserInfo;
@class SKProfileInfo;
@class SKMascot;

@interface SKStorageManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) SKUserInfo *userInfo;
@property (nonatomic, strong) SKProfileInfo *profileInfo;
@property (nonatomic, strong) SKMascot *mascotInfo;

@property (nonatomic, strong) NSString *qiniuPublicToken;

- (void)updateLoginUser:(SKLoginUser *)loginUser;
- (SKLoginUser *)getLoginUser;
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

- (void)setMascotInfo:(SKMascot *)mascotInfo withIndex:(NSUInteger)index;
- (SKMascot *)getMascotInfoWithIndex:(NSUInteger)index;
@end
