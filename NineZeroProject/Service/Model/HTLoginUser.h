//
//  HTLoginUser.h
//  NineZeroProject
//
//  Created by ronhu on 15/11/15.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTLoginUser : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *userAreaID;   // 用户所在城市ID
@property (nonatomic, copy) NSString *authCode;     // 验证码

@end
