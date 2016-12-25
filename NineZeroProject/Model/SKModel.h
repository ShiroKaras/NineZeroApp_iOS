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

//用户基本信息
@interface SKUserInfo : NSObject
@property (nonatomic, copy)     NSString    *user_id;
@property (nonatomic, copy)     NSString    *user_name;
@property (nonatomic, copy)     NSString    *user_avatar;
@property (nonatomic, copy)     NSString    *gold;
@property (nonatomic, assign)   NSInteger   rank;

@property (nonatomic, assign)   int         push_setting;   // 推送开关
@end

//用户个人页信息
@interface SKProfileInfo : NSObject
@property (nonatomic, copy)     NSString    *user_gold;                 //金币数
@property (nonatomic, copy)     NSString    *user_experience_value;     //经验值
@property (nonatomic, copy)     NSString    *piece_num;                 //玩意儿数
@property (nonatomic, copy)     NSString    *ticket_num;                //礼券数
@property (nonatomic, copy)     NSString    *rank;                      //排名
@property (nonatomic, copy)     NSString    *user_gemstone;             //宝石
@property (nonatomic, copy)     NSString    *medal_num;                 //勋章
@property (nonatomic, assign)   BOOL        user_gold_head;             //是否有头像边框
@end

//首页
@interface SKIndexInfo : NSObject
@property (nonatomic, assign)   BOOL        isMonday;
@property (nonatomic, assign)   BOOL        is_haved_difficult;
@property (nonatomic, assign)   NSInteger   user_notice_count;
@property (nonatomic, copy)     NSString    *index_gif;
//    //question_info
@property (nonatomic, assign)   uint64_t      question_end_time;
@property (nonatomic, copy)     NSString    *qid;
@property (nonatomic, assign)   BOOL        answered_status;
//    //Monday
@property (nonatomic, assign)   uint64_t      monday_end_time;
//    //advertising
@property (nonatomic, copy)     NSString    *adv_pic;
@end

@interface SKQuestion : NSObject
@property (nonatomic, copy)     NSString    *id;
@property (nonatomic, copy)     NSString    *qid;
@property (nonatomic, copy)     NSString    *serial;
@property (nonatomic, copy)     NSString    *area_id;
@property (nonatomic, copy)     NSString    *chapter;
@property (nonatomic, copy)     NSString    *title_one;
@property (nonatomic, copy)     NSString    *title_two;
@property (nonatomic, copy)     NSString    *content;
@property (nonatomic, copy)     NSString    *thumbnail_pic;
@property (nonatomic, copy)     NSString    *description_pic;
@property (nonatomic, copy)     NSString    *description_url;
@property (nonatomic, copy)     NSString    *question_video;
@property (nonatomic, copy)     NSString    *question_video_url;
@property (nonatomic, copy)     NSString    *question_answer;
@property (nonatomic, copy)     NSString    *question_ar_loaction;
@property (nonatomic, copy)     NSString    *question_ar_pet;
@property (nonatomic, copy)     NSString    *reward_id;
@property (nonatomic, copy)     NSString    *hint;
@property (nonatomic, copy)     NSString    *hint_1;
@property (nonatomic, copy)     NSString    *hint_2;
@property (nonatomic, copy)     NSString    *question_video_cover;
@property (nonatomic, copy)     NSString    *checkpoint_pic;
@property (nonatomic, assign)   NSInteger   base_type;                  //0:文字类型  1:扫图片  2:LBS
@property (nonatomic, assign)   NSInteger   level_type;                 //0:极难题  1:第一季  2:第二季
@property (nonatomic, assign)   BOOL        is_answer;
@property (nonatomic, assign)   NSInteger   clue_count;                 //用户线索条数
@property (nonatomic, assign)   NSInteger   answer_count;               //用户答案条数
@property (nonatomic, assign)   NSInteger   num;                        //答案道具数量
@end

@interface SKHintList : NSObject
@property (nonatomic, assign)   NSInteger   num;        //线索数量
@property (nonatomic, copy)     NSString    *hint_one;
@property (nonatomic, copy)     NSString    *hint_two;
@property (nonatomic, copy)     NSString    *hint_three;
@end

@interface SKAnswerDetail : NSObject
@property (nonatomic, copy)     NSString    *area_id;

@property (nonatomic, copy)     NSString    *pet_id;
@property (nonatomic, copy)     NSString    *qid;
@property (nonatomic, copy)     NSString    *article_title;
@property (nonatomic, copy)     NSString    *article_desc;
@property (nonatomic, copy)     NSString    *article_subtitle;
@property (nonatomic, copy)     NSString    *article_pic;
@property (nonatomic, copy)     NSString    *article_pic_1;
@property (nonatomic, copy)     NSString    *article_pic_2;
@property (nonatomic, copy)     NSString    *article_video_url;
@end

@interface SKMascotProp : NSObject
@end

