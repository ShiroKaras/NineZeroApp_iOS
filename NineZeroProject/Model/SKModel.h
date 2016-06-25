//
//  SKModel.h
//  NineZeroProject
//
//  Created by SinLemon on 16/6/20.
//  CopyrigSK © 2016年 ronhu. All rigSKs reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

// 不要覆盖description方法
@interface NSObject (PropertyPrintf)
- (NSString *)debugDescription;
@end

@interface SKLoginUser : NSObject
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_password;
@property (nonatomic, copy) NSString *user_mobile;
@property (nonatomic, copy) NSString *user_email;
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, copy) NSString *user_area_id;     //用户所在城市ID
@property (nonatomic, copy) NSString *code;             //验证码
@property (nonatomic, copy) NSString *third_id;         //第三方平台ID
@property (nonatomic, copy) NSString *token;            //login token
@end

@interface SKQuestionInfo : NSObject
@property (nonatomic, copy) NSString *questionID;          // 唯一标识ID
@property (nonatomic, copy) NSString *endTime;             // 截止时间
@property (nonatomic, copy) NSString *updateTime;          // 更新时间
@property (nonatomic, copy) NSString *questionCount;       // 题目总数量
@end

@interface SKQuestion : NSObject
@property (nonatomic, copy) NSString *questionID;          // 唯一标识ID
@property (nonatomic, copy) NSString *serial;              // 章节
@property (nonatomic, copy) NSString *type;                // 问题类型(0 ar, 1 文字)
@property (nonatomic, copy) NSString *areaID;              // 用户所在城市ID
@property (nonatomic, copy) NSString *rewardID;            // 奖励ID
@property (nonatomic, copy) NSString *use_time;            // 回答问题使用的时间
@property (nonatomic, copy) NSString *gold;                // 回答问题使用的金币
@property (nonatomic, assign) BOOL isPassed;                  // 是否闯关成功
@property (nonatomic, copy) NSArray<NSString *> *answers;   // 答案
@property (nonatomic, copy) NSString *chapterText;            // 章节名
@property (nonatomic, copy) NSString *content;                // 问题内容
@property (nonatomic, copy) NSString *questionDescription;    // 问题描述
@property (nonatomic, copy) NSString *descriptionPic;         // 题目描述配图
@property (nonatomic, copy) NSString *descriptionURL;         // 题目描述配图URL
@property (nonatomic, copy) NSString *videoURL;               // 视频链接
@property (nonatomic, copy) NSString *videoName;              // 视频名称
@property (nonatomic, copy) NSString *detailURL;              // 详情链接
@property (nonatomic, copy) NSString *hint;                   // 提示
@property (nonatomic, copy) NSString *question_ar_location;   // ar
@property (nonatomic, copy) NSString *question_ar_pet;        // ar的gif
@property (nonatomic, copy) NSString *question_video_cover;   // vedio的封面
@end

@interface SKResponsePackage : NSObject
@property (nonatomic, copy) id data;                      // 返回数据
@property (nonatomic, copy) NSString *method;             // 方法名
@property (nonatomic, assign) NSUInteger resultCode;         // 结果code
@property (nonatomic, copy) NSString *message;            // 结果信息
@end

@interface SKArticle : NSObject
@property (nonatomic, copy) NSString *mascotID;         // 零仔ID（为0代表停赛日文章）
@property (nonatomic, copy) NSString *articleID;        // 文章ID
@property (nonatomic, copy) NSString *articleTitle;      // 文章标题 (缺)
@property (nonatomic, copy) NSString *article_subtitle;  // 文章副标题
@property (nonatomic, copy) NSString *articleConverURL;  // 文章封面url (缺)
@property (nonatomic, copy) NSString *hasRead;           // 是否已读
@property (nonatomic, copy) NSString *articleURL;        // 文章链接
@property (nonatomic, copy) NSString *article_content;
@property (nonatomic, copy) NSString *article_pic;
@property (nonatomic, copy) NSString *article_pic_1;
@property (nonatomic, copy) NSString *article_pic_2;
@property (nonatomic, copy) NSString *publish_time;
@property (nonatomic, assign) BOOL is_collect;
@end

// 零仔
@interface SKMascot : NSObject
@property (nonatomic, copy) NSString *mascotID;             // 零仔ID
@property (nonatomic, copy) NSString *mascotName;            // 零仔名称
@property (nonatomic, copy) NSString *getTime;              // 获取时间
@property (nonatomic, copy) NSString *mascotPic;             // 零仔图片
@property (nonatomic, copy) NSString *mascotGif;               // 零仔的gif图
@property (nonatomic, copy) NSString *mascotDescription;     // 零仔描述
@property (nonatomic, copy) NSString *articles;              //文章数
@property (nonatomic, copy) NSString *unread_articles;       //未读文章数
@property (nonatomic, copy) NSArray<SKArticle *> *article_list;  // 文章
@end

