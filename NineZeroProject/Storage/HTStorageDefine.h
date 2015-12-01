//
//  HTStorageDefine.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/9.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

/** DB name */
extern NSString *const kStorageDBNameKey;

/** 存储用户数据的表 */
extern NSString *const kStorageTableLoginUserInfoKey;

#pragma mark - Login

/** login_user 登录用户的相关信息 */
extern NSString *const kStorageLoginUserKey;

/** user_id */
extern NSString *const kStorageUserIdKey;

/** 加密salt */
extern NSString *const kStorageSaltKey;

#pragma mark - Extra

extern NSString *const kQiniuTokenKey;