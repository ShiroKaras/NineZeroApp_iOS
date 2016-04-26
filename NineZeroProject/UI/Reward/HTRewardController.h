//
//  HTRewardController.h
//  NineZeroProject
//
//  Created by HHHHTTTT on 16/1/26.
//  Copyright © 2016年 HHHHTTTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTMascot;
@class HTMascotProp;
@class HTTicket;

@interface HTRewardController : UIViewController
- (instancetype)initWithRewardID:(uint64_t)rewardID questionID:(uint64_t)qid;
@end