// 零仔道具
@interface SKMascotProp : NSObject
@property (nonatomic, copy) NSString *prop_id;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *exchange_time;
@property (nonatomic, copy) NSString *prop_icon;
@property (nonatomic, copy) NSString *prop_pic;
@property (nonatomic, copy) NSString *prop_gif;
@property (nonatomic, copy) NSString *prop_name;
@property (nonatomic, copy) NSString *prop_desc;
@property (nonatomic, assign) BOOL used;
@property (nonatomic, assign) BOOL prop_exchange;
@end

@interface SKReward : NSObject
@end

// 礼券
@interface SKTicket : NSObject
@property (nonatomic, copy) NSString *ticket_id;              // 礼券id
@property (nonatomic, copy) NSString *code;                   // 兑换码
@property (nonatomic, copy) NSString *create_time;            // 创建时间
@property (nonatomic, assign) BOOL used;                        // 是否已经兑换
@property (nonatomic, copy) NSString *used_time;              // 兑换时间
@property (nonatomic, copy) NSString *type;                   // type
@property (nonatomic, copy) NSString *title;                  // 标题
@property (nonatomic, copy) NSString *pic;                    // 封面名字
@property (nonatomic, copy) NSString *address;                // 地点
@property (nonatomic, copy) NSString *mobile;                 // 手机号
@property (nonatomic, copy) NSString *expire_time;            // 失效时间
@property (nonatomic, copy) NSString *total_num;              // 总共多少张礼券?
@property (nonatomic, copy) NSString *ticket_cover;           //礼券方形封面
@end

@interface SKPrize : NSObject
@end

// 通知单元结构体
@interface SKNotification : NSObject
@property (nonatomic, copy) NSString *notice_id;              // 消息id
@property (nonatomic, copy) NSString *user_id;                // 用户id
@property (nonatomic, copy) NSString *time;                   // 通知时间
@property (nonatomic, copy) NSString *title;                  // 通知标题
@property (nonatomic, copy) NSString *content;                // 内容
@end

//@interface SKProfileAnswer : NSObject
//@property (nonatomic, copy) NSUInteger user_id;
//@property (nonatomic, copy) NSUInteger qid;
//@property (nonatomic, copy) NSUInteger answer_time;
//@property (nonatomic, copy) NSUInteger use_time;
//@property (nonatomic, copy) NSUInteger gold;
//@property (nonatomic, copy) NSString *question_video_cover;
//@end

@interface SKProfileInfo : NSObject
@property (nonatomic, copy) NSString *gold;
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, copy) NSString *ticketCount;
@property (nonatomic, copy) NSString *medalCount;
@property (nonatomic, copy) NSString *propCount;
@property (nonatomic, copy) NSString *articleCount;
@property (nonatomic, copy) NSString *noticeCount;
@property (nonatomic, copy) NSArray<SKQuestion *> *answer_list;
@end

@interface SKUserInfo : NSObject <NSCopying>
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_avatar;
@property (nonatomic, copy) NSString *user_avatar_url;
@property (nonatomic, copy) NSString *mobile;                 // 个人设置里跟随地址填的电话号码
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) BOOL push_setting;
@property (nonatomic, copy) NSString *settingType;                  // 更改配置的类型,本地用
@end

// 排名单元
@interface SKRanker : NSObject
@property (nonatomic, assign) NSUInteger gold;          // 金币
@property (nonatomic, assign) NSUInteger rank;          // 排名
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_avatar;    // 头像(名？)
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *city_code;
@end

// 金币记录
@interface SKGoldRecord : NSObject
@property (nonatomic, copy) NSString *goldNumber;
@property (nonatomic, copy) NSString *goldDescription;
@end

// 勋章
@interface SKBadge : NSObject
@property (nonatomic, assign) BOOL have;
@property (nonatomic, copy) NSString *medal_description;
@property (nonatomic, copy) NSString *medal_icon;
@property (nonatomic, copy) NSString *medal_id;
@property (nonatomic, copy) NSString *medal_level;         // 拿到这个勋章需要的金币数
@property (nonatomic, copy) NSString *medal_name;
@property (nonatomic, copy) NSString *medal_pic;
@end
