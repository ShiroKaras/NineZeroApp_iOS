//
//  HTModel.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/7.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTLoginUser : NSObject

@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_password;
@property (nonatomic, copy) NSString *user_mobile;
@property (nonatomic, copy) NSString *user_email;
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, copy) NSString *user_area_id;     // 用户所在城市ID
@property (nonatomic, copy) NSString *code;             // 验证码

@end

@interface HTQuestion : NSObject

@end
