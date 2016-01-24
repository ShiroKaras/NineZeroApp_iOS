//
//  HTModel.h
//  NineZeroProject
//
//  Created by ronhu on 15/12/7.
//  Copyright © 2015年 ronhu. All rights reserved.
//

#import <Foundation/Foundation.h>

// 不要覆盖description方法
@interface NSObject (PropertyPrint)
- (NSString *)ht_description;
@end

@interface HTLoginUser : NSObject

@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_password;
@property (nonatomic, copy) NSString *user_mobile;
@property (nonatomic, copy) NSString *user_email;
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, copy) NSString *user_area_id;     // 用户所在城市ID
@property (nonatomic, copy) NSString *code;             // 验证码

@end

@interface HTQuestionInfo : NSObject

@property (nonatomic, assign) NSUInteger questionID;          // 唯一标识ID
@property (nonatomic, assign) NSUInteger endTime;             // 截止时间
@property (nonatomic, assign) NSUInteger updateTime;          // 更新时间
@property (nonatomic, assign) NSUInteger questionCount;       // 题目总数量

@end

@interface HTQuestion : NSObject

@property (nonatomic, assign) NSUInteger questionID;          // 唯一标识ID
@property (nonatomic, assign) NSUInteger serial;              // 章节
@property (nonatomic, assign) NSUInteger type;                // 问题类型
@property (nonatomic, assign) NSUInteger areaID;              // 用户所在城市ID
@property (nonatomic, assign) NSUInteger rewardID;            // 奖励ID
@property (nonatomic, strong) NSArray<NSString *> *answers;   // 答案
@property (nonatomic, copy) NSString *chapterText;            // 章节名
@property (nonatomic, copy) NSString *content;                // 问题内容
@property (nonatomic, copy) NSString *questionDescription;    // 问题描述
@property (nonatomic, copy) NSString *descriptionPic;         // 题目描述配图
@property (nonatomic, copy) NSString *vedioURL;               // 视频链接
@property (nonatomic, copy) NSString *detailURL;              // 详情链接
@property (nonatomic, copy) NSString *hint;                   // 提示

@end

@interface HTResponsePackage : NSObject

@property (nonatomic, strong) id data;                    // 返回数据
@property (nonatomic, strong) NSString *method;           // 方法名
@property (nonatomic, assign) NSInteger resultCode;       // 结果code
@property (nonatomic, strong) NSString *resultMsg;        // 结果信息

@end

// 零仔道具
@interface HTMascotProp : NSObject
@end
