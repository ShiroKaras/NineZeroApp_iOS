//
//  HTStorageManager.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/25.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLoginUser;

@interface HTStorageManager : NSObject

+ (instancetype)sharedInstance;

- (void)updateLoginUser:(HTLoginUser *)loginUser;
- (HTLoginUser *)getLoginUser;

// user_id
- (void)updateUserID:(NSString *)userID;
- (NSString *)getUserID;

// password salt
- (void)updatePwdSalt:(NSString *)salt;
- (NSString *)getPwdSalt;

// 七牛Token
- (void)updateQiniuToken:(NSString *)token;
- (NSString *)getQiniuToken;

@end
