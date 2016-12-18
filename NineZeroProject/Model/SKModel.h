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
@end

//用户个人页信息
@interface SKProfileInfo : NSObject
@property (nonatomic, copy) NSString *user_gold;                //金币数
@property (nonatomic, copy) NSString *piece_num;                //玩意儿数
@property (nonatomic, copy) NSString *ticket_num;               //礼券数
@property (nonatomic, copy) NSString *rank;                     //排名
@property (nonatomic, copy) NSString *user_gemstone;            //宝石
@property (nonatomic, copy) NSString *medal_num;                //勋章
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

//首页
@interface SKIndexInfo : NSObject
@property (nonatomic, assign)   BOOL        isMonday;
@property (nonatomic, assign)   BOOL        is_haved_difficult;
@property (nonatomic, assign)   NSInteger   user_notice_count;
@property (nonatomic, copy)     NSString    *index_gif;
    //question_info
@property (nonatomic, assign)   time_t      question_end_time;
@property (nonatomic, copy)     NSString    *qid;
@property (nonatomic, assign)   BOOL        answered_status;
    //Monday
@property (nonatomic, assign)   time_t      monday_end_time;
    //advertising
@property (nonatomic, copy)     NSString    *adv_pic;
@end

@interface SKQuestion : NSObject
@property (nonatomic, copy)     NSString    *id;
@property (nonatomic, copy)     NSString    *qid;
@property (nonatomic, copy)     NSString    *serial;
@property (nonatomic, copy)     NSString    *area_id;
@property (nonatomic, copy)     NSString    *chapter;
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
@property (nonatomic, assign)   NSInteger   base_type;                 //0:文字类型  1:扫图片  2:LBS
@property (nonatomic, assign)   NSInteger   level_type;                 //0:极难题  1:第一季  2:第二季
@property (nonatomic, assign)   BOOL        is_answer;
@property (nonatomic, assign)   NSInteger   clue_count;                 //用户线索条数
@property (nonatomic, assign)   NSInteger   answer_count;               //用户答案条数
@property (nonatomic, assign)   BOOL        num;                       //答案道具数量
@end

@interface SKMascotProp : NSObject
@end

@interface SKTicket : NSObject
@end

@interface SKBadge : NSObject
@end


