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
@property (nonatomic, copy) NSString *vedioName;              // 视频名称
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

@property (nonatomic, assign) NSUInteger mascotID;         // 零仔ID（为0代表停赛日文章）
@property (nonatomic, assign) NSUInteger articleID;        // 文章ID
@property (nonatomic, assign) NSUInteger time;
@property (nonatomic, strong) NSString *articleURL;        // 文章链接
@property (nonatomic, strong) NSString *articleTitle;      // 文章标题 (缺)
@property (nonatomic, strong) NSString *articleConverURL;  // 文章封面url (缺)
@property (nonatomic, assign) NSInteger hasRead;           // 是否已读
@property (nonatomic, strong) NSString *article_content;
@property (nonatomic, strong) NSString *article_pic;
@property (nonatomic, strong) NSString *publish_time;

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

// 礼券
@interface HTReward : NSObject
@property (nonatomic, assign) NSUInteger ticket_id;              // 礼券id
@property (nonatomic, assign) NSUInteger code;                   // 兑换码
@property (nonatomic, assign) NSUInteger create_time;            // 创建时间
@property (nonatomic, assign) BOOL used;                         // 是否已经兑换
@property (nonatomic, assign) NSUInteger used_time;              // 兑换时间
@property (nonatomic, assign) NSUInteger type;                   // type
@property (nonatomic, strong) NSString *title;                   // 标题
@property (nonatomic, strong) NSString *pic;                     // 封面名字
@property (nonatomic, strong) NSString *coverPickURL;            // 封面链接
@property (nonatomic, strong) NSString *address;                 // 地点
@property (nonatomic, strong) NSString *mobile;                  // 手机号
@property (nonatomic, assign) NSUInteger expire_time;            // 失效时间
@property (nonatomic, assign) NSUInteger total_num;              // 总共多少张礼券?
@end

// 通知单元结构体
@interface HTNotification : NSObject
@property (nonatomic, assign) NSUInteger notice_id;            // 消息id
@property (nonatomic, assign) NSUInteger user_id;               // 用户id
@property (nonatomic, assign) NSUInteger time;                  // 通知时间
@property (nonatomic, strong) NSString *content;                // 内容
@end

@interface HTProfileAnswer : NSObject
@property (nonatomic, assign) NSUInteger user_id;
@property (nonatomic, assign) NSUInteger qid;
@property (nonatomic, assign) NSUInteger answer_time;
@property (nonatomic, assign) NSUInteger user_time;
@end

@interface HTProfileInfo : NSObject
@property (nonatomic, strong) NSString *gold;
@property (nonatomic, strong) NSString *ticket;
@property (nonatomic, strong) NSString *notice;
@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSString *article;
@property (nonatomic, strong) NSString *medal;
@property (nonatomic, strong) NSArray<HTProfileAnswer *> *answer_list;
@end

@interface HTUserInfo : NSObject
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_avatar;
@property (nonatomic, strong) NSString *mobile;                 // 个人设置里跟随地址填的电话号码
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) BOOL push_setting;
@property (nonatomic, assign) int settingType;                  // 更改配置的类型,本地用
@end

// 排名单元
@interface HTRanker : NSObject
@property (nonatomic, assign) NSUInteger gold;          // 金币
@property (nonatomic, assign) NSUInteger rank;          // 排名
@property (nonatomic, assign) NSUInteger user_id;
@property (nonatomic, strong) NSString *user_avatar;    // 头像(名？)
@property (nonatomic, strong) NSString *user_name;
@end

// 勋章
@interface HTBadge : NSObject
@property (nonatomic, assign) BOOL have;
@property (nonatomic, strong) NSString *medal_description;
@property (nonatomic, strong) NSString *medal_icon;
@property (nonatomic, assign) NSUInteger medal_id;
@property (nonatomic, strong) NSString *medal_level;         // 拿到这个勋章需要的金币数
@property (nonatomic, strong) NSString *medal_name;
@property (nonatomic, strong) NSString *medal_pic;
@end
