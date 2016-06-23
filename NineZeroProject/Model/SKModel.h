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
@property (nonatomic, strong) NSString *questionID;          // 唯一标识ID
@property (nonatomic, strong) NSString *endTime;             // 截止时间
@property (nonatomic, strong) NSString *updateTime;          // 更新时间
@property (nonatomic, strong) NSString *questionCount;       // 题目总数量
@end

@interface SKQuestion : NSObject
@property (nonatomic, strong) NSString *questionID;          // 唯一标识ID
@property (nonatomic, strong) NSString *serial;              // 章节
@property (nonatomic, strong) NSString *type;                // 问题类型(0 ar, 1 文字)
@property (nonatomic, strong) NSString *areaID;              // 用户所在城市ID
@property (nonatomic, strong) NSString *rewardID;            // 奖励ID
@property (nonatomic, strong) NSString *use_time;            // 回答问题使用的时间
@property (nonatomic, strong) NSString *gold;                // 回答问题使用的金币
@property (nonatomic, assign) BOOL isPassed;                  // 是否闯关成功
@property (nonatomic, strong) NSArray<NSString *> *answers;   // 答案
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
@property (nonatomic, strong) id data;                      // 返回数据
@property (nonatomic, strong) NSString *method;             // 方法名
@property (nonatomic, assign) NSUInteger resultCode;         // 结果code
@property (nonatomic, strong) NSString *message;            // 结果信息
@end

@interface SKArticle : NSObject
@property (nonatomic, strong) NSString *mascotID;         // 零仔ID（为0代表停赛日文章）
@property (nonatomic, strong) NSString *articleID;        // 文章ID
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *articleURL;        // 文章链接
@property (nonatomic, strong) NSString *articleTitle;      // 文章标题 (缺)
@property (nonatomic, strong) NSString *article_subtitle;  // 文章副标题
@property (nonatomic, strong) NSString *articleConverURL;  // 文章封面url (缺)
@property (nonatomic, strong) NSString *hasRead;           // 是否已读
@property (nonatomic, strong) NSString *article_content;
@property (nonatomic, strong) NSString *article_pic;
@property (nonatomic, strong) NSString *article_pic_1;
@property (nonatomic, strong) NSString *article_pic_2;
@property (nonatomic, strong) NSString *publish_time;
@property (nonatomic, assign) BOOL is_collect;
@end

// 零仔
@interface SKMascot : NSObject
@property (nonatomic, strong) NSString *mascotID;             // 零仔ID
@property (nonatomic, strong) NSString *getTime;              // 获取时间
@property (nonatomic, strong) NSString *mascotName;            // 零仔名称
@property (nonatomic, strong) NSString *mascotPic;             // 零仔图片
@property (nonatomic, strong) NSString *mascotDescription;     // 零仔描述
@property (nonatomic, strong) NSString *pet_gif;               // 零仔的gif图
@property (nonatomic, strong) NSString *articles;              //文章数
@property (nonatomic, strong) NSString *unread_articles;       //未读文章数
@property (nonatomic, strong) NSArray<SKArticle *> *article_list;  // 文章
@end

// 零仔道具
@interface SKMascotProp : NSObject
@property (nonatomic, strong) NSString *prop_id;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *exchange_time;
@property (nonatomic, strong) NSString *prop_icon;
@property (nonatomic, strong) NSString *prop_pic;
@property (nonatomic, strong) NSString *prop_gif;
@property (nonatomic, strong) NSString *prop_name;
@property (nonatomic, strong) NSString *prop_desc;
@property (nonatomic, assign) BOOL used;
@property (nonatomic, assign) BOOL prop_exchange;
@end

@interface SKReward : NSObject
@end

// 礼券
@interface SKTicket : NSObject
@property (nonatomic, strong) NSString *ticket_id;              // 礼券id
@property (nonatomic, strong) NSString *code;                   // 兑换码
@property (nonatomic, strong) NSString *create_time;            // 创建时间
@property (nonatomic, assign) BOOL used;                         // 是否已经兑换
@property (nonatomic, strong) NSString *used_time;              // 兑换时间
@property (nonatomic, strong) NSString *type;                   // type
@property (nonatomic, strong) NSString *title;                   // 标题
@property (nonatomic, strong) NSString *pic;                     // 封面名字
@property (nonatomic, strong) NSString *address;                 // 地点
@property (nonatomic, strong) NSString *mobile;                  // 手机号
@property (nonatomic, strong) NSString *expire_time;            // 失效时间
@property (nonatomic, strong) NSString *total_num;              // 总共多少张礼券?
@property (nonatomic, strong) NSString *ticket_cover;            //礼券方形封面
@end

@interface SKPrize : NSObject
@end

// 通知单元结构体
@interface SKNotification : NSObject
@property (nonatomic, strong) NSString *notice_id;            // 消息id
@property (nonatomic, strong) NSString *user_id;               // 用户id
@property (nonatomic, strong) NSString *time;                  // 通知时间
@property (nonatomic, strong) NSString *content;                // 内容
@end

//@interface SKProfileAnswer : NSObject
//@property (nonatomic, strong) NSUInteger user_id;
//@property (nonatomic, strong) NSUInteger qid;
//@property (nonatomic, strong) NSUInteger answer_time;
//@property (nonatomic, strong) NSUInteger use_time;
//@property (nonatomic, strong) NSUInteger gold;
//@property (nonatomic, strong) NSString *question_video_cover;
//@end

@interface SKProfileInfo : NSObject
@property (nonatomic, strong) NSString *gold;
@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSString *ticketCount;
@property (nonatomic, strong) NSString *medalCount;
@property (nonatomic, strong) NSString *propCount;
@property (nonatomic, strong) NSString *articleCount;
@property (nonatomic, strong) NSString *noticeCount;
@property (nonatomic, strong) NSArray<SKQuestion *> *answer_list;
@end

@interface SKUserInfo : NSObject <NSCopying>
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_avatar;
@property (nonatomic, strong) NSString *user_avatar_url;
@property (nonatomic, strong) NSString *mobile;                 // 个人设置里跟随地址填的电话号码
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) BOOL push_setting;
@property (nonatomic, strong) NSString *settingType;                  // 更改配置的类型,本地用
@end

// 排名单元
@interface SKRanker : NSObject
@property (nonatomic, strong) NSString *gold;          // 金币
@property (nonatomic, strong) NSString *rank;          // 排名
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_avatar;    // 头像(名？)
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *area_name;
@end

// 金币记录
@interface SKGoldRecord : NSObject
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *description;
@end

// 勋章
@interface SKBadge : NSObject
@property (nonatomic, assign) BOOL have;
@property (nonatomic, strong) NSString *medal_description;
@property (nonatomic, strong) NSString *medal_icon;
@property (nonatomic, strong) NSString *medal_id;
@property (nonatomic, strong) NSString *medal_level;         // 拿到这个勋章需要的金币数
@property (nonatomic, strong) NSString *medal_name;
@property (nonatomic, strong) NSString *medal_pic;
@end
