//
//  SKModel.h
//  NineZeroProject
//
//  Created by SinLemon on 2016/12/1.
//  Copyright © 2016年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

// 基本返回包
@interface SKResponsePackage : NSObject
@property (nonatomic, strong) id data;                      // 返回数据
@property (nonatomic, strong) NSString *method;             // 方法名
@property (nonatomic, assign) NSInteger result;             // 结果code
@end

//登录信息
@interface SKLoginUser : NSObject

@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_password;
@property (nonatomic, copy) NSString *user_mobile;
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, copy) NSString *user_area_id;         // 用户所在城市ID
@property (nonatomic, copy) NSString *code;                 // 验证码
@property (nonatomic, copy) NSString *third_id;             // 第三方平台ID

@end

//用户设置
@interface SKUserSetting : NSObject

@property (nonatomic, copy)     NSString    *address;       // 收货地址
@property (nonatomic, copy)     NSString    *mobile;        // 收货电话
@property (nonatomic, assign)   int         push_setting;   // 推送开关

@end

//用户奖励
@interface SKReward : NSObject

@end