@interface SKTicket : NSObject
@property (nonatomic, copy)     NSString    *ticket_id;
@property (nonatomic, copy)     NSString    *user_id;
@property (nonatomic, copy)     NSString    *sid;
@property (nonatomic, copy)     NSString    *code;
@property (nonatomic, assign)   uint64_t      create_time;
@property (nonatomic, assign)   uint64_t      expire_time;
@property (nonatomic, assign)   uint64_t      used_time;
@property (nonatomic, assign)   BOOL        used;
@property (nonatomic, copy)     NSString    *title;
@property (nonatomic, copy)     NSString    *pic;
@property (nonatomic, copy)     NSString    *address;
@property (nonatomic, copy)     NSString    *mobile;
@property (nonatomic, copy)     NSString    *ticket_cover;
@property (nonatomic, copy)     NSString    *remarks;           //描述
@property (nonatomic, copy)     NSString    *type;

@property (nonatomic, copy)     NSString    *item_id;
@property (nonatomic, copy)     NSString    *item_name;
@property (nonatomic, copy)     NSString    *item_type;
@property (nonatomic, copy)     NSString    *item_num;
@property (nonatomic, copy)     NSString    *extra_data;
@end

@interface SKPet : NSObject
@property (nonatomic, copy)     NSString    *fid;
@property (nonatomic, copy)     NSString    *pet_gif;

@property (nonatomic, assign)   NSInteger   pet_id;
@property (nonatomic, copy)     NSString    *pet_desc;
@property (nonatomic, copy)     NSString    *pet_name;
@property (nonatomic, assign)   BOOL        user_haved;

@property (nonatomic, assign)   NSInteger   pet_num;
@property (nonatomic, assign)   NSInteger   pet_pic;
@end

@interface SKPiece : NSObject
@property (nonatomic, copy)     NSString    *piece_name;
@property (nonatomic, copy)     NSString    *piece_describe_pic;
@property (nonatomic, copy)     NSString    *piece_cover_pic;
@property (nonatomic, copy)     NSString    *piece_describtion;
@property (nonatomic, copy)     NSString    *time;
@property (nonatomic, copy)     NSString    *expire_time;
@end

//用户奖励
@interface SKReward : NSObject
@property (nonatomic, copy)     NSString    *reward_id;
@property (nonatomic, copy)     NSString    *gold;
@property (nonatomic, copy)     NSString    *experience_value;
@property (nonatomic, copy)     NSString    *gemstone;
@property (nonatomic, assign)   NSInteger   rank;
@property (nonatomic, strong)   SKPet       *pet;
@property (nonatomic, strong)   SKPiece     *piece;
@property (nonatomic, strong)   SKTicket    *ticket;
@end

@interface SKBadge : NSObject
@property (nonatomic, copy)     NSString    *medal_id;
@property (nonatomic, copy)     NSString    *medal_name;
@property (nonatomic, copy)     NSString    *medal_level;
@property (nonatomic, copy)     NSString    *medal_icon;
@property (nonatomic, copy)     NSString    *medal_pic;
@property (nonatomic, copy)     NSString    *medal_description;
@property (nonatomic, copy)     NSString    *level_type;
@end

@interface SKRanker : NSObject
@property (nonatomic, copy)     NSString    *user_id;
@property (nonatomic, copy)     NSString    *user_name;
@property (nonatomic, copy)     NSString    *user_avatar;
@property (nonatomic, copy)     NSString    *gold;
@property (nonatomic, assign)   NSUInteger  rank;
@property (nonatomic, copy)     NSString    *user_experience_value;
@property (nonatomic, copy)     NSString    *area_name;
@property (nonatomic, assign)   BOOL        user_gold_head;             //是否有头像边框
@end

@interface SKDefaultMascotSkill : NSObject;
@property (nonatomic, assign)   uint64_t      clue_cooling_time;
@property (nonatomic, assign)   uint64_t      answer_cooling_time;
@property (nonatomic, copy)     NSString    *clue_used_gold;
@property (nonatomic, copy)     NSString    *answer_used_gold;
@property (nonatomic, copy)     NSString    *clue_used_gemstone;
@property (nonatomic, copy)     NSString    *answer_used_gemstone;
@end

@interface SKDefaultMascotDetail : NSObject
@property (nonatomic, copy)     NSString    *user_total_gold;
@property (nonatomic, copy)     NSString    *user_gemstone;
@property (nonatomic, strong)   SKDefaultMascotSkill    *first_season;
@property (nonatomic, strong)   SKDefaultMascotSkill    *second_season;
@end

@interface SKNotification : NSObject
@property (nonatomic, assign)   uint64_t notice_id;             // 消息id
@property (nonatomic, assign)   uint64_t user_id;               // 用户id
@property (nonatomic, assign)   uint64_t time;                  // 通知时间
@property (nonatomic, assign)   uint64_t title;                 // 通知标题
@property (nonatomic, strong)   NSString *content;              // 内容
@end

//扫一扫
@interface SKScanning : NSObject
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *status;       //状态（1：活动开启，0：活动关闭
@property (nonatomic, copy) NSString *hint;
@property (nonatomic, copy) NSString *reward_id;
@property (nonatomic, copy) NSString *file_url;
@property (nonatomic, copy) NSString *file_url_true;
@property (nonatomic, copy) NSString *link_url;
@property (nonatomic, copy) NSString *link_type;    //链接类型（0：视频，1：GIF图，2：图片）
@end