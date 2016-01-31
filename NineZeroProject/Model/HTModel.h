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
- (NSString *)debugDescription;
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
@property (nonatomic, assign) NSUInteger type;                // 问题类型(1 ar, 2 文字)
@property (nonatomic, assign) NSUInteger areaID;              // 用户所在城市ID
@property (nonatomic, assign) NSUInteger rewardID;            // 奖励ID
@property (nonatomic, assign) BOOL isPassed;                  // 是否闯关成功
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

@interface HTArticle : NSObject

@property (nonatomic, assign) NSUInteger mascotID;         // 零仔ID
@property (nonatomic, assign) NSUInteger articleID;        // 文章ID
@property (nonatomic, strong) NSString *articleURL;        // 文章链接
@property (nonatomic, strong) NSString *articleTitle;      // 文章标题 (缺)
@property (nonatomic, strong) NSString *articleConverURL;  // 文章封面url (缺)
@property (nonatomic, assign) NSInteger hasRead;           // 是否已读

@end

// 零仔
@interface HTMascot : NSObject

@property (nonatomic, assign) NSUInteger mascotID;             // 零仔ID
@property (nonatomic, assign) NSUInteger getTime;              // 获取时间
@property (nonatomic, strong) NSString *mascotName;            // 零仔名称
@property (nonatomic, strong) NSString *mascotPic;             // 零仔图片
@property (nonatomic, strong) NSString *mascotDescription;     // 零仔描述
@property (nonatomic, strong) NSArray<HTArticle *> *articles;  // 文章

@end

// 零仔道具
@interface HTMascotProp : NSObject

@property (nonatomic, assign) NSUInteger propID;                // 道具id
@property (nonatomic, assign) NSUInteger getTime;               // 获取时间
@property (nonatomic, assign) NSUInteger exchangedTime;         // 兑换时间
@property (nonatomic, strong) NSString *iconName;               // icon名称
@property (nonatomic, strong) NSString *propPicName;            // 图片名称
@property (nonatomic, strong) NSString *iconURL;                // icon
@property (nonatomic, strong) NSString *propPicURL;             // 图片URL
@property (nonatomic, strong) NSString *propName;               // 道具名称
@property (nonatomic, strong) NSString *propDescription;        // 道具描述
@property (nonatomic, assign) BOOL isUsed;                      // 是否已经使用
@property (nonatomic, assign) BOOL isExchanged;                 // 是否已经兑换

@end
